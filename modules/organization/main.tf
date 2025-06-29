resource "aws_organizations_organization" "main" {
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "sso.amazonaws.com",
    "controltower.amazonaws.com",
    "tagpolicies.tag.amazonaws.com", # For Tag Policies
    "backup.amazonaws.com" # For Backup Policies
  ]
  feature_set = "ALL"
}

data "aws_organizations_organization" "main" {
  depends_on = [aws_organizations_organization.main]
}

resource "aws_organizations_organizational_unit" "root_ou" {
  name      = var.root_ou_name
  parent_id = data.aws_organizations_organization.main.roots[0].id
}

resource "aws_organizations_organizational_unit" "core_ous" {
  for_each = var.core_ous

  name      = each.value.name
  parent_id = aws_organizations_organizational_unit.root_ou.id
}

# Service Control Policies (SCPs)
resource "aws_organizations_policy" "scp" {
  for_each = var.service_control_policies

  name        = each.value.name
  description = each.value.description
  content     = each.value.content
  type        = "SERVICE_CONTROL_POLICY"
}

resource "aws_organizations_policy_attachment" "scp_attachment" {
  for_each = {
    for k, v in var.service_control_policies :
    "${k}-${target_id}" => {
      policy_id = aws_organizations_policy.scp[k].id
      target_id = target_id
    }
    for target_id in v.target_ids
  }

  policy_id = each.value.policy_id
  target_id = each.value.target_id
}

# Tag Policies
resource "aws_organizations_policy" "tag_policy" {
  for_each = var.tag_policies

  name        = each.value.name
  description = each.value.description
  content     = each.value.content
  type        = "TAG_POLICY"
}

resource "aws_organizations_policy_attachment" "tag_policy_attachment" {
  for_each = {
    for k, v in var.tag_policies :
    "${k}-${target_id}" => {
      policy_id = aws_organizations_policy.tag_policy[k].id
      target_id = target_id
    }
    for target_id in v.target_ids
  }

  policy_id = each.value.policy_id
  target_id = each.value.target_id
}

# Backup Policies
resource "aws_organizations_policy" "backup_policy" {
  for_each = var.backup_policies

  name        = each.value.name
  description = each.value.description
  content     = each.value.content
  type        = "BACKUP_POLICY"
}

resource "aws_organizations_policy_attachment" "backup_policy_attachment" {
  for_each = {
    for k, v in var.backup_policies :
    "${k}-${target_id}" => {
      policy_id = aws_organizations_policy.backup_policy[k].id
      target_id = target_id
    }
    for target_id in v.target_ids
  }

  policy_id = each.value.policy_id
  target_id = each.value.target_id
}