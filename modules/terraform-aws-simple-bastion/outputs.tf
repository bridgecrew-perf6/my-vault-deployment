output "sshpubkey" {
  value = aws_key_pair.sshpubkey.key_name
}
output "public_ip" {
  value = aws_instance.bastion.public_ip
}
output "sshkey" {
  value = local_sensitive_file.sshkey.filename
}