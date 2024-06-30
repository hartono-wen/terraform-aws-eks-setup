environment    = "prod"
product        = "payment-gateway"
vpc_name       = "PROD VPC"
vpc_cidr_block = "10.150.0.0/16"
vpc_private_subnet_lists = {
  "ap-southeast-1a" = "10.150.71.0/24"
  "ap-southeast-1b" = "10.150.72.0/24"
  "ap-southeast-1c" = "10.150.73.0/24"
}
vpc_public_subnet_lists = {
  "ap-southeast-1a" = "10.150.11.0/24"
  "ap-southeast-1b" = "10.150.12.0/24"
  "ap-southeast-1c" = "10.150.13.0/24"
}
additional_tags = {
  Environment = "PROD"
}