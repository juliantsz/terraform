resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.environment}-VPC"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment} Project VPC IG"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment} Public Route Table"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment} Private Route Table"
    Network = "Private-RT-${var.environment}"
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route" "private" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}

resource "aws_eip" "nat_gateway_eip" { }

resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnets_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.public_subnets_cidrs, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "${var.environment} PublicSubnet ${count.index + 1}"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  depends_on     = [aws_internet_gateway.main]
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = {
    Name = "${var.environment}-NatGateway"
  }
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnets_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnets_cidrs, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name   = "${var.environment} PrivateSubnet ${count.index + 1}"
  }
}

resource "aws_route_table_association" "public_subnet_asso" {
  count          = length(var.public_subnets_cidrs)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_subnet_asso" {
  count          = length(var.private_subnets_cidrs)
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_security_group" "default" {
  name        = "${var.environment}-default-sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = "${aws_vpc.main.id}"
  depends_on  = [aws_vpc.main]
  ingress {
    description = "HTTPS ingress"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Environment = "${var.environment}"
  }
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "security_group_ids" {
  value = [aws_security_group.default.id]
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets[*].id
}