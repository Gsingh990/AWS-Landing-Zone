output "transit_gateway_id" {
  description = "The ID of the Transit Gateway."
  value       = aws_ec2_transit_gateway.main.id
}

output "hub_vpc_id" {
  description = "The ID of the Hub VPC."
  value       = aws_vpc.hub_vpc.id
}

output "hub_subnet_ids" {
  description = "A map of the IDs of the Hub VPC subnets."
  value       = { for k, s in aws_subnet.hub_subnets : k => s.id }
}
