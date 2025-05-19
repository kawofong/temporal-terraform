# Terraforming Temporal Cloud: Google Cloud

This Terraform workspace creates Temporal Cloud using TLS certificates stored in Google Cloud
[Secret Manager](https://cloud.google.com/security/products/secret-manager?hl=en).

## Getting started

1. [Install gcloud CLI](https://cloud.google.com/sdk/docs/install).
1. [Setup authentication for Terraform](https://cloud.google.com/docs/terraform/authentication).
1. [Select a Google Cloud project in gcloud CLI](https://cloud.google.com/resource-manager/docs/creating-managing-projects).

    ```bash
    export PROJECT_ID=<gcp-project-id>
    gcloud projects create "${PROJECT_ID}"
    gcloud config set project "${PROJECT_ID}"
    ```

1. Open a terminal and navigate to the directory where this Terraform workspace is located.

    ```bash
    cd /{path-to-temporal-terraform-github-project}/workspaces/gcp
    ```

1. Initialize the Terraform workspace.

    ```bash
    terraform init
    ```

1. Generate a plan for the Terraform configuration. Review the plan before proceeding to next steps.

    ```bash
    terraform plan
    ```

1. If the plan looks good, apply the Terraform configurations.

    ```bash
    terraform apply
    ```

1. Verify the expected output file after the `terraform apply` command succeeds:
    - `temporal_cloud_namespaces.yml`: a YAML file containing the mapping of Temporal Cloud
    namespaces to Google Cloud secrets containing corresponding private key and certificate

## Connect to Temporal Cloud

1. Complete the [getting started](#getting-started) steps and
ensure that `temporal_cloud_namespaces.yml` exist in the `gcp` Terraform workspace.

1. Identify the Temporal Cloud namespace and account identifier that you would like to connect to.

1. Open a terminal and change directory to the project root directory.

1. Use the following command to run the [`hello` workflow](../../workflows/hello.py) in
your Temporal Cloud namespace. Substitute the values of environment variables.

    ```bash
    export NAMESPACE_NAME="<namespace-name-without-account-id>"
    export ACCOUNT_ID="<account-id>"

    uv run -m workflows.runner --account "${ACCOUNT_ID}" \
    --namespace "${NAMESPACE_NAME}" \
    --workspace "gcp"
    ```
