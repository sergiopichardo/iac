terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

locals {
    ingress_rules = [
        {
            port = 443
            description = "Ingress rules for port 443"
        }, 
        {
            port = 80
            description = "Ingress rules for port 80"
        }, 
        {
            port = 22
            description = "Ingress rules for port 22 (SSH)"
        }, 
    ]
}

variable "key_name" {
    type = string
    description = "Name of the EC2 key pair"
}

resource "aws_instance" "ec2_example" {
    ami = "ami-051f8a213df8bc089"
    instance_type = "t2.micro"
    key_name = var.key_name
    vpc_security_group_ids = [aws_security_group.main.id]
}

resource "aws_security_group" "main" {
    egress = [
        {
            cidr_blocks = [ "0.0.0.0/0", ],
            description = ""
            from_port = 0
            ipv6_cidr_blocks = []
            prefix_list_ids = []
            protocol = "-1"
            security_groups = []
            self = false
            to_port = 0
        }
    ]

    dynamic "ingress" {
        for_each = local.ingress_rules
        content {
            description = ingress.value.description
            from_port = ingress.value.port
            to_port = ingress.value.port
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
    }

    tags = {
        Name = "Internet + SSH Security Group"
    }
}