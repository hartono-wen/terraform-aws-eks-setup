resource "aws_nat_gateway" "vpc_public_nat_gateways" {
  depends_on = [
    aws_eip.vpc_public_nat_gw_elastic_ips,
    aws_subnet.vpc_public_subnets
  ]

  for_each      = aws_subnet.vpc_public_subnets
  allocation_id = aws_eip.vpc_public_nat_gw_elastic_ips[each.key].id
  subnet_id     = each.value.id

  tags = merge(
    var.additional_tags,
    {
      Name = "NAT Gateway ${each.value.availability_zone} | ${var.vpc_name} | ${aws_vpc.vpc.id}"
      AZ   = "${each.value.availability_zone}"
    }
  )

}
