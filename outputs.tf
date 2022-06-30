output "ssh_allowed_from" {
  value = var.ssh_allowed_from
}
output "zz_bastion_easy_connect" {
  description = "Output that provides the full command to connect to the bastion instance"
  value       = <<-EOF

--------
# How to connect:
ssh-add ${module.simple-bastion.ssh_privkey}
ssh -A ubuntu@${module.simple-bastion.public_ip}

# Optional, ssh to the Vault instance:
ssh ubuntu@${module.simple-vault.private_ip}
export VAULT_ADDR="http://127.0.0.1:8200"
vault status

# Vault UI address:
http://${module.simple-vault.public_ip}:${module.simple-vault.vault_port}

# MariaDB
address: ${module.simple-mariadb.address}
username: ${module.simple-mariadb.username}
password: ${module.simple-mariadb.password}
--------

EOF
}