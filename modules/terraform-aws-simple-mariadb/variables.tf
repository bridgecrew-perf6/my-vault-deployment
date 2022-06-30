variable "password" {
  description = "The admin password of the MariaDB admin account"
  type        = string
  default     = "thisisaverylongpasswordthatshouldbechanged"
}
variable "username" {
  description = "This is the admin username of the MariaDB admin account"
  type        = string
  default     = "administrator"
}
variable "db_subnet_group" {
  description = "This is the subnet the DB will be placed in."
  type        = string
  default     = null

  validation {
    condition     = length(var.db_subnet_group) != 0
    error_message = "Please specify a subnet for the MariaDB instance."
  }
}
variable "vpc" {
  description = "VPC id of the VPC that MariaDB instance will be placed in"
  type        = string
  default     = null

  validation {
    condition     = length(var.vpc) != 0
    error_message = "Region variable not set!"
  }
}