variable "account_ids" {
  description = "A list of AWS account IDs to assign permissions to."
  type        = list(string)
}

variable "sso_admin_username" {
  description = "The username of the IAM Identity Center (SSO) user to assign permissions."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}
