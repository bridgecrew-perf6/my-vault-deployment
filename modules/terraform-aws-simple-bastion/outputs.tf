output "sshkey_path" {
  value = local_sensitive_file.bastion_private_sshkey.filename
}
output "public_ip" {
  value = aws_instance.bastion.public_ip
}