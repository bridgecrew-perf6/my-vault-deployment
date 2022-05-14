# Provider config
provider "aws" {
  profile = "default"
  region  = var.region
}


# Create the Bastion AWS instance
resource "aws_instance" "vault" {
  ami             = var.ami
  instance_type   = var.instance_type
  security_groups = []
  subnet_id       = var.subnet
  key_name        = "" #Should only be accesable from the bastion

  # Default connection to use for all provisioners.
  # connection {
  #   type        = "ssh"
  #   user        = var.default_ssh_user
  #   private_key = local_sensitive_file.bastion_private_sshkey.content
  #   host        = self.public_ip
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "echo debugging message to test provisioning",
  #   ]
  # }

  tags = {
    Name = var.aws_name_prefix
  }
}