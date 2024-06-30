resource "aws_eip" "vpc_public_nat_gw_elastic_ips" {
  depends_on = [aws_internet_gateway.vpc_internet_gw]

  for_each = aws_subnet.vpc_private_subnets

  tags = merge(
    var.additional_tags,
    {
      Name = "NAT EIP - ${each.value.availability_zone} | ${var.vpc_name}"
      AZ   = "${each.key}"
    }
  )

}