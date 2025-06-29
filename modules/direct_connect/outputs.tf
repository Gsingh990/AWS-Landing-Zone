output "connection_id" {
  description = "The ID of the Direct Connect connection."
  value       = aws_dx_connection.main.id
}

output "virtual_interface_id" {
  description = "The ID of the Direct Connect Transit Virtual Interface."
  value       = aws_dx_transit_virtual_interface.main.id
}
