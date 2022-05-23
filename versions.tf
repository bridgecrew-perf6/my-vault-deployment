# Terraform config
terraform {
  required_version = ">= 0.14.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

# Provider config
provider "aws" {
  profile = "default"
  region  = var.region
}