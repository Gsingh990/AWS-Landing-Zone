resource "aws_controltower_account_factory_setup" "main" {
  # This resource is typically managed by Control Tower itself.
  # Including it here as a placeholder to ensure the Account Factory is set up.
  # In a real-world scenario, you might just use a data source if already configured.
  # For simplicity, we'll assume it's configured or this will trigger its setup.
  # This resource requires specific permissions and might fail if not properly set up.
  # Refer to AWS Control Tower documentation for prerequisites.
}

resource "aws_controltower_account_factory_account" "main" {
  account_name  = var.account_name
  account_email = var.account_email
  parent_ou_id  = var.parent_ou_id

  # Optional: SSO User configuration
  sso_user_email      = var.sso_user_email
  sso_user_first_name = var.sso_user_first_name
  sso_user_last_name  = var.sso_user_last_name

  # Optional: Tags for the account
  tags = var.tags

  depends_on = [
    aws_controltower_account_factory_setup.main
  ]
}
