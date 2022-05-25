resource "aws_vpc" "main" {
  cidr_block = var.cidr_block

  tags = {
    Name = "${var.aws_name_prefix} vpc"
  }
}


resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.cidr_block
  map_public_ip_on_launch = var.public_subnet

  tags = {
    Name = "${var.aws_name_prefix} subnet"
  }
}


resource "aws_internet_gateway" "gw" {
  count  = var.public_subnet ? 1 : 0
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.aws_name_prefix} iGW"
  }
}


resource "aws_route_table" "main_public" {
  count  = var.public_subnet ? 1 : 0
  vpc_id = aws_vpc.main.id

  route {
    gateway_id = aws_internet_gateway.gw[0].id
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    Name = "${var.aws_name_prefix} route table"
  }
}


resource "aws_route_table_association" "a" {
  count          = var.public_subnet ? 1 : 0
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main_public[0].id
}


resource "aws_security_group" "vpc" {
  name        = "vpc-sg"
  description = "Main security group, allows all outgoing"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.aws_name_prefix} sg main"
  }
}


resource "aws_security_group_rule" "vpc-ssh" {
  type              = "ingress"
  description       = "allow inbound ssh"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.ssh_cidr_blocks
  security_group_id = aws_security_group.vpc.id
}


resource "aws_security_group_rule" "vpc-outbound-all" {
  type              = "egress"
  description       = "allow all outbound"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.vpc.id
}