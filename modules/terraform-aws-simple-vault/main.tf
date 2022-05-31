resource "aws_instance" "vault" {
  ami                         = var.ami
  associate_public_ip_address = true
  instance_type               = var.instance_type
  key_name                    = var.bastion_pubkey
  subnet_id                   = var.subnet
  user_data                   = file("${path.module}/scripts/vault-installation.sh")
  vpc_security_group_ids      = [aws_security_group.vault.id]

  tags = var.tags
}

resource "aws_security_group" "vault" {
  description = "Security group to allow public inbound traffic to Vault on 8200"
  name        = "Vault"
  vpc_id      = var.vpc

  tags = var.tags
}


resource "aws_security_group_rule" "vault-api" {
  type              = "ingress"
  description       = "allow inbound 8200"
  from_port         = 8200 # TODO firewall ports variable maken
  to_port           = 8200
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.vault.id
}


resource "aws_security_group_rule" "vault-ssh" {
  type              = "ingress"
  description       = "allow inbound ssh from subnet"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/16"]
  security_group_id = aws_security_group.vault.id
}

# TODO toch outgoing all open voor bv DNS
resource "aws_security_group_rule" "vault-http" {
  type              = "egress"
  description       = "allow outbound http from subnet"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.vault.id
}


resource "aws_security_group_rule" "vault-https" {
  type              = "egress"
  description       = "allow outbound https from subnet"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.vault.id
}