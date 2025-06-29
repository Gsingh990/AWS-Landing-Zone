output "guardduty_detector_id" {
  description = "The ID of the GuardDuty detector."
  value       = var.enable_guardduty ? aws_guardduty_detector.main[0].id : null
}

output "kms_key_arn" {
  description = "The ARN of the KMS key."
  value       = aws_kms_key.main.arn
}

output "config_bucket_arn" {
  description = "The ARN of the S3 bucket for AWS Config logs, if created."
  value       = var.enable_aws_config && var.config_s3_bucket_name == "" ? aws_s3_bucket.config_bucket[0].arn : null
}

output "cloudtrail_bucket_arn" {
  description = "The ARN of the S3 bucket for CloudTrail logs, if created."
  value       = var.enable_cloudtrail && var.cloudtrail_s3_bucket_name == "" ? aws_s3_bucket.cloudtrail_bucket[0].arn : null
}

output "waf_web_acl_arn" {
  description = "The ARN of the WAF Web ACL, if enabled."
  value       = var.enable_waf ? aws_wafv2_web_acl.main[0].arn : null
}

output "secrets_manager_secret_arns" {
  description = "A map of ARNs of the created Secrets Manager secrets."
  value       = { for k, s in aws_secretsmanager_secret.main : k => s.arn }
}

output "acm_certificate_arns" {
  description = "A map of ARNs of the requested ACM certificates."
  value       = { for k, cert in aws_acm_certificate.main : k => cert.arn }
}