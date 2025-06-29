output "permission_set_arn" {
  description = "The ARN of the created AdministratorAccess permission set."
  value       = aws_ssoadmin_permission_set.admin_access.arn
}
