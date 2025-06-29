output "customer_gateway_id" {
  description = "The ID of the Customer Gateway."
  value       = aws_customer_gateway.main.id
}

output "vpn_gateway_id" {
  description = "The ID of the VPN Gateway."
  value       = aws_vpn_gateway.main.id
}

output "vpn_connection_id" {
  description = "The ID of the VPN Connection."
  value       = aws_vpn_connection.main.id
}
