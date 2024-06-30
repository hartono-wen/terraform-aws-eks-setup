resource "aws_route_table" "vpc_public_route_tbl" {
  depends_on = [aws_internet_gateway.vpc_internet_gw]

  vpc_id = aws_vpc.vpc.id

  tags = merge(
    var.additional_tags,
    {
      Name = "Public Route Table | ${var.vpc_name} | ${aws_vpc.vpc.id}"
    }
  )

}

resource "aws_route" "public_route_vpc_internet_gw" {
  depends_on = [aws_route_table.vpc_public_route_tbl]

  route_table_id         = aws_route_table.vpc_public_route_tbl.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc_internet_gw.id

}

resource "aws_route_table_association" "vpc_public_route_tbl_assoc" {
  depends_on = [
    aws_route_table.vpc_public_route_tbl,
    aws_subnet.vpc_public_subnets
  ]

  for_each       = aws_subnet.vpc_public_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.vpc_public_route_tbl.id

}
