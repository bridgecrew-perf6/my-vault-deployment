# Terraform config
terraform {

}

# Provider config
provider "aws" {
  profile = "default"
  region  = var.region
}