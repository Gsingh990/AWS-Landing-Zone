resource "aws_guardduty_detector" "main" {
  count = var.enable_guardduty ? 1 : 0

  enable = true
  tags   = var.tags
}

resource "aws_securityhub_account" "main" {
  count = var.enable_security_hub ? 1 : 0
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

# AWS Config
resource "aws_s3_bucket" "config_bucket" {
  count = var.enable_aws_config && var.config_s3_bucket_name == "" ? 1 : 0

  bucket = "aws-config-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"
  tags   = var.tags
}

resource "aws_s3_bucket_policy" "config_bucket_policy" {
  count = var.enable_aws_config && var.config_s3_bucket_name == "" ? 1 : 0

  bucket = aws_s3_bucket.config_bucket[0].id
  policy = data.aws_iam_policy_document.config_bucket_policy[0].json
}

data "aws_iam_policy_document" "config_bucket_policy" {
  count = var.enable_aws_config && var.config_s3_bucket_name == "" ? 1 : 0

  statement {
    sid    = "AWSConfigBucketPermissionsCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions = [
      "s3:GetBucketAcl",
      "s3:GetBucketLocation"
    ]

    resources = [
      aws_s3_bucket.config_bucket[0].arn
    ]
  }

  statement {
    sid    = "AWSConfigBucketDelivery"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.config_bucket[0].arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
    ]
  }
}

resource "aws_iam_role" "config_role" {
  count = var.enable_aws_config ? 1 : 0

  name = "aws-config-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
      }
    ]
  })
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "config_policy_attachment" {
  count = var.enable_aws_config ? 1 : 0

  role       = aws_iam_role.config_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}

resource "aws_config_configuration_recorder" "main" {
  count = var.enable_aws_config ? 1 : 0

  name     = var.config_recorder_name
  role_arn = aws_iam_role.config_role[0].arn
}

resource "aws_config_delivery_channel" "main" {
  count = var.enable_aws_config ? 1 : 0

  name          = var.config_delivery_channel_name
  s3_bucket_name = var.config_s3_bucket_name != "" ? var.config_s3_bucket_name : aws_s3_bucket.config_bucket[0].id

  depends_on = [
    aws_config_configuration_recorder.main
  ]
}

resource "aws_config_configuration_recorder_status" "main" {
  count = var.enable_aws_config ? 1 : 0

  name       = aws_config_configuration_recorder.main[0].name
  is_enabled = true

  depends_on = [
    aws_config_delivery_channel.main
  ]
}

# CloudTrail
resource "aws_s3_bucket" "cloudtrail_bucket" {
  count = var.enable_cloudtrail && var.cloudtrail_s3_bucket_name == "" ? 1 : 0

  bucket = "aws-cloudtrail-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"
  tags   = var.tags
}

resource "aws_s3_bucket_policy" "cloudtrail_bucket_policy" {
  count = var.enable_cloudtrail && var.cloudtrail_s3_bucket_name == "" ? 1 : 0

  bucket = aws_s3_bucket.cloudtrail_bucket[0].id
  policy = data.aws_iam_policy_document.cloudtrail_bucket_policy[0].json
}

data "aws_iam_policy_document" "cloudtrail_bucket_policy" {
  count = var.enable_cloudtrail && var.cloudtrail_s3_bucket_name == "" ? 1 : 0

  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = [
      "s3:GetBucketAcl",
      "s3:PutObject"
    ]

    resources = [
      aws_s3_bucket.cloudtrail_bucket[0].arn,
      "${aws_s3_bucket.cloudtrail_bucket[0].arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
    ]
  }
}

resource "aws_cloudtrail" "main" {
  count = var.enable_cloudtrail ? 1 : 0

  name                          = var.cloudtrail_name
  s3_bucket_name                = var.cloudtrail_s3_bucket_name != "" ? var.cloudtrail_s3_bucket_name : aws_s3_bucket.cloudtrail_bucket[0].id
  is_organization_trail         = true # For organization-wide CloudTrail
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  tags                          = var.tags

  depends_on = [
    aws_s3_bucket_policy.cloudtrail_bucket_policy
  ]
}

# WAF Web ACL
resource "aws_wafv2_web_acl" "main" {
  count = var.enable_waf ? 1 : 0

  name        = var.waf_web_acl_name
  scope       = var.waf_scope
  description = "Web ACL for general protection"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.waf_web_acl_name}Metric"
    sampled_requests_enabled   = true
  }
  tags = var.tags
}

# Secrets Manager
resource "aws_secretsmanager_secret" "main" {
  for_each = var.secrets_manager_secrets

  name        = each.value.name
  description = each.value.description
  tags        = var.tags
}

resource "aws_secretsmanager_secret_version" "main" {
  for_each = var.secrets_manager_secrets

  secret_id     = aws_secretsmanager_secret.main[each.key].id
  secret_string = each.value.secret_string
}

# ACM Certificates
resource "aws_acm_certificate" "main" {
  for_each = var.acm_certificates

  domain_name       = each.value.domain_name
  validation_method = each.value.validation_method

  dynamic "subject_alternative_names" {
    for_each = each.value.subject_alternative_names
    content {
      subject_alternative_names = subject_alternative_names.value
    }
  }

  tags = var.tags
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
