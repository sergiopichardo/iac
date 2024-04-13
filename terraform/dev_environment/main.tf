resource "aws_vpc" "dev_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dev-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true # instances launch into the subnet 
  # should be assigned a public IP address
  availability_zone = "us-east-1a"

  tags = {
    Name = "dev-public-subnet"
  }
}

resource "aws_internet_gateway" "dev_igw" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "public_dev_rt" {
  vpc_id = aws_vpc.dev_vpc.id
  tags = {
    Name = "dev_public_route_table"
  }
}

resource "aws_route" "default_route" {
  route_table_id            = aws_route_table.public_dev_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.dev_igw.id 
}