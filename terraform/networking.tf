resource "aws_vpc" "pysns" {
  cidr_block              = var.vpc_cidr
  instance_tenancy        = "default"
  enable_dns_support      = true
  enable_dns_hostnames    = true

  tags = {
    Name                  = "sns-vpc"
  }
}

resource "aws_internet_gateway" "internet_gw" {
  vpc_id                  = aws_vpc.pysns.id
}

resource "aws_subnet" "public_net" {

  vpc_id                  = aws_vpc.pysns.id
  availability_zone       = var.public_numbers.az
  cidr_block              = cidrsubnet(aws_vpc.pysns.cidr_block, 8, var.public_numbers.network)
  map_public_ip_on_launch = true
  tags = {
    Name                  = "Public prefix"
  }
}

resource "aws_subnet" "private_net" {

  vpc_id = aws_vpc.pysns.id
  availability_zone       = var.private_numbers.az
  cidr_block              = cidrsubnet(aws_vpc.pysns.cidr_block, 8, var.private_numbers.network)
  tags = {
    Name                  = "Private prefix"
  }
}

resource "aws_eip" "eip" {
  vpc                     = true
  depends_on              = [aws_internet_gateway.internet_gw]
}

resource "aws_nat_gateway" "nat_gw" {
    allocation_id         = aws_eip.eip.id
    subnet_id             = aws_subnet.public_net.id
    depends_on            = [aws_internet_gateway.internet_gw]
}

resource "aws_route_table" "public-rt" {
  vpc_id                  = aws_vpc.pysns.id
  tags = {
      Name                = "Public Table"
  }

  route {
    cidr_block            = "0.0.0.0/0"
    gateway_id            = aws_internet_gateway.internet_gw.id
  }
}

resource "aws_route_table" "private-rt" {
  vpc_id                  = aws_vpc.pysns.id
  tags = {
      Name                = "Private Table"
  }

  route {
    cidr_block            = "0.0.0.0/0"
    gateway_id            = aws_nat_gateway.nat_gw.id
  }
}

resource "aws_route_table_association" "public_subnet_association" {
    subnet_id             = aws_subnet.public_net.id
    route_table_id        = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "private_subnet_association" {
    subnet_id             = aws_subnet.private_net.id
    route_table_id        = aws_route_table.private-rt.id
}

resource "aws_security_group" "allow_ssh_and_www_to_alb" {
  name                    = "allow_ssh_and_www_to_alb"
  description             = "Allow SSH and HTTP inbound traffic to ALB"
  vpc_id                  = aws_vpc.pysns.id

  ingress {
    from_port             = 22
    to_port               = 22
    protocol              = "tcp"
    cidr_blocks           = ["185.49.172.0/22"]
  }

  ingress {
    from_port             = 80
    to_port               = 80
    protocol              = "tcp"
    cidr_blocks           = ["185.49.172.0/22"]
  }

  egress {
    from_port             = 0
    to_port               = 0
    protocol              = "-1"
    cidr_blocks           = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_any_ssh_and_www_to_ec2" {
  name                    = "allow_any_ssh_and_www_to_ec2"
  description             = "Allow SSH and HTTP inbound traffic to EC2"
  vpc_id                  = aws_vpc.pysns.id

  ingress {
    from_port             = 22
    to_port               = 22
    protocol              = "tcp"
    cidr_blocks           = ["0.0.0.0/0"]
  }

  ingress {
    from_port             = 80
    to_port               = 80
    protocol              = "tcp"
    cidr_blocks           = ["0.0.0.0/0"]
  }

  egress {
    from_port             = 0
    to_port               = 0
    protocol              = "-1"
    cidr_blocks           = ["0.0.0.0/0"]
  }
}