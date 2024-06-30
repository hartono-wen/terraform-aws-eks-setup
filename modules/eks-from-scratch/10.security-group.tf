resource "aws_security_group" "default_public_secgroup" {
  depends_on = [aws_vpc.vpc]

  name        = "default-public-secgroup"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = aws_vpc.vpc.id

  tags = merge(
    var.additional_tags,
    {
      Name = "Default Public Security Group | ${var.vpc_name}"
    }
  )

}

resource "aws_vpc_security_group_ingress_rule" "default_public_secgroup_ingress_rule" {
  depends_on = [aws_security_group.default_public_secgroup]

  security_group_id = aws_security_group.default_public_secgroup.id

  description = "All of ports of this instance is accessible from public internet"
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_vpc_security_group_egress_rule" "default_public_secgroup_egress_rule" {
  depends_on = [aws_security_group.default_public_secgroup]

  security_group_id = aws_security_group.default_public_secgroup.id

  description = "This instance can access anywhere"
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}