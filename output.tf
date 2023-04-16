output "public-instance-ip" {
  value = aws_instance.my_public_ec2_instance.*.public_ip
}

output "private-instance-ip" {
  value = aws_instance.my_private_ec2_instance.private_ip
}