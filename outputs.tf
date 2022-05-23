output "ssh_allowed_from_ips" {
  value = var.ssh_cidr_blocks
}
output "z_vault_public_ip" {
  description = "Public ip of the Vault node."
  value = module.simple-vault.public_ip
}
output "zz_bastion_easy_connect" {
  description = "Output that provides the full command to connect to the bastion instance"
    value = <<-EOF

--------
How to connect:
ssh-add ${module.simple-bastion.sshkey_path}
ssh -A ubuntu@${module.simple-bastion.public_ip}

Optional, ssh throught to the Vault instance:
ssh ubuntu@${module.simple-vault.private_ip}
--------

  EOF
}