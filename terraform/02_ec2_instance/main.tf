terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_instance" "app_server" {
#   ami           = "ami-0c101f26f147fa7fd" # amazon linux 2023
  ami           = "ami-080e1f13689e07408"   # ubuntu 
  instance_type = "t2.micro"

  tags = {
    Name = var.my_instance_name
  }
}


