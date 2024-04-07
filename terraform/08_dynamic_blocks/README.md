# Dynamic Blocks

Dynamic blocks in Terraform allow you to create and configure multiple similar blocks within a resource or module based on a predefined set of data or conditions, streamlining repetitive configurations.

Pass the key pair name as an argument when invoking `terraform apply`
```sh
terraform apply -var="key_name=my-key-pair-name"
```