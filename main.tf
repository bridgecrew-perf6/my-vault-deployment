data "aws_ami" "latest_ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}


module "simple-vpc" {
  source = "./modules/terraform-aws-simple-vpc"

  aws_name_prefix = "vpc richarde"
  cidr_block      = "10.0.0.0/16"
  public_subnet   = true
  region          = var.region
  ssh_cidr_blocks = var.ssh_cidr_blocks
}


module "simple-bastion" {
  source = "./modules/terraform-aws-simple-bastion"

  ami             = data.aws_ami.latest_ubuntu.id
  aws_name_prefix = "bastion richarde"
  instance_type   = "t2.micro"
  region = var.region
  subnet = module.simple-vpc.vpc_subnet
  ssh_cidr_blocks = var.ssh_cidr_blocks
  vpc    = module.simple-vpc.vpc_id
}


module "simple-vault" {
  source = "./modules/terraform-aws-simple-vault"

  ami             = data.aws_ami.latest_ubuntu.id
  aws_name_prefix = "vault richarde"
  bastion_pubkey  = module.simple-bastion.pubkey
  instance_type   = "t2.micro"
  region          = var.region
  subnet          = module.simple-vpc.vpc_subnet
  ssh_cidr_blocks = "10.0.0.0/16"
  sg-ssh          = module.simple-bastion.sg-ssh
  vpc             = module.simple-vpc.vpc_id
}