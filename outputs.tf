output "z_bastion_easy_connect" {
  description = "Output that provides the full command to connect to the bastion instance"
  value       = "ssh -i ${module.simple-bastion.sshkey_path} ec2-user@${module.simple-bastion.public_ip}"
}