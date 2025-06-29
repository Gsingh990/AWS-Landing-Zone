output "account_id" {
  description = "The ID of the provisioned AWS account."
  value       = aws_controltower_account_factory_account.main.account_id
}

output "account_arn" {
  description = "The ARN of the provisioned AWS account."
  value       = aws_controltower_account_factory_account.main.arn
}
