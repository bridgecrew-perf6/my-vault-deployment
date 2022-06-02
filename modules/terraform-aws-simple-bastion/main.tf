data "aws_ami" "latest_al2022" {
  count       = var.ami == "" ? 1 : 0
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["al2022-ami-2022.*-x86_64"]
  }
}

resource "aws_instance" "bastion" {
  ami                         = local.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  subnet_id                   = var.subnet
  associate_public_ip_address = true
  key_name                    = aws_key_pair.sshpubkey.key_name
  user_data                   = ""

  tags = var.tags
}


resource "aws_security_group" "bastion" {
  name        = "Bastion"
  description = "Main security group, allows all outgoing"
  vpc_id      = var.vpc

  tags = var.tags
}

resource "aws_security_group_rule" "ingress_ssh" {
  type              = "ingress"
  description       = "allow inbound ssh"
  from_port         = 22 # TODO is dit niet dubbel op met 22 openzetten op VPC niveau?
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.ssh_allowed_from]
  security_group_id = aws_security_group.bastion.id
}


resource "aws_security_group_rule" "egress_all" {
  type              = "egress"
  description       = "allow outbound all"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion.id
}


resource "tls_private_key" "sshkey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


resource "local_sensitive_file" "sshkey" {
  content  = tls_private_key.sshkey.private_key_openssh
  filename = "tmp/sshkey"
}


resource "aws_key_pair" "sshpubkey" {
  key_name   = "sshpubkey"
  public_key = tls_private_key.sshkey.public_key_openssh

  tags = var.tags
}