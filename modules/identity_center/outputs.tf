output "permission_set_arn" {
  description = "The ARN of the created AdministratorAccess permission set."
  value       = aws_ssoadmin_permission_set.admin_access.arn
}

output "custom_permission_set_arns" {
  description = "A map of ARNs of the created custom permission sets."
  value       = { for k, ps in aws_ssoadmin_permission_set.custom_permission_sets : k => ps.arn }
}