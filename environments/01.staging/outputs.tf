output "vpc_id" {
  description = "The VPC ID of the primary VPC"
  value       = module.vpc_networking.vpc_id
}

output "private_subnet_ids" {
  description = "The VPC ID of the primary VPC"

  value = module.vpc_networking.private_subnet_ids
}