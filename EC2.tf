resource "aws_instance" "my_public_ec2_instance" {
  count                       = 2
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = element(module.vpc.public_subnets, 0)
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.for_public_ec2.id]
  key_name                    = var.keyname
}

resource "aws_instance" "my_private_ec2_instance" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = element(module.vpc.private_subnets, 0)
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.for_private_ec2.id]
  key_name                    = var.keyname
}

# Security groups for EC2 instances
resource "aws_security_group" "for_public_ec2" {
  name        = "allow_web_traffic"
  description = "Allow Web inbound traffic"
  vpc_id      = module.vpc.vpc_id

  dynamic "ingress" {
    for_each = ["80", "8000", "22"]
    content {
      description = "HTTP, SSH ports"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "for_private_ec2" {
  name        = "allow_db_traffic"
  description = "Allow db inbound traffic"
  vpc_id      = module.vpc.vpc_id

  dynamic "ingress" {
    for_each = ["5432", "22"]
    content {
      description = "Postgres, SSH ports"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["${aws_instance.my_public_ec2_instance.*.private_ip[0]}/32", "${aws_instance.my_public_ec2_instance.*.public_ip[1]}/32"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}