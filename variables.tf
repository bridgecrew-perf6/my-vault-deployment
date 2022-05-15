variable "region" {
  description = "The region for the provider to connect to."
  type        = string
  default     = "eu-west-1"

  validation {
    condition     = length(var.region) != 0
    error_message = "Region variable not set!"
  }
}