output "ssh_allowed_from" {
  value = var.ssh_allowed_from
}
output "zz_bastion_easy_connect" {
  description = "Output that provides the full command to connect to the bastion instance"
  value       = <<-EOF

--------
How to connect:
ssh-add ${module.simple-bastion.sshkey}
ssh -A ubuntu@${module.simple-bastion.public_ip}

Optional, ssh through to the Vault instance:
ssh ubuntu@${module.simple-vault.private_ip}

Vault UI address:
http://${module.simple-vault.public_ip}:8200
--------

EOF
}