# ALB for ASG and its components
resource "aws_lb" "my_lb" {
  name               = "my-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = module.vpc.public_subnets
  security_groups    = [aws_security_group.for_public_ec2.id]
}

resource "aws_lb_target_group" "my_target_group" {
  name     = "my-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    path = "/"
  }
}

resource "aws_lb_target_group_attachment" "attach_my_ec2" {
  count = length(aws_instance.my_public_ec2_instance.*.id)
  target_group_arn = aws_lb_target_group.my_target_group.arn
  target_id        = aws_instance.my_public_ec2_instance.*.id[count.index]
  port             = 80
}

resource "aws_lb_listener" "my_listener" {
  load_balancer_arn = aws_lb.my_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }
}