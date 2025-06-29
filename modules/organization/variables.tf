variable "organization_name" {
  description = "The name of the AWS Organization."
  type        = string
}

variable "root_ou_name" {
  description = "The name of the root Organizational Unit (OU) under which other OUs will be created."
  type        = string
}

variable "core_ous" {
  description = "A map of core Organizational Units to create under the root OU."
  type = map(object({
    name = string
  }))
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}
