output "organization_id" {
  description = "The ID of the AWS Organization."
  value       = data.aws_organizations_organization.main.id
}

output "root_ou_id" {
  description = "The ID of the root Organizational Unit."
  value       = aws_organizations_organizational_unit.root_ou.id
}

output "core_ou_ids" {
  description = "A map of the IDs of the core Organizational Units."
  value       = { for k, ou in aws_organizations_organizational_unit.core_ous : k => ou.id }
}
