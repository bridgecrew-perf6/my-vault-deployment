data "aws_ami" "latest_ubuntu" { # TODO duplicate to modules and set as default, can be overwritten from root module by end user
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}


module "simple-vpc" {
  source          = "./modules/terraform-aws-simple-vpc"
  cidr_block      = "10.0.0.0/16"
  public_subnet   = true
  region          = var.region
  ssh_cidr_blocks = var.ssh_cidr_blocks # TODO var naam is niet beschrijvend genoeg, bv allow_ssh_in?

  tags = {
    Name = "richarde"
  }
}


module "simple-bastion" {
  source = "./modules/terraform-aws-simple-bastion"

  # TODO input pubkey voor gebruiker om zelf mee te geven
  ami             = data.aws_ami.latest_ubuntu.id
  instance_type   = "t2.micro"
  region          = var.region
  subnet          = module.simple-vpc.vpc_subnet
  ssh_cidr_blocks = var.ssh_cidr_blocks
  vpc             = module.simple-vpc.vpc_id

  tags = {
    Name = "richarde"
  }
}


module "simple-vault" {
  source = "./modules/terraform-aws-simple-vault"

  ami             = data.aws_ami.latest_ubuntu.id
  bastion_pubkey  = module.simple-bastion.pubkey # TODO bastion_ eraf, anders in richten zodat de pub key niet meer direct ui de bastion module komt, + toevoegen, input voor eigen pubkey toevoegen.
  instance_type   = "t2.micro"
  region          = var.region
  subnet          = module.simple-vpc.vpc_subnet
  ssh_cidr_blocks = "10.0.0.0/16"
  vpc             = module.simple-vpc.vpc_id

  tags = {
    Name = "richarde"
  }
}