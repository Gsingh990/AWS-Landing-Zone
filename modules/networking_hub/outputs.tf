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

output "flow_logs_bucket_arn" {
  description = "The ARN of the S3 bucket for VPC Flow Logs, if created."
  value       = var.enable_vpc_flow_logs && var.flow_logs_s3_bucket_name == "" ? aws_s3_bucket.flow_logs_bucket[0].arn : null
}

output "resolver_inbound_endpoint_id" {
  description = "The ID of the Route 53 Resolver Inbound Endpoint, if enabled."
  value       = var.enable_route53_resolver && length(var.route53_resolver_inbound_ip_addresses) > 0 ? aws_route53_resolver_endpoint.inbound[0].id : null
}

output "resolver_outbound_endpoint_id" {
  description = "The ID of the Route 53 Resolver Outbound Endpoint, if enabled."
  value       = var.enable_route53_resolver && length(var.route53_resolver_outbound_ip_addresses) > 0 ? aws_route53_resolver_endpoint.outbound[0].id : null
}