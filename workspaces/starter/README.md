# Terraforming Temporal Cloud: Starter

This Terraform workspace includes Temporal Cloud namespace configurations using
Terraform-managed TLS certificates.

Use of this workspace for production deployments is not recommended because
[`haschicorp/tls`](https://registry.terraform.io/providers/hashicorp/tls/latest/docs#secrets-and-terraform-state) provider
is not recommended for production usage.

## Getting started

1. Open a terminal and navigate to the directory where this Terraform workspace is located.

    ```bash
    cd /{path-to-temporal-terraform-github-project}/workspaces/starter
    ```

2. Initialize the Terraform workspace.

    ```bash
    terraform init
    ```

3. Generate a plan for the Terraform configuration. Review the plan before proceeding to next steps.

    ```bash
    terraform plan
    ```

4. If the plan looks good, apply the Terraform configurations.

    ```bash
    terraform apply
    ```

5. Verify the expected output files after the `terraform apply` command succeeds:
    - `temporal_cloud_namespaces.yml`: a YAML file containing the mapping of namespaces
    to private key and certificate file paths
    - Private key files (i.e. `*.key`) for each namespace
    - Certificate files (i.e. `*.pem`) for each namespace

## Connect to Temporal Cloud

TBD
