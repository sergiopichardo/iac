resource "aws_vpc" "dev_vpc" {
  cidr_block                       = "10.123.0.0/16"
  assign_generated_ipv6_cidr_block = true
  enable_dns_hostnames             = true
  enable_dns_support               = true


  tags = {
    Name = "dev-vpc"
  }
}

resource "aws_subnet" "dev_public_subnet" {
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
  route_table_id         = aws_route_table.public_dev_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.dev_igw.id
}

resource "aws_route_table_association" "dev_public_rt_association" {
  subnet_id      = aws_subnet.dev_public_subnet.id
  route_table_id = aws_route_table.public_dev_rt.id
}

resource "aws_security_group" "http_security_group" {
  name        = "HTTP Security Group"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.dev_vpc.id

  tags = {
    Name = "HTTP Security Group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.http_security_group.id
  cidr_ipv4         = aws_vpc.dev_vpc.cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv6" {
  security_group_id = aws_security_group.http_security_group.id
  cidr_ipv6         = aws_vpc.dev_vpc.ipv6_cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.http_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.http_security_group.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_key_pair" "devenv_auth" {
  key_name   = "devenv_key"
  public_key = file("~/.ssh/devenv_key.pub")
}

resource "aws_instance" "dev_server" {
  ami           = data.aws_ami.server_ami.id
  instance_type = "t2.micro"
  key_name = aws_key_pair.devenv_auth.id
  subnet_id = aws_subnet.dev_public_subnet.id
  vpc_security_group_ids = [aws_security_group.http_security_group.id]
  user_data = file("userdata.tpl")

  root_block_device {
    volume_size = 10
  }

  tags = {
    Name = "dev-server"
  }
}

