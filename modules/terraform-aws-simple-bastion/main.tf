# Create the Bastion AWS instance
resource "aws_instance" "bastion" {
  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.public_inbound_ssh.id]
  subnet_id                   = var.subnet
  associate_public_ip_address = true
  key_name                    = aws_key_pair.bastion_public_sshkey.key_name
  user_data                   = "" # TODO hier verder gaan, switched naar ubuntu ami... ssh might not be enabled byt default in this ami... needs fixin.

  tags = {
    Name = var.aws_name_prefix
  }
}


resource "aws_security_group" "public_inbound_ssh" {
  name        = "public_ssh"
  description = "Main security group, allows all outgoing"
  vpc_id      = var.vpc

  ingress = [{
    description      = "ingress port 22 allow"
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


# Create RSA key of size 4096 bits
resource "tls_private_key" "bastion_sshkey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


# Write ssh private key to local
resource "local_sensitive_file" "bastion_private_sshkey" {
  content  = tls_private_key.bastion_sshkey.private_key_openssh
  filename = "tmp/bastion_ssh_key"
}


# Place ssh pub key in AWS
resource "aws_key_pair" "bastion_public_sshkey" {
  key_name   = "bastion_sshkey"
  public_key = tls_private_key.bastion_sshkey.public_key_openssh

  tags = {
    Name = var.aws_name_prefix
  }
}