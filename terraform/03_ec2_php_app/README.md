# Learn Terraform Resources

This repo is a companion repo to the [Define Infrastructure with Terraform Resources](https://developer.hashicorp.com/terraform/tutorials/configuration-language/resource) tutorial, containing Terraform configuration files to provision two publicly EC2 instances and an ELB.

## Other Notes
Send an HTTP request to the EC2 instance output endpoint
```sh
curl $(terraform output -raw domain-name)
```

