variable "ami" {
  description = "Amazon machine image to use for the Bastion server"
  type        = string
  default     = ""

  validation {
    condition     = length(var.ami) != 0
    error_message = "Bastion AMI variable not set!"
  }
}
variable "aws_name_prefix" {
  description = "This will show in the AWS webgui in the Name collumn of the resource. Use this to destinguish your resources from others."
  type        = string
  default     = ""
}
variable "bastion_pubkey" {
  description = "Public key of the bastion host"
  type        = string
  default     = "not defined"
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
variable "sg-ssh" {
  description = "ID of the security group that allows SSH."
  type = string
  default = ""
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