aws_region = "us-east-1"

tags = {
  Project     = "AWS Control Tower Landing Zone"
  Environment = "Prod"
}

organization_name = "MyEnterpriseOrganization"
root_ou_name      = "Root"

core_ous = {
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

control_tower_managed_accounts = {
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

deploy_direct_connect = false
direct_connect_name = "my-dx-connection"
direct_connect_location = "EqDC2"
direct_connect_bandwidth = "1Gbps"
direct_connect_vlan = 100
direct_connect_bgp_asn = 65000
direct_connect_bgp_auth_key = ""
direct_connect_amazon_side_asn = 64512

deploy_site_to_site_vpn = false
vpn_customer_gateway_bgp_asn = 65001
vpn_customer_gateway_ip_address = "1.2.3.4"