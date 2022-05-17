output "sshkey_path" {
  value = local_sensitive_file.bastion_private_sshkey.filename
}
output "pubkey" {
  value = aws_key_pair.bastion_public_sshkey.key_name
}
output "public_ip" {
  value = aws_instance.bastion.public_ip
}
output "sg-ssh" {
  value = aws_security_group.ssh.id
}