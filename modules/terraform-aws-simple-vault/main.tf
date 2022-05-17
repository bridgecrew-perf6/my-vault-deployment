# Provider config
provider "aws" {
  profile = "default"
  region  = var.region
}


# Create the Bastion AWS instance
resource "aws_instance" "vault" {
  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = [var.sg-ssh,]
  # security_groups             = [var.sg-ssh,]
  subnet_id                   = var.subnet
  associate_public_ip_address = false
  key_name                    = var.bastion_pubkey

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

# resource "aws_security_group" "ssh" {
#   name        = "ssh-sg"
#   description = "Main security group, allows all outgoing"
#   vpc_id      = var.vpc

#   ingress = [{
#     description      = "ingress port 22 allow"
#     from_port        = 22
#     to_port          = 22
#     protocol         = "tcp"
#     cidr_blocks      = var.ssh_cidr_blocks # TODO fix ssh cidr block with var! nu eerst eten <3
#     self             = true
#     ipv6_cidr_blocks = []
#     prefix_list_ids  = []
#     security_groups  = []
#   }]

#   tags = {
#     Name = var.aws_name_prefix
#   }
# }


# # Place bastion ssh pub key in AWS
# resource "aws_key_pair" "bastion_public_sshkey" {
#   key_name   = "bastion_sshkey"
#   public_key = var.bastion_pubkey

#   tags = {
#     Name = var.aws_name_prefix
#   }
# }