provider "aws" {
  region = var.aws_region
}

resource "aws_key_pair" "jenkins_key" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Allow SSH access"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Caution: Open to the world
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins-sg"
  }
}

resource "aws_instance" "jenkins_ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.jenkins_key.key_name
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]  # ✅ attach SG

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
