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

variable "control_tower_managed_accounts" {
  description = "A map of accounts to provision via Control Tower Account Factory."
  type = map(object({
    account_name  = string
    account_email = string
    parent_ou_id  = string # This will be an output from the organization module
    sso_user_email = string
    sso_user_first_name = string
    sso_user_last_name = string
  }))
  default = {
    "log_archive" = {
      account_name  = "LogArchive"
      account_email = "log-archive+${random_string.suffix.result}@example.com"
      parent_ou_id  = ""
      sso_user_email = "log-archive-admin+${random_string.suffix.result}@example.com"
      sso_user_first_name = "LogArchive"
      sso_user_last_name = "Admin"
    },
    "audit" = {
      account_name  = "Audit"
      account_email = "audit+${random_string.suffix.result}@example.com"
      parent_ou_id  = ""
      sso_user_email = "audit-admin+${random_string.suffix.result}@example.com"
      sso_user_first_name = "Audit"
      sso_user_last_name = "Admin"
    },
    "shared_services" = {
      account_name  = "SharedServices"
      account_email = "shared-services+${random_string.suffix.result}@example.com"
      parent_ou_id  = ""
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