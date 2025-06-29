# AWS Control Tower Landing Zone (Terraform)

This project provides a detailed Terraform solution for deploying and managing an enterprise-scale AWS Control Tower-based Landing Zone. It focuses on extending Control Tower's capabilities by managing resources within the provisioned accounts and establishing a robust multi-account environment.

## Architecture Overview

This solution leverages AWS Control Tower as the foundation for a secure, multi-account AWS environment. Terraform is used to manage and extend the capabilities within this environment, including:

*   **Organizational Units (OUs):** Structured hierarchy for governance and account organization.
*   **Control Tower Account Factory:** Programmatic provisioning of new AWS accounts aligned with Control Tower's baseline.
*   **Centralized Networking:** Hub-and-spoke network topology using Transit Gateway.
*   **Identity & Access Management:** Integration with AWS IAM Identity Center (SSO).
*   **Security Baseline:** Deployment of core security services across accounts.
*   **Direct Connect (Optional):** Dedicated network connection from your premises to AWS.
*   **Site-to-Site VPN (Optional):** Secure IPsec tunnel connection between your on-premises network and your AWS VPC.

## Prerequisites

Before deploying this solution, ensure you have the following:

*   **AWS Control Tower Deployed:** AWS Control Tower must be already deployed and configured in your AWS Management Account.
*   **AWS CLI:** Installed and configured with credentials for your AWS Management Account (`aws configure`).
*   **Terraform:** Installed ([https://www.terraform.io/downloads.html](https://www.terraform.io/downloads.html)).
*   **Permissions:** Sufficient permissions in your AWS Management Account to manage AWS Organizations, Control Tower Account Factory, and other AWS services.

## Deployment Steps

1.  **Clone the repository:**
    ```bash
    git clone <repository-url>
    cd aws_ct_landing_zone
    ```

2.  **Review and Customize Variables:**
    Open the `variables.tf` and `terraform.tfvars` files in the root directory. Customize the values as needed for your deployment (e.g., AWS region, organization name, OU structure, account details, and optional network connectivity).

3.  **Initialize Terraform:**
    ```bash
    terraform init
    ```

4.  **Review the Plan:**
    ```bash
    terraform plan
    ```

5.  **Apply the Changes:**
    ```bash
    terraform apply
    ```

6.  **Verify Deployment:**
    After the deployment completes, verify the created OUs and provisioned accounts in the AWS Organizations and AWS Control Tower consoles.

## Configuration

The `variables.tf` and `terraform.tfvars` files are the primary places to customize your deployment. Key variables include:

*   `aws_region`: The AWS region for resource deployment.
*   `tags`: Global tags to apply to all resources.
*   `organization_name`: The name of your AWS Organization.
*   `root_ou_name`: The name of the root OU.
*   `core_ous`: A map defining the core Organizational Units to be created.
*   `control_tower_managed_accounts`: A map defining accounts to be provisioned via Control Tower Account Factory, including their names, emails, parent OUs, and initial SSO user details.
*   `deploy_direct_connect`: Set to `true` to deploy a Direct Connect connection. Additional `direct_connect_*` variables will then apply.
*   `deploy_site_to_site_vpn`: Set to `true` to deploy a Site-to-Site VPN connection. Additional `vpn_*` variables will then apply.

## Module Breakdown

*   **`modules/organization/`**: Manages the AWS Organizations structure, including Organizational Units (OUs).
*   **`modules/control_tower_accounts/`**: Interfaces with AWS Control Tower Account Factory to provision new AWS accounts.
*   **`modules/networking_hub/`**: Implements a hub-and-spoke network topology using Transit Gateway and a Hub VPC.
*   **`modules/identity_center/`**: Configures AWS IAM Identity Center (SSO) for centralized access management, including permission sets and account assignments.
*   **`modules/security_baseline/`**: Deploys core security services like GuardDuty, Security Hub, and KMS.
*   **`modules/direct_connect/`**: (Optional) Deploys a Direct Connect connection and a Transit Virtual Interface, connecting to the Transit Gateway.
*   **`modules/site_to_site_vpn/`**: (Optional) Deploys a Customer Gateway, VPN Gateway, and a Site-to-Site VPN connection, attaching to the Transit Gateway.

## Important Notes

*   **Control Tower Prerequisite:** This Terraform project assumes AWS Control Tower is already deployed. It does not deploy Control Tower itself.
*   **Account Factory:** The `control_tower_accounts` module uses the Control Tower Account Factory to provision accounts. This ensures accounts are created with the Control Tower baseline applied.
*   **Email Addresses:** Ensure the email addresses provided for new accounts are unique and not already associated with an AWS account.
*   **SSO User:** The `control_tower_managed_accounts` variable includes details for an initial SSO user for each new account. This user will be created in AWS IAM Identity Center (SSO) and granted administrative access to the new account.
*   **Direct Connect Physical Setup:** The `direct_connect` module provisions the AWS-side logical components. The physical Direct Connect circuit setup must be arranged separately with AWS or an AWS Direct Connect partner.
*   **VPN Customer Gateway IP:** For the `site_to_site_vpn` module, ensure `vpn_customer_gateway_ip_address` is set to your actual on-premises public IP address.