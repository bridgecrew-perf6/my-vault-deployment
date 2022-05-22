output "z_bastion_easy_connect" {
  description = "Output that provides the full command to connect to the bastion instance"
    value = <<-EOT
--------
How to connect:
ssh-add ${module.simple-bastion.sshkey_path}
ssh -A ec2-user@${module.simple-bastion.public_ip}
--------
  EOT
}
output "ssh_cidr_blocks" {
  value = var.ssh_cidr_blocks
}
output "vault_private_ip" {
  value = module.simple-vault.private_ip
}