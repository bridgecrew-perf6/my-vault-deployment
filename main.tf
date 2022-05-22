# Get latest Amazon Linux 2022 AMI for the region.
data "aws_ami" "amazon-linux-2022" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2022-ami-202*-x86_64"]
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
  ami             = "ami-0b0bf695cabdc2ce8"
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
  ami             = data.aws_ami.amazon-linux-2022.id
  instance_type   = "t2.micro"
  aws_name_prefix = "vault richarde"
}