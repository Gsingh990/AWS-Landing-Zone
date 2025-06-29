resource "aws_guardduty_detector" "main" {
  enable = true
  tags   = var.tags
}

resource "aws_securityhub_account" "main" {
  # Security Hub is enabled per region per account.
  # This resource enables it in the current provider's account and region.
  tags = var.tags
}

resource "aws_kms_key" "main" {
  description             = "KMS key for general encryption"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  tags                    = var.tags
}

resource "aws_kms_alias" "main" {
  name          = "alias/general-encryption-key"
  target_key_id = aws_kms_key.main.id
}