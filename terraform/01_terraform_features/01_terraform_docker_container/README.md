# Deploying Docker Container Locally with Terraform 

### Instructions

Initialize the project
```
terraform init
```

Provision the nginx server
```
terraform apply
```

Verify nginx instance
```
docker ps
```
> visit localhost:8000 to see the "Welcome to nginx!" message

Destroy resources
```
terraform destroy
```

