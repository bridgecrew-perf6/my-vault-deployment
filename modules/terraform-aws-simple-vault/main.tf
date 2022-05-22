# Provider config
provider "aws" {
  profile = "default"
  region  = var.region
}


# Create the Bastion AWS instance
resource "aws_instance" "vault" {
  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.private_inbound_ssh.id,]
  subnet_id                   = var.subnet
  associate_public_ip_address = false
  key_name                    = var.bastion_pubkey

  tags = {
    Name = var.aws_name_prefix
  }
}

resource "aws_security_group" "private_inbound_ssh" {
  name        = "private-ssh"
  description = "Security group to allow inbound ssh from instances inside the subnet."
  vpc_id      = var.vpc

  ingress = [{
    description      = "ingress SSH from subnet private only"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = var.ssh_cidr_blocks
    self             = true
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
  }]

  egress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "egress allow all"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    self             = false
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
  }]

  tags = {
    Name = var.aws_name_prefix
  }
}