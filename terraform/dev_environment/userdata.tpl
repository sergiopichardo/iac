#!/bin/bash
# Update package lists
sudo apt-get update -y
# Install prerequisites for Docker
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
# Set up the stable repository
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# Update package lists again
sudo apt-get update -y
# Install Docker CE, Docker CE CLI, and Containerd
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
# Add the default user to the Docker group
sudo usermod -aG docker ubuntu

