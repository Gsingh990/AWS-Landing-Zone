resource "aws_customer_gateway" "main" {
  bgp_asn    = var.customer_gateway_bgp_asn
  ip_address = var.customer_gateway_ip_address
  type       = "ipsec.1"
  tags       = var.tags
}

resource "aws_vpn_gateway" "main" {
  vpc_id = var.vpc_id # This should be the Hub VPC ID
  tags   = var.tags
}

resource "aws_vpn_connection" "main" {
  vpn_gateway_id      = aws_vpn_gateway.main.id
  customer_gateway_id = aws_customer_gateway.main.id
  type                = "ipsec.1"
  static_routes_only  = false # Assuming dynamic routing with BGP
  tags                = var.tags
}

resource "aws_ec2_transit_gateway_vpn_attachment" "main" {
  transit_gateway_id = var.transit_gateway_id
  vpn_connection_id  = aws_vpn_connection.main.id
  tags               = var.tags
}
