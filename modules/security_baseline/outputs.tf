output "guardduty_detector_id" {
  description = "The ID of the GuardDuty detector."
  value       = aws_guardduty_detector.main.id
}

output "kms_key_arn" {
  description = "The ARN of the KMS key."
  value       = aws_kms_key.main.arn
}
