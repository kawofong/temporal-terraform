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
