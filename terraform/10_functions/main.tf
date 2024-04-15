terraform {}

variable "example" {
    type = string
    default = "!hello, world!"
}

variable "items" {
    type = list 
    default = [null, false, "", "apples", "oranges"]
}

variable "info" {
    type = map 
    default = {
        "Name" = "Terraform AWS",
        "Provider" = "aws_provider",
        "Count" = 4,
    }
}