module "organization" {
  source = "./modules/organization"

  organization_name = var.organization_name
  root_ou_name      = var.root_ou_name
  core_ous          = var.core_ous
  tags              = var.tags
}

module "control_tower_accounts" {
  source = "./modules/control_tower_accounts"

  for_each = var.control_tower_managed_accounts

  account_name        = each.value.account_name
  account_email       = each.value.account_email
  parent_ou_id        = lookup(module.organization.core_ou_ids, each.key, module.organization.root_ou_id) # Map to specific OUs or root
  sso_user_email      = each.value.sso_user_email
  sso_user_first_name = each.value.sso_user_first_name
  sso_user_last_name  = each.value.sso_user_last_name
  tags                = var.tags
}

module "networking_hub" {
  source = "./modules/networking_hub"

  aws_region       = var.aws_region
  hub_vpc_cidr_block = "10.0.0.0/16"
  hub_subnet_cidrs = {
    "a" = "10.0.1.0/24"
    "b" = "10.0.2.0/24"
  }
  tags             = var.tags
}

module "identity_center" {
  source = "./modules/identity_center"

  account_ids = [for k, v in module.control_tower_accounts : v.account_id]
  sso_admin_username = "admin"
  tags        = var.tags
}

module "security_baseline" {
  source = "./modules/security_baseline"

  tags = var.tags
}

module "direct_connect" {
  count = var.deploy_direct_connect ? 1 : 0

  source = "./modules/direct_connect"

  name               = var.direct_connect_name
  location           = var.direct_connect_location
  bandwidth          = var.direct_connect_bandwidth
  vlan               = var.direct_connect_vlan
  bgp_asn            = var.direct_connect_bgp_asn
  bgp_auth_key       = var.direct_connect_bgp_auth_key
  amazon_side_asn    = var.direct_connect_amazon_side_asn
  transit_gateway_id = module.networking_hub.transit_gateway_id
  tags               = var.tags
}

module "site_to_site_vpn" {
  count = var.deploy_site_to_site_vpn ? 1 : 0

  source = "./modules/site_to_site_vpn"

  customer_gateway_bgp_asn  = var.vpn_customer_gateway_bgp_asn
  customer_gateway_ip_address = var.vpn_customer_gateway_ip_address
  vpc_id                    = module.networking_hub.hub_vpc_id
  transit_gateway_id        = module.networking_hub.transit_gateway_id
  tags                      = var.tags
}