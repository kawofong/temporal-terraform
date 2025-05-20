# Terraforming Temporal Cloud: Bootstrap

This Terraform workspace create and store TLS certificates in a new Google Cloud project.

This workspace is used for *development* of this solution and shall not be used directly.
For people who would like to learn how to Terraform Temporal Cloud, see:

- [Starter: Getting started](../starter/README.md)

## Getting started

1. [Install gcloud CLI](https://cloud.google.com/sdk/docs/install).
1. [Setup authentication for Terraform](https://cloud.google.com/docs/terraform/authentication).
1. [Create a Google Cloud project and configure gcloud CLI](https://cloud.google.com/resource-manager/docs/creating-managing-projects).

    ```bash
    export PROJECT_ID=<gcp-project-id>
    gcloud projects create "${PROJECT_ID}"
    gcloud config set project "${PROJECT_ID}"
    ```

1. Open a terminal and navigate to the directory where this Terraform workspace is located.

    ```bash
    cd /{path-to-temporal-terraform-github-project}/workspaces/bootstrap
    ```

1. Initialize the Terraform workspace.

    ```bash
    terraform init
    ```

1. Generate a plan for the Terraform configuration. Review the plan before proceeding to next steps.

    ```bash
    terraform plan -var "project_id=${PROJECT_ID}"
    ```

1. If the plan looks good, apply the Terraform configurations.

    ```bash
    terraform apply -var "project_id=${PROJECT_ID}"
    ```
