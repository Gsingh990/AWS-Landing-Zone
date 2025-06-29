variable "account_name" {
  description = "The name of the AWS account to provision."
  type        = string
}

variable "account_email" {
  description = "The email address for the new AWS account."
  type        = string
}

variable "parent_ou_id" {
  description = "The ID of the Organizational Unit (OU) where the account will be placed."
  type        = string
}

variable "sso_user_email" {
  description = "The email address for the initial SSO user in the new account."
  type        = string
}

variable "sso_user_first_name" {
  description = "The first name for the initial SSO user."
  type        = string
}

variable "sso_user_last_name" {
  description = "The last name for the initial SSO user."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the account."
  type        = map(string)
  default     = {}
}

variable "account_tags" {
  description = "A map of tags to apply to the provisioned account."
  type        = map(string)
  default     = {}
}

variable "custom_fields" {
  description = "A map of custom fields to pass to the Account Factory. These are specific to your Account Factory customizations."
  type        = map(string)
  default     = {}
}