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

service_control_policies = {}

tag_policies = {}

backup_policies = {}

control_tower_managed_accounts = {
  "log_archive" = {
    account_name  = "LogArchive"
    account_email = "log-archive+${random_string.suffix.result}@example.com"
    parent_ou_id  = "security" # Map to Security OU
    sso_user_email = "log-archive-admin+${random_string.suffix.result}@example.com"
    sso_user_first_name = "LogArchive"
    sso_user_last_name = "Admin"
    account_tags = {}
    custom_fields = {}
  },
  "audit" = {
    account_name  = "Audit"
    account_email = "audit+${random_string.suffix.result}@example.com"
    parent_ou_id  = "security" # Map to Security OU
    sso_user_email = "audit-admin+${random_string.suffix.result}@example.com"
    sso_user_first_name = "Audit"
    sso_user_last_name = "Admin"
    account_tags = {}
    custom_fields = {}
  },
  "shared_services" = {
    account_name  = "SharedServices"
    account_email = "shared-services+${random_string.suffix.result}@example.com"
    parent_ou_id  = "infrastructure" # Map to Infrastructure OU
    sso_user_email = "shared-services-admin+${random_string.suffix.result}@example.com"
    sso_user_first_name = "SharedServices"
    sso_user_last_name = "Admin"
    account_tags = {}
    custom_fields = {}
  }
}

hub_vpc_cidr_block = "10.0.0.0/16"
hub_subnet_cidrs = {
  "a" = "10.0.1.0/24"
  "b" = "10.0.2.0/24"
}

enable_vpc_flow_logs = true
flow_logs_s3_bucket_name = ""

enable_route53_resolver = false
route53_resolver_inbound_ip_addresses = []
route53_resolver_outbound_ip_addresses = []
route53_resolver_target_ips = {}

sso_admin_username = "admin"
permission_sets = {}
group_assignments = {}

enable_guardduty = true
enable_security_hub = true
enable_aws_config = true
config_recorder_name = "default"
config_delivery_channel_name = "default"
config_s3_bucket_name = ""

enable_cloudtrail = true
cloudtrail_name = "organization-trail"
cloudtrail_s3_bucket_name = ""

enable_waf = false
waf_web_acl_name = "default-web-acl"
waf_scope = "REGIONAL"

secrets_manager_secrets = {}
acm_certificates = {}

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
