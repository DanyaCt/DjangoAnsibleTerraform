resource "null_resource" "write_ips_inventory" {
  triggers = {
    aws_instance_ips = join("\n", aws_instance.my_public_ec2_instance.*.public_ip)
  }

  provisioner "local-exec" {
    command = <<EOF
      rm -rf inventory.ini
      echo "[public]" > inventory.ini
      echo "${join("\n", aws_instance.my_public_ec2_instance.*.public_ip)}" >> inventory.ini
      echo "[private]" >> "inventory.ini"
      echo "${join("\n", aws_instance.my_private_ec2_instance.*.private_ip)}" >> inventory.ini
      echo "[public:vars]" >> "inventory.ini"
      echo "database_host='${aws_instance.my_private_ec2_instance.private_ip}'" >> inventory.ini
      echo "[private:vars]" >> inventory.ini
      echo "ansible_ssh_common_args='-o ProxyCommand=\"ssh -W %h:%p -q ubuntu@${aws_instance.my_public_ec2_instance[0].public_ip} -i $(pwd)/${var.keyname}.pem\"'" >> inventory.ini
    EOF
  }
}
