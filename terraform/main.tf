provider "aws" {
  region = var.aws_region
}

resource "aws_key_pair" "jenkins_key" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "jenkins_ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = "key-unique-name-1234"  
  tags = {
    Name = "jenkins-ansible-instance"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ../ansible/ec2_ip.txt"
  }

  connection {
    type        = "ssh"
    user        = var.ssh_user
    private_key = file(var.private_key_path)
    host        = self.public_ip
  }
}
