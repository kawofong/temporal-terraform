# Terraforming Temporal Cloud

A solution accelerator to manage your Temporal resources in Terraform.
This solution contains 3 flavors of Temporal Cloud configurations: starter and Google Cloud.

* [Starter](./workspaces/starter/): uses Terraform to create and store mTLS certificates.
* [Google Cloud](./workspaces/gcp/): uses [Google Cloud Secret Manager](https://cloud.google.com/security/products/secret-manager?hl=en) to store mTLS certificates.
* [Azure](./workspaces/azure/): uses [Azure Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/general/overview) to store mTLS certificates.

## Pre-requisites

* [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli#install-terraform)
  * `Terraform v1.12.0` was used to develop this solution.
* [direnv](https://direnv.net/docs/installation.html)
* [Temporal Cloud API key](https://docs.temporal.io/cloud/api-keys)
* [uv](https://docs.astral.sh/uv/#installation)

## Getting started

1. Copy the `.envrc.template` file.

    ```bash
    cp .envrc.template .envrc
    ```

2. Populate the values in the `.envrc` file.

3. Allow `direnv` to source `.envrc` file.

    ```bash
    direnv allow
    ```

There are 2 Terraform workspaces in this solution.
To get started with running the Terraform workspace, see:

* [Starter: Getting started](./workspaces/starter/README.md)
* [Google Cloud: Getting started](./workspaces/gcp/README.md)
* [Azure: Getting started](./workspaces/azure/README.md)

## Connect to Temporal Cloud

1. Sync Python dependencies with Python virtual environment.

    ```bash
    uv sync
    ```

For each Terraform workspace, the [Temporal `hello` workflow](./workflows/hello.py)
would require different arguments to connect to Temporal Cloud. See below for commands
to run the `hello` workflow:

* [Starter: Connect to Temporal Cloud](./workspaces/starter/README.md#connect-to-temporal-cloud)
* [Google Cloud: Connect to Temporal Cloud](./workspaces/gcp/README.md#connect-to-temporal-cloud)
* [Azure: Connect to Temporal Cloud](./workspaces/azure/README.md#connect-to-temporal-cloud)

---

### DISCLAIMER

1. This project is provided "as is," without any warranties or guarantees, express or implied.
2. Use of this project is at your own risk. It is your responsibility to validate its suitability for your specific use case.
3. This project is authored and maintained by me in my personal capacity and is not associated with my employer. My employer assumes no liability for the use of this project and will not provide support for it.
4. Any opinions expressed in this project are my own and do not reflect the views of my employer.

---

Unless otherwise stated, all contributions are my own. You are welcome to examine, learn from, and reuse the code and other assets in this project without intellectual property restrictions, subject to the above disclaimer. Attribution is appreciated if you find this project helpful.