# Terraforming Temporal Cloud: Azure

This Terraform workspace creates Temporal Cloud using TLS certificates stored in Azure
[Key Vault](https://azure.microsoft.com/en-us/products/key-vault).

## Getting started

1. [Install Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-macos?view=azure-cli-latest).
1. [Create an Azure subscription](https://learn.microsoft.com/en-us/azure/cost-management-billing/manage/create-subscription).
1. [Authenticate to Azure](https://learn.microsoft.com/en-us/azure/developer/terraform/authenticate-to-azure-with-microsoft-account).

    ```bash
    export AZ_SUBSCRIPTION_ID=<azure-subscription-id>
    az login
    az account set --subscription "${SUBSCRIPTION_ID}"
    ```

1. Open a terminal and navigate to the directory where this Terraform workspace is located.

    ```bash
    cd /{path-to-temporal-terraform-github-project}/workspaces/azure
    ```

1. Initialize the Terraform workspace.

    ```bash
    terraform init
    ```

1. Update namespace values in [`terraform.tfvars`](./terraform.tfvars).

1. Generate a plan for the Terraform configuration. Review the plan before proceeding to next steps.

    ```bash
    terraform plan -var "az_subscription_id=${AZ_SUBSCRIPTION_ID}" -var-file="terraform.tfvars"
    ```

1. If the plan looks good, apply the Terraform configurations.

    ```bash
    terraform apply -var "az_subscription_id=${AZ_SUBSCRIPTION_ID}" -var-file="terraform.tfvars"
    ```

1. Verify the expected output file after the `terraform apply` command succeeds:
    - `temporal_cloud_namespaces.yml`: a YAML file containing the mapping of Temporal Cloud
    namespaces to Azure Key Vault secrets containing corresponding private key and certificate

## Connect to Temporal Cloud

1. Complete the [getting started](#getting-started) steps and
ensure that `temporal_cloud_namespaces.yml` exist in the `azure` Terraform workspace.

1. Identify the Temporal Cloud namespace and account identifier that you would like to connect to.

1. Open a terminal and change directory to the project root directory.

1. Use the following command to run the [`hello` workflow](../../workflows/hello.py) in
your Temporal Cloud namespace. Substitute the values of environment variables.

    ```bash
    export NAMESPACE_NAME="<namespace-name-without-account-id>"
    export ACCOUNT_ID="<account-id>"

    uv run -m workflows.runner --account "${ACCOUNT_ID}" \
    --namespace "${NAMESPACE_NAME}" \
    --workspace "azure"
    ```

## Import existing Temporal namespaces

If you have existing Temporal namespaces which you would like to import into Terraform state,
see [this](./import.md).
