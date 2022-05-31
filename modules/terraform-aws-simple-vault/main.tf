resource "aws_instance" "vault" {
  ami                         = var.ami
  associate_public_ip_address = true
  instance_type               = var.instance_type
  key_name                    = var.sshpubkey
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


resource "aws_security_group_rule" "api" {
  type              = "ingress"
  description       = "allow inbound 8200"
  from_port         = 8200 # TODO firewall ports variable maken
  to_port           = 8200
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.vault.id
}


resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  description       = "allow inbound ssh from subnet"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/16"]
  security_group_id = aws_security_group.vault.id
}

# TODO toch outgoing all open voor bv DNS
resource "aws_security_group_rule" "outbound" {
  type              = "egress"
  description       = "allow outbound all"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.vault.id
}