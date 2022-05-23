resource "aws_instance" "vault" {
  ami                         = var.ami
  associate_public_ip_address = true
  instance_type               = var.instance_type
  key_name                    = var.bastion_pubkey
  subnet_id                   = var.subnet
  user_data_replace_on_change = true
  user_data                   = <<EOF
#!/bin/bash
sudo apt update && sudo apt install -y gpg
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg >/dev/null
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install -y vault
EOF
  vpc_security_group_ids      = [aws_security_group.private_inbound_ssh.id,aws_security_group.https.id,aws_security_group.http.id,aws_security_group.vault.id]

  tags = {
    Name = var.aws_name_prefix
  }
}


resource "aws_security_group" "private_inbound_ssh" {
  description = "Security group to allow inbound ssh from instances inside the subnet."
  name        = "vault ssh"
  vpc_id      = var.vpc

  ingress = [{
    cidr_blocks      = var.ssh_cidr_blocks
    description      = "allow inbound ssh from subnet"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = true
  }]

  tags = {
    Name = var.aws_name_prefix
  }
}


resource "aws_security_group" "https" {
  description = "Security group to allow public inbound and outbound https traffic"
  name        = "vault https 443"
  vpc_id      = var.vpc

  egress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "allow outbound https"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }]

  tags = {
    Name = var.aws_name_prefix
  }
}


resource "aws_security_group" "http" {
  description = "Security group to allow public inbound and outbound https traffic"
  name        = "vault http 80"
  vpc_id      = var.vpc

  egress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "allow outbound http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }]

  tags = {
    Name = var.aws_name_prefix
  }
}


resource "aws_security_group" "vault" {
  description = "Security group to allow public inbound traffic to Vault on 8200"
  name        = "vault http 8200"
  vpc_id      = var.vpc

  ingress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "allow inbound 8200"
    from_port        = 8200
    to_port          = 8200
    protocol         = "tcp"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = true
  }]

  tags = {
    Name = var.aws_name_prefix
  }
}