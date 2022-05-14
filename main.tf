# TODO intelligenter maken met outputs oid? Wat als meerdere subnets ofzo, hoe met outputs/data?
# TODO make local for the AWS tags Name field?
# TODO AMI filter + variable
# TODO Vault server + provision ing with userdata <-- !!!
# TODO bastion toegang geven op alle (evt. gemarkeerde) servers in subnet?
# TODO Variables have to reorganized variables.tfvars -> variables.tf -> main.tf -> module variables

# Terraform config
terraform {

}


# Modules
# VPC
module "simple-vpc" {
  source = "./modules/terraform-aws-simple-vpc"

  region          = "eu-west-1"
  cidr_block      = "10.0.0.0/16"
  public_subnet   = false
  cidr_block_ssh  = "0.0.0.0/0"
  aws_name_prefix = "vpc richarde"
}



# Vault
module "simple-vault" {
  source = "./modules/terraform-aws-simple-vault"

  region          = "eu-west-1"
  vpc             = module.simple-vpc.vpc_id
  subnet          = module.simple-vpc.vpc_subnet
  ami             = "ami-0b0bf695cabdc2ce8"
  instance_type   = "t2.micro"
  aws_name_prefix = "vault richarde"
}



# Bastion
module "simple-bastion" {
  source = "./modules/terraform-aws-simple-bastion"

  region          = "eu-west-1"
  vpc             = module.simple-vpc.vpc_id
  subnet          = module.simple-vpc.vpc_subnet
  #TODO ssh_cidr_blocks = ["87.101.0.75/32"]
  ssh_cidr_blocks = ["0.0.0.0/0"]
  ami             = "ami-0b0bf695cabdc2ce8"
  instance_type   = "t2.micro"
  aws_name_prefix = "bastion richarde"
}