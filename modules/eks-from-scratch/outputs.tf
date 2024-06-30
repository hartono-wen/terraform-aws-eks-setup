output "vpc_id" {
  description = "The VPC ID of the primary VPC"
  value       = aws_vpc.vpc.id
}

output "private_subnet_ids" {
  description = "The VPC ID of the primary VPC"
  value       = [for s in aws_subnet.vpc_private_subnets : s.id]
}

