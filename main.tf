# Get latest Amazon Linux 2022 AMI for the region.
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

  region          = var.region
  cidr_block      = "10.0.0.0/16"
  public_subnet   = true
  ssh_cidr_blocks = var.ssh_cidr_blocks
  aws_name_prefix = "vpc richarde"
}


module "simple-bastion" {
  source = "./modules/terraform-aws-simple-bastion"

  region = var.region
  vpc    = module.simple-vpc.vpc_id
  subnet = module.simple-vpc.vpc_subnet
  ssh_cidr_blocks = var.ssh_cidr_blocks
  ami             = data.aws_ami.latest_ubuntu.id
  instance_type   = "t2.micro"
  aws_name_prefix = "bastion richarde"
}


module "simple-vault" {
  source = "./modules/terraform-aws-simple-vault"

  region          = var.region
  vpc             = module.simple-vpc.vpc_id
  subnet          = module.simple-vpc.vpc_subnet
  ssh_cidr_blocks = ["10.0.0.0/16"]
  sg-ssh          = module.simple-bastion.sg-ssh
  bastion_pubkey  = module.simple-bastion.pubkey
  ami             = data.aws_ami.latest_ubuntu.id
  instance_type   = "t2.micro"
  aws_name_prefix = "vault richarde"
}