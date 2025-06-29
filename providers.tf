terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# Provider for the Management Account (where Control Tower is deployed)
provider "aws" {
  region = var.aws_region
  # Assume credentials are provided via environment variables or AWS CLI config
}

# You might define additional providers for specific accounts (e.g., Log Archive, Audit)
# provider "aws" {
#   alias  = "log_archive"
#   region = var.aws_region
#   assume_role {
#     role_arn = "arn:aws:iam::${var.log_archive_account_id}:role/AWSControlTowerExecution"
#   }
# }

# provider "aws" {
#   alias  = "audit"
#   region = var.aws_region
#   assume_role {
#     role_arn = "arn:aws:iam::${var.audit_account_id}:role/AWSControlTowerExecution"
#   }
# }
