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
  default = "key-unique-name-1234"
}


variable "public_key_path" {
  default = "./id_rsa.pub"
}
variable "private_key_path" {
  description = "Path to the private SSH key"
  default     = "/var/lib/jenkins/.ssh/id_rsa"  # or wherever your private key is
}

variable "ssh_user" {
  default = "ec2-user"
}
