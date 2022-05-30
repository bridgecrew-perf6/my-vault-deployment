#!/bin/bash

# Install the Hashicorp repository
sudo apt update && sudo apt install -y gpg
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg >/dev/null
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# Install Vault
sudo apt update && sudo apt install -y vault

# Create Vault config
sudo cat << EOF > /etc/vault.d/vault.hcl
ui = true
# disable_mlock = true

storage "file" {
  path = "/opt/vault/data"
}

# HTTPS listener
listener "tcp" {
  address       = "0.0.0.0:8200"
#   tls_cert_file = "/opt/vault/tls/tls.crt"
#   tls_key_file  = "/opt/vault/tls/tls.key"
  tls_disable   = 1
}

# Enterprise license_path
#license_path = "/etc/vault.d/vault.hclic"
EOF

# Make sure the folder for the Vault "file" backend exists
sudo mkdir -p /opt/vault/data

# Start and enable the Vault service
sudo systemctl enable --now vault.service

# Set Vault address in the cli environment
export VAULT_ADDR='http://127.0.0.1:8200'

# Initialize Vault
vault operator init

# Write Vault unseal keys and root_token to homedir (For testing and developing only!)
grep -A6 "Unseal Key 1:" /var/log/cloud-init-output.log > /home/ubuntu/initialisation.txt
chown ubuntu:ubuntu /home/ubuntu/initialisation.txt
