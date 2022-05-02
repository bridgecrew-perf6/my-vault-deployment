# TODO intelligenter maken met outputs oid? Wat als meerdere subnets ofzo, hoe met outputs/data?
# TODO make local for the AWS tags Name field?
# TODO AMI filter + variable
# TODO Vault server + provision ing with userdata

# Terraform config
terraform {

}


# Provider config



# Modules
# VPC
module "simple-vpc" {
  source = "./modules/terraform-aws-simple-vpc"

  #TODO These variables have to be moved to variables.tf and referenced here LATER?
  region          = "eu-west-1"
  cidr_block      = "10.0.0.0/16"
  public_subnet   = true
  cidr_block_ssh  = "0.0.0.0/0"
  aws_name_prefix = "richarde"
}


# Bastion
module "simple-bastion" {
  source = "./modules/terraform-aws-simple-bastion"

  # Module variables
  region          = "eu-west-1"
  vpc             = module.simple-vpc.vpc_id
  subnet          = module.simple-vpc.vpc_subnet
  ssh_cidr_blocks = ["87.101.0.75/32"]
  ami             = "ami-0b0bf695cabdc2ce8"
  instance_type   = ""
  aws_name_prefix = "richarde"
}



# Vault
module "simple-vault" {
  source = "./modules/terraform-aws-simple-vault"
}