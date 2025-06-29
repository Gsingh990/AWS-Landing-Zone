resource "aws_dx_connection" "main" {
  name      = var.name
  location  = var.location
  bandwidth = var.bandwidth
  tags      = var.tags
}

resource "aws_dx_transit_virtual_interface" "main" {
  connection_id    = aws_dx_connection.main.id
  name             = "${var.name}-tvi"
  vlan             = var.vlan
  address_family   = "ipv4"
  bgp_asn          = var.bgp_asn
  bgp_auth_key     = var.bgp_auth_key
  amazon_side_asn  = var.amazon_side_asn
  transit_gateway_id = var.transit_gateway_id
  tags             = var.tags
}
