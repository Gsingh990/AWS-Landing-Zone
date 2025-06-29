variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}

variable "enable_guardduty" {
  description = "Enable GuardDuty in the current account/region."
  type        = bool
  default     = true
}

variable "enable_security_hub" {
  description = "Enable Security Hub in the current account/region."
  type        = bool
  default     = true
}

variable "enable_aws_config" {
  description = "Enable AWS Config in the current account/region."
  type        = bool
  default     = true
}

variable "config_recorder_name" {
  description = "Name for the AWS Config recorder."
  type        = string
  default     = "default"
}

variable "config_delivery_channel_name" {
  description = "Name for the AWS Config delivery channel."
  type        = string
  default     = "default"
}

variable "config_s3_bucket_name" {
  description = "S3 bucket name for AWS Config logs. If empty, a new one will be created."
  type        = string
  default     = ""
}

variable "enable_cloudtrail" {
  description = "Enable CloudTrail in the current account/region."
  type        = bool
  default     = true
}

variable "cloudtrail_name" {
  description = "Name for the CloudTrail trail."
  type        = string
  default     = "organization-trail"
}

variable "cloudtrail_s3_bucket_name" {
  description = "S3 bucket name for CloudTrail logs. If empty, a new one will be created."
  type        = string
  default     = ""
}

variable "enable_waf" {
  description = "Enable WAF Web ACL."
  type        = bool
  default     = false
}

variable "waf_web_acl_name" {
  description = "Name for the WAF Web ACL."
  type        = string
  default     = "default-web-acl"
}

variable "waf_scope" {
  description = "Scope of the WAF Web ACL (CLOUDFRONT or REGIONAL)."
  type        = string
  default     = "REGIONAL"
}

variable "secrets_manager_secrets" {
  description = "A map of Secrets Manager secrets to create."
  type = map(object({
    name        = string
    description = string
    secret_string = string
  }))
  default = {}
}

variable "acm_certificates" {
  description = "A map of ACM certificates to request."
  type = map(object({
    domain_name       = string
    validation_method = string
    subject_alternative_names = optional(list(string), [])
  }))
  default = {}
}