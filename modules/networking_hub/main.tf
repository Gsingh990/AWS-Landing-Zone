resource "aws_ec2_transit_gateway" "main" {
  description = "Main Transit Gateway for the Landing Zone"
  tags        = var.tags
}

resource "aws_vpc" "hub_vpc" {
  cidr_block           = var.hub_vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = var.tags
}

resource "aws_subnet" "hub_subnets" {
  for_each = var.hub_subnet_cidrs

  vpc_id            = aws_vpc.hub_vpc.id
  cidr_block        = each.value
  availability_zone = "${var.aws_region}${each.key}"
  tags              = var.tags
}

resource "aws_ec2_transit_gateway_vpc_attachment" "hub_vpc_attachment" {
  vpc_id              = aws_vpc.hub_vpc.id
  transit_gateway_id  = aws_ec2_transit_gateway.main.id
  subnet_ids          = [for s in aws_subnet.hub_subnets : s.id]
  dns_support         = "enable"
  ipv6_support        = "disable"
  transit_gateway_default_route_table_association = true
  transit_gateway_default_route_table_propagation = true
  tags                = var.tags
}
