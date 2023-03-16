# AWS Networking

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.project_name} VPC"
  }
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr
  availability_zone = "${var.region}${var.availability_zone}"

  tags = {
    Name = "${var.project_name} Public Subnet"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name} IGW"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project_name} Route Table"
  }
}

resource "aws_route_table_association" "subnet_route" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

resource "aws_security_group" "main" {
  name        = "${var.project_name}SG"
  description = "Allow HTTP access for Flask applications running in ECS"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.project_name} Security Group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ipv4_service_port" {
  security_group_id = aws_security_group.main.id
  description       = "Allow TCP traffic from port 80 from your network"

  cidr_ipv4   = var.my_network
  from_port   = var.ingress_specs.port
  to_port     = var.ingress_specs.port
  ip_protocol = var.ingress_specs.protocol
}

resource "aws_vpc_security_group_ingress_rule" "internal" {
  security_group_id = aws_security_group.main.id
  description       = "Allow all internal traffic"

  referenced_security_group_id = aws_security_group.main.id
  ip_protocol                  = "-1"
}

resource "aws_vpc_security_group_egress_rule" "all_ipv4" {
  security_group_id = aws_security_group.main.id
  description       = "Allow all outbound IPv4 traffic"

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

