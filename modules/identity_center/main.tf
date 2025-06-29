resource "aws_ssoadmin_permission_set" "admin_access" {
  name             = "AdministratorAccess"
  description      = "Provides administrative access to AWS accounts."
  instance_arn     = data.aws_ssoadmin_instances.main.arns[0]
  session_duration = "PT4H"

  # Attach AWS managed policy for AdministratorAccess
  # You might want to create custom permission sets for fine-grained access
  # and attach them here.
  # For simplicity, we are using a managed policy.
  # Ensure the AWSControlTowerExecution role has permissions to create/manage permission sets.
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

# Data source to retrieve a specific user from IAM Identity Center
# In a real-world scenario, you would likely manage users/groups via an external IdP (e.g., Azure AD)
# or create them directly in IAM Identity Center and reference them here.
# For simplicity, we assume a user exists and we are assigning them to accounts.
data "aws_ssoadmin_users" "main" {
  instance_arn = data.aws_ssoadmin_instances.main.arns[0]
  filter {
    user_name = var.sso_admin_username
  }
}
