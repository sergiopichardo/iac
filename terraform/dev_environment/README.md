# Development Environment 

Building the infrastructure for a development environment on AWS

## Resources
- [AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Shared Credentials Files](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#shared_credentials_files)
- [AWS Route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) - stand alone routes for an AWS Route Table


### Errors
![Invalid Attribute Error](./assets/invalid_attribute_error.png)

```sh
resource "aws_vpc" "dev_vpc" {
    ...
    assign_generated_ipv6_cidr_block = true
}
```