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

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

# create an api gateway http with integration with eventbridge 
resource "aws_apigatewayv2_api" "MyApiGatewayHTTPApi" {
    name = "Terraform API Gatewy HTTP API to EventBridge"
    protocol_type = "HTTP"
    body = jsondecode({
        "openapi": "3.0.1",
        "info": {
            "title": "API Gateway HTTP API to EventBridge"
        }
    })
}

