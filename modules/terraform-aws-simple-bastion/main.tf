resource "aws_instance" "bastion" {
  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  subnet_id                   = var.subnet
  associate_public_ip_address = true
  key_name                    = aws_key_pair.bastion_public_sshkey.key_name
  user_data                   = "" # TODO inrichting: vault cmds draaien vanaf de bastion en vault server zelf dicht zetten? Var toevoegen "debug" als true dan pas door hoppen met ssh?

  tags = var.tags
}


resource "aws_security_group" "bastion" {
  name        = "Bastion"
  description = "Main security group, allows all outgoing"
  vpc_id      = var.vpc

  tags = var.tags
}

resource "aws_security_group_rule" "bastion-inbound-ssh" {
  type              = "ingress"
  description       = "allow inbound ssh"
  from_port         = 22 # TODO is dit niet dubbel op met 22 openzetten op VPC niveau?
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.ssh_cidr_blocks]
  security_group_id = aws_security_group.bastion.id
}


resource "aws_security_group_rule" "bastion-outbound-all" {
  type              = "egress"
  description       = "allow outbound all"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion.id
}


resource "tls_private_key" "bastion_sshkey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


resource "local_sensitive_file" "bastion_private_sshkey" {
  content  = tls_private_key.bastion_sshkey.private_key_openssh
  filename = "tmp/bastion_ssh_key"
}


resource "aws_key_pair" "bastion_public_sshkey" {
  key_name   = "bastion_sshkey"
  public_key = tls_private_key.bastion_sshkey.public_key_openssh

  tags = var.tags
}