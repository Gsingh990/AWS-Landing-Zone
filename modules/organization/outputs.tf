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

output "scp_ids" {
  description = "A map of the IDs of the created Service Control Policies."
  value       = { for k, scp in aws_organizations_policy.scp : k => scp.id }
}

output "tag_policy_ids" {
  description = "A map of the IDs of the created Tag Policies."
  value       = { for k, tp in aws_organizations_policy.tag_policy : k => tp.id }
}

output "backup_policy_ids" {
  description = "A map of the IDs of the created Backup Policies."
  value       = { for k, bp in aws_organizations_policy.backup_policy : k => bp.id }
}