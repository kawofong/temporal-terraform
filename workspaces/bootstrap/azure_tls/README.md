# Terraforming Temporal Cloud: Bootstrap Azure

This Terraform workspace create and store TLS certificates in a new Azure resource group.

This workspace is used for *development* of this solution and shall not be used directly.
For people who would like to learn how to Terraform Temporal Cloud, see:

- [Starter: Getting started](../starter/README.md)

## Getting started

1. Setup Azure CLI
   - [Install Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-macos?view=azure-cli-latest).
   - [Authenticate to Azure](https://learn.microsoft.com/en-us/azure/developer/terraform/authenticate-to-azure-with-microsoft-account).

    ```bash
    export AZ_SUBSCRIPTION_ID=<azure-subscription-id>
    ```

1. Open a terminal and navigate to the directory where this Terraform workspace is located.

    ```bash
    cd /{path-to-temporal-terraform-github-project}/workspaces/bootstrap/azure_tls
    ```

1. Initialize the Terraform workspace.

    ```bash
    terraform init
    ```

1. Generate a plan for the Terraform configuration. Review the plan before proceeding to next steps.

    ```bash
    terraform plan -var "az_subscription_id=${AZ_SUBSCRIPTION_ID}"
    ```

1. If the plan looks good, apply the Terraform configurations.

    ```bash
    terraform apply -var "az_subscription_id=${AZ_SUBSCRIPTION_ID}"
    ```
