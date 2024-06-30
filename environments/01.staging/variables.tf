variable "environment" {
  description = "The environment of this module whether it is staging, UAT, or PROD"
  type        = string
  default     = "staging"
}

variable "product" {
  description = "The product / service that uses this module"
  type        = string
  default     = "payment-gateway"
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  default     = "Staging VPC"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the created VPC"
  type        = string
  default     = "10.110.0.0/16"
}

variable "vpc_private_subnet_lists" {
  description = "Map of private subnet CIDR block for the created VPC."
  type        = map(string)
  default = {
    "ap-southeast-1a" = "10.110.71.0/24"
    "ap-southeast-1b" = "10.110.72.0/24"
    "ap-southeast-1c" = "10.110.73.0/24"
  }
}

variable "vpc_public_subnet_lists" {
  description = "Map of public subnet CIDR block for the created VPC."
  type        = map(string)
  default = {
    "ap-southeast-1a" = "10.110.11.0/24"
    "ap-southeast-1b" = "10.110.12.0/24"
    "ap-southeast-1c" = "10.110.13.0/24"
  }
}

variable "additional_tags" {
  default = {
    Environment = "staging"
  }
  description = "Additional resource tags"
  type        = map(string)
}