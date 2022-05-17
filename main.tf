# TODO igw: seperate vars for allow_access_from_internet en allow_access_to_internet
# TODO intelligenter maken met outputs oid? Wat als meerdere subnets ofzo, hoe met outputs/data?
# TODO make local for the AWS tags Name field?
# TODO Vault server + provision ing with userdata <-- !!!
# TODO bastion toegang geven op alle (evt. gemarkeerde) servers in subnet?
# TODO Variables have to reorganized variables.tfvars -> variables.tf -> main.tf -> module variables

# Terraform config
terraform {

}

# Provider config
provider "aws" {
  profile = "default"
  region  = var.region
}

# Get data:
# Get latest Amazon Linux 2022 AMI
data "aws_ami" "amazon-linux-2022" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2022-ami-202*-x86_64"]
  }
}

# Modules
# VPC
module "simple-vpc" {
  source = "./modules/terraform-aws-simple-vpc"

  region          = var.region
  cidr_block      = "10.0.0.0/16"
  public_subnet   = true
  cidr_block_ssh  = ["0.0.0.0/0"] # TODO klopt de variable naam wel? is het wel het cidr voor ssh?
  aws_name_prefix = "vpc richarde"
}


# Bastion
module "simple-bastion" {
  source = "./modules/terraform-aws-simple-bastion"

  region = var.region
  vpc    = module.simple-vpc.vpc_id
  subnet = module.simple-vpc.vpc_subnet
  #TODO ssh_cidr_blocks = ["my-ip/32"]
  ssh_cidr_blocks = ["0.0.0.0/0"]
  ami             = "ami-0b0bf695cabdc2ce8"
  instance_type   = "t2.micro"
  aws_name_prefix = "bastion richarde"
}


# Vault
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