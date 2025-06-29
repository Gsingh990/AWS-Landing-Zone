variable "aws_region" {
  description = "The AWS region to deploy resources into."
  type        = string
  default     = "us-east-1"
}

variable "tags" {
  description = "A map of tags to assign to all resources."
  type        = map(string)
  default     = {
    Project     = "AWS Control Tower Landing Zone"
    Environment = "Prod"
  }
}

variable "organization_name" {
  description = "The name of the AWS Organization."
  type        = string
  default     = "MyEnterpriseOrganization"
}

variable "root_ou_name" {
  description = "The name of the root Organizational Unit (OU) under which other OUs will be created."
  type        = string
  default     = "Root"
}

variable "core_ous" {
  description = "A map of core Organizational Units to create under the root OU."
  type = map(object({
    name = string
  }))
  default = {
    "security" = {
      name = "Security"
    },
    "infrastructure" = {
      name = "Infrastructure"
    },
    "workloads" = {
      name = "Workloads"
    },
    "sandbox" = {
      name = "Sandbox"
    }
  }
}

variable "service_control_policies" {
  description = "A map of Service Control Policies (SCPs) to create and attach."
  type = map(object({
    name        = string
    description = string
    content     = string # JSON policy document
    target_ids  = list(string) # List of OU or Account IDs to attach to
  }))
  default = {}
}

variable "tag_policies" {
  description = "A map of Tag Policies to create and attach."
  type = map(object({
    name        = string
    description = string
    content     = string # JSON policy document
    target_ids  = list(string) # List of OU or Account IDs to attach to
  }))
  default = {}
}

variable "backup_policies" {
  description = "A map of Backup Policies to create and attach."
  type = map(object({
    name        = string
    description = string
    content     = string # JSON policy document
    target_ids  = list(string) # List of OU or Account IDs to attach to
  }))
  default = {}
}

variable "control_tower_managed_accounts" {
  description = "A map of accounts to provision via Control Tower Account Factory."
  type = map(object({
    account_name  = string
    account_email = string
    parent_ou_id  = string # This will be an output from the organization module
    sso_user_email = string
    sso_user_first_name = string
    sso_user_last_name = string
    account_tags = optional(map(string), {})
    custom_fields = optional(map(string), {})
  }))
  default = {
    "log_archive" = {
      account_name  = "LogArchive"
      account_email = "log-archive+${random_string.suffix.result}@example.com"
      parent_ou_id  = "security" # Map to Security OU
      sso_user_email = "log-archive-admin+${random_string.suffix.result}@example.com"
      sso_user_first_name = "LogArchive"
      sso_user_last_name = "Admin"
    },
    "audit" = {
      account_name  = "Audit"
      account_email = "audit+${random_string.suffix.result}@example.com"
      parent_ou_id  = "security" # Map to Security OU
      sso_user_email = "audit-admin+${random_string.suffix.result}@example.com"
      sso_user_first_name = "Audit"
      sso_user_last_name = "Admin"
    },
    "shared_services" = {
      account_name  = "SharedServices"
      account_email = "shared-services+${random_string.suffix.result}@example.com"
      parent_ou_id  = "infrastructure" # Map to Infrastructure OU
      sso_user_email = "shared-services-admin+${random_string.suffix.result}@example.com"
      sso_user_first_name = "SharedServices"
      sso_user_last_name = "Admin"
    }
  }
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
  numeric = true
}

variable "hub_vpc_cidr_block" {
  description = "The CIDR block for the Hub VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "hub_subnet_cidrs" {
  description = "A map of CIDR blocks for the Hub VPC subnets, keyed by availability zone suffix (e.g., 'a', 'b')."
  type        = map(string)
  default = {
    "a" = "10.0.1.0/24"
    "b" = "10.0.2.0/24"
  }
}

variable "enable_vpc_flow_logs" {
  description = "Enable VPC Flow Logs for the Hub VPC."
  type        = bool
  default     = true
}

variable "flow_logs_s3_bucket_name" {
  description = "S3 bucket name for VPC Flow Logs. If empty, a new one will be created."
  type        = string
  default     = ""
}

variable "enable_route53_resolver" {
  description = "Enable Route 53 Resolver for centralized DNS."
  type        = bool
  default     = false
}

variable "route53_resolver_inbound_ip_addresses" {
  description = "List of IP addresses for Route 53 Resolver inbound endpoints."
  type        = list(string)
  default     = []
}

variable "route53_resolver_outbound_ip_addresses" {
  description = "List of IP addresses for Route 53 Resolver outbound endpoints."
  type        = list(string)
  default     = []
}

variable "route53_resolver_target_ips" {
  description = "Map of DNS forward rules for Route 53 Resolver outbound endpoints."
  type = map(object({
    domain_name = string
    target_ips  = list(string)
  }))
  default = {}
}

variable "sso_admin_username" {
  description = "The username of the IAM Identity Center (SSO) user to assign permissions."
  type        = string
  default     = "admin"
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

variable "deploy_direct_connect" {
  description = "Set to true to deploy a Direct Connect connection."
  type        = bool
  default     = false
}

variable "direct_connect_name" {
  description = "The name of the Direct Connect connection."
  type        = string
  default     = "my-dx-connection"
}

variable "direct_connect_location" {
  description = "The Direct Connect location where the connection will be terminated."
  type        = string
  default     = "EqDC2"
}

variable "direct_connect_bandwidth" {
  description = "The bandwidth of the connection (e.g., 1Gbps, 10Gbps)."
  type        = string
  default     = "1Gbps"
}

variable "direct_connect_vlan" {
  description = "The VLAN ID for the Direct Connect virtual interface."
  type        = number
  default     = 100
}

variable "direct_connect_bgp_asn" {
  description = "The BGP ASN of your network for Direct Connect."
  type        = number
  default     = 65000
}

variable "direct_connect_bgp_auth_key" {
  description = "The BGP authentication key (MD5) for the Direct Connect BGP session."
  type        = string
  default     = ""
  sensitive   = true
}

variable "direct_connect_amazon_side_asn" {
  description = "The Amazon-side BGP ASN for the Direct Connect virtual interface."
  type        = number
  default     = 64512
}

variable "deploy_site_to_site_vpn" {
  description = "Set to true to deploy a Site-to-Site VPN connection."
  type        = bool
  default     = false
}

variable "vpn_customer_gateway_bgp_asn" {
  description = "The BGP ASN of the customer gateway for VPN."
  type        = number
  default     = 65001
}

variable "vpn_customer_gateway_ip_address" {
  description = "The public IP address of the customer gateway for VPN."
  type        = string
  default     = "1.2.3.4" # Replace with your actual public IP
}
