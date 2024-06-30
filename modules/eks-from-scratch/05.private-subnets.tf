resource "aws_subnet" "vpc_private_subnets" {
  depends_on = [aws_internet_gateway.vpc_internet_gw]

  for_each = var.vpc_private_subnet_lists

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = false

  tags = merge(
    var.additional_tags,
    {
      Name                                                          = "Private Subnet ${each.key} | ${var.vpc_name} | ${aws_vpc.vpc.id}"
      "kubernetes.io/cluster/eks-${var.product}-${var.environment}" = "shared"
      "kubernetes.io/role/internal-elb"                             = "1"
      Tier                                                          = "Private"
    }
  )

}
