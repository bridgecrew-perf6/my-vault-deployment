data "aws_ami" "latest_ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}


module "simple-vpc" {
  source           = "./modules/terraform-aws-simple-vpc"
  cidr_block       = "10.0.0.0/16"
  public_subnet    = true
  region           = var.region
  ssh_allowed_from = var.ssh_allowed_from

  tags = {
    owner = "richarde"
    Name  = "vpc RE"
  }
}


module "simple-bastion" {
  source = "./modules/terraform-aws-simple-bastion"

  ami              = data.aws_ami.latest_ubuntu.id
  instance_type    = "t2.micro"
  region           = var.region
  subnet           = module.simple-vpc.vpc_subnet
  ssh_allowed_from = var.ssh_allowed_from
  ssh_pubkey       = file("test_ssh_key_rsa.pub")
  vpc              = module.simple-vpc.vpc_id

  tags = {
    owner = "richarde"
    Name  = "bastion RE"
  }
}


module "simple-vault" {
  source = "./modules/terraform-aws-simple-vault"

  ami              = data.aws_ami.latest_ubuntu.id
  instance_type    = "t2.micro"
  vault_port       = 8200 # TODO only works on non-privilidged ports at the moment, make so it works on sub 1000 ports? i.e. 443/80 ?
  region           = var.region
  subnet           = module.simple-vpc.vpc_subnet
  ssh_allowed_from = "10.0.0.0/16"
  ssh_pubkey       = module.simple-bastion.ssh_pubkey
  vpc              = module.simple-vpc.vpc_id

  tags = {
    owner = "richarde"
    Name  = "vault RE"
  }
}