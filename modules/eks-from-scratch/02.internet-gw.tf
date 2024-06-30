resource "aws_internet_gateway" "vpc_internet_gw" {
  depends_on = [aws_vpc.vpc]

  vpc_id = aws_vpc.vpc.id

  tags = merge(
    var.additional_tags,
    {
      Name = "VPC IGW | ${var.vpc_name} | ${aws_vpc.vpc.id}"
    }
  )

}
