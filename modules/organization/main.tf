resource "aws_organizations_organization" "main" {
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "sso.amazonaws.com",
    "controltower.amazonaws.com"
  ]
  feature_set = "ALL"
}

data "aws_organizations_organization" "main" {
  # This data source is used to retrieve the organization details
  # after it's created or if it already exists.
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
