resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    var.additional_tags,
    {
      Name                                                          = "${var.product} | ${var.environment} | ${var.vpc_name}"
      "kubernetes.io/cluster/eks-${var.product}-${var.environment}" = "shared"
    },
  )

}
