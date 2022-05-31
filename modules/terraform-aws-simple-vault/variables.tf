variable "ami" {
  description = "Amazon machine image to use for the Bastion server"
  type        = string
  default     = ""

  validation {
    condition     = length(var.ami) != 0
    error_message = "Bastion AMI variable not set!"
  }
}
variable "tags" {
  description = "Tags to be added to resource blocks."
  type        = map(string)
  default     = {}
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