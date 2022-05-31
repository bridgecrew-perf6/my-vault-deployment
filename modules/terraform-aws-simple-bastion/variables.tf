variable "tags" {
  description = "Tags to be added to resource blocks."
  type        = map(string)
  default     = {}
}
variable "ami" {
  description = "Amazon machine image to use for the Bastion server"
  type        = string
  default     = ""

  validation {
    condition     = length(var.ami) != 0
    error_message = "Bastion AMI variable not set!"
  }
}
variable "default_ssh_user" {
  description = "Username to use for SSH with the Bastion"
  type        = string
  default     = "ec2-user"
}
variable "instance_type" {
  description = "Instance type to use for the bastion host"
  type        = string
  default     = "t2.micro"
}
variable "region" {
  description = "region to deploy the bastion in, should be same as the VPC."
  type        = string
  default     = ""
}
variable "ssh_cidr_blocks" {
  description = "CIDR block to allow ssh from in the SSH security group"
  type        = string
  default     = "0.0.0.0/0"
}
variable "subnet" {
  description = "Subnet within the vpc to deploy the bastion in"
  type        = string
  default     = ""
}
variable "vpc" {
  description = "VPC to deploy the bastion in"
  type        = string
  default     = ""
}