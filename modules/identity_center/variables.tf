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

variable "permission_sets" {
  description = "A map of custom permission sets to create."
  type = map(object({
    name             = string
    description      = string
    session_duration = string
    managed_policy_arns = list(string)
    inline_policy    = optional(string)
  }))
  default = {}
}

variable "group_assignments" {
  description = "A map of group assignments to accounts with specific permission sets."
  type = map(object({
    group_name       = string
    permission_set_name = string
    account_id       = string
  }))
  default = {}
}