output "private_ip" {
  value = aws_instance.vault.private_ip
}
output "public_ip" {
  value = aws_instance.vault.public_ip
}
output "vault_port" {
  value = var.vault_port
}