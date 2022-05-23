output "z_bastion_easy_connect" {
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
output "ssh_cidr_blocks" {
  value = var.ssh_cidr_blocks
}