output "dev_ip" {
    value = aws_instance.dev_server.public_ip
    description = "The public IP of the development server"
}

