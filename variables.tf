variable "region" {
  description = "The region for the provider to connect to."
  type        = string
  default     = "eu-west-1"

  validation {
    condition     = length(var.region) != 0
    error_message = "Region variable not set!"
  }
}
variable "ssh_cidr_blocks" {
  description = "CIDR block for SSH access to the bastion."
  type        = string
  default     = "0.0.0.0/0"
}