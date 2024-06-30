environment    = "uat"
product        = "payment-gateway"
vpc_name       = "UAT VPC"
vpc_cidr_block = "10.130.0.0/16"
vpc_private_subnet_lists = {
  "ap-southeast-1a" = "10.130.71.0/24"
  "ap-southeast-1b" = "10.130.72.0/24"
  "ap-southeast-1c" = "10.130.73.0/24"
}
vpc_public_subnet_lists = {
  "ap-southeast-1a" = "10.130.11.0/24"
  "ap-southeast-1b" = "10.130.12.0/24"
  "ap-southeast-1c" = "10.130.13.0/24"
}
additional_tags = {
  Environment = "UAT"
}