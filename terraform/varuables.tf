variable "aws_region" {
  default = "us-east-1"
}

variable "ami_id" {
  default = "ami-0e58b56aa4d64231b" # Amazon Linux 2 AMI in us-east-1
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "blogkey"
}

variable "public_key_path" {
  default = "./id_rsa.pub"
}

variable "ssh_user" {
  default = "ec2-user"
}
