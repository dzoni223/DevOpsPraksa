# Variables definition

variable "aws_secret_key" {
  type    = string
  default = ""
}

variable "aws_access_key" {
  type    = string
  default = ""
}

variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "ami_name" {
  type    = string
  default = "custom-ami-with-docker-nginx-{{timestamp}}"
}

variable "ami_id" {
  type    = string
  default = "ami-0084a47cc718c111a"
}


source "amazon-ebs" "ubuntu-base" {
  access_key       = var.aws_access_key
  secret_key       = var.aws_secret_key
  region           = var.aws_region
  source_ami       = var.ami_id
  instance_type    = "t2.micro"
  ssh_username     = "ubuntu"
  ami_name         = var.ami_name
  ami_description  = "Custom AMI with Docker and Nginx installed"
  tags = {
    Name = "custom-ami"
  }
}


build {
  sources = ["source.amazon-ebs.ubuntu-base"]

  provisioner "ansible" {
    playbook_file = "site.yml"  # Path to your Ansible playbook
  }
}
 
