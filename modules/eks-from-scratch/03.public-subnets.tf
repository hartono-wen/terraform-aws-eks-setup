resource "aws_subnet" "vpc_public_subnets" {
  depends_on = [aws_internet_gateway.vpc_internet_gw]

  for_each = var.vpc_public_subnet_lists

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = merge(
    var.additional_tags,
    {
      Name                                                          = "Public Subnet ${each.key} | ${var.vpc_name} | ${aws_vpc.vpc.id}",
      "kubernetes.io/role/elb"                                      = 1
      "kubernetes.io/cluster/eks-${var.product}-${var.environment}" = "shared"
      Tier                                                          = "Public"
    }
  )

}