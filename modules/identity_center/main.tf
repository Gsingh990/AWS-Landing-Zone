resource "aws_ssoadmin_permission_set" "admin_access" {
  name             = "AdministratorAccess"
  description      = "Provides administrative access to AWS accounts."
  instance_arn     = data.aws_ssoadmin_instances.main.arns[0]
  session_duration = "PT4H"
}

resource "aws_ssoadmin_account_assignment" "admin_assignment" {
  for_each = var.account_ids

  instance_arn       = data.aws_ssoadmin_instances.main.arns[0]
  permission_set_arn = aws_ssoadmin_permission_set.admin_access.arn
  principal_type     = "USER"
  principal_id       = data.aws_ssoadmin_users.main.users[0].user_id # Assuming a single user for now
  target_id          = each.value
  target_type        = "AWS_ACCOUNT"
}

data "aws_ssoadmin_instances" "main" {}

data "aws_ssoadmin_users" "main" {
  instance_arn = data.aws_ssoadmin_instances.main.arns[0]
  filter {
    user_name = var.sso_admin_username
  }
}

# Custom Permission Sets
resource "aws_ssoadmin_permission_set" "custom_permission_sets" {
  for_each = var.permission_sets

  name             = each.value.name
  description      = each.value.description
  instance_arn     = data.aws_ssoadmin_instances.main.arns[0]
  session_duration = each.value.session_duration
}

resource "aws_ssoadmin_permission_set_inline_policy" "custom_permission_set_inline_policy" {
  for_each = {
    for k, v in var.permission_sets :
    k => v
    if lookup(v, "inline_policy", null) != null
  }

  instance_arn       = data.aws_ssoadmin_instances.main.arns[0]
  permission_set_arn = aws_ssoadmin_permission_set.custom_permission_sets[each.key].arn
  inline_policy      = each.value.inline_policy
}

resource "aws_ssoadmin_permission_set_managed_policy_attachment" "custom_permission_set_managed_policy_attachment" {
  for_each = {
    for k, v in var.permission_sets :
    k => v
    if length(lookup(v, "managed_policy_arns", [])) > 0
  }

  instance_arn       = data.aws_ssoadmin_instances.main.arns[0]
  permission_set_arn = aws_ssoadmin_permission_set.custom_permission_sets[each.key].arn
  managed_policy_arn = each.value.managed_policy_arns[0] # Assuming one for simplicity, can be expanded
}

# Group Assignments
resource "aws_ssoadmin_account_assignment" "group_assignments" {
  for_each = var.group_assignments

  instance_arn       = data.aws_ssoadmin_instances.main.arns[0]
  permission_set_arn = aws_ssoadmin_permission_set.custom_permission_sets[each.value.permission_set_name].arn # Assuming permission_set_name matches a custom_permission_set key
  principal_type     = "GROUP"
  principal_id       = data.aws_ssoadmin_groups.main[each.value.group_name].group_id
  target_id          = each.value.account_id
  target_type        = "AWS_ACCOUNT"
}

data "aws_ssoadmin_groups" "main" {
  for_each = {
    for k, v in var.group_assignments :
    v.group_name => v.group_name
  }
  instance_arn = data.aws_ssoadmin_instances.main.arns[0]
  filter {
    display_name = each.value
  }
}