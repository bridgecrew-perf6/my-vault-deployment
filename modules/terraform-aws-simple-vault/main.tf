resource "aws_instance" "vault" {
  ami                         = var.ami
  associate_public_ip_address = true
  instance_type               = var.instance_type
  key_name                    = var.bastion_pubkey
  subnet_id                   = var.subnet
  user_data                   = <<EOF
#!/bin/bash
sudo apt update && sudo apt install -y gpg
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg >/dev/null
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install -y vault
EOF
  vpc_security_group_ids      = [aws_security_group.vault.id]

  tags = {
    Name = var.aws_name_prefix
  }
}

resource "aws_security_group" "vault" {
  description = "Security group to allow public inbound traffic to Vault on 8200"
  name        = "vault http 8200"
  vpc_id      = var.vpc

  tags = {
    Name = var.aws_name_prefix
  }
}


resource "aws_security_group_rule" "vault-api" {
  type              = "ingress"
  description       = "allow inbound 8200"
  from_port         = 8200
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