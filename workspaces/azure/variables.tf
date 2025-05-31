variable "az_subscription_id" {
  type        = string
  description = "The Azure subscription ID."
}

variable "az_location" {
  type        = string
  description = "The Azure region where the Key Vault will be created."
  default     = "East US"

  validation {
    condition     = contains(["East US"], var.az_location)
    error_message = "GCP region must be one of: 'East US'"
  }
}

variable "az_resource_group_name" {
  type        = string
  description = "The name of the Azure Resource Group for the Key Vault."
  default     = "rg-temporal-terraform"
}

variable "az_key_vault_name" {
  type        = string
  description = "The name of the Azure Key Vault."
  default     = "kv-temporal-terraform"
}

variable "temporal_cloud_namespaces" {
  type = map(object({
    region                   = list(string)
    retention_days           = number
    cert_secret_name         = string
    key_secret_name          = string
    custom_search_attributes = list(map(string))
  }))
  default = {
    "az-tf-managed-ns-001" = {
      region           = ["aws-us-east-1"]
      retention_days   = 14
      cert_secret_name = "temporal-cloud-cert-az-tf-managed-ns-001"
      key_secret_name  = "temporal-cloud-private-key-az-tf-managed-ns-001"
      custom_search_attributes = [
        {
          name = "owner"
          type = "Keyword"
        }
      ]
    },
    "az-tf-managed-ns-002" = {
      region           = ["aws-us-east-1"]
      retention_days   = 14
      cert_secret_name = "temporal-cloud-cert-az-tf-managed-ns-002"
      key_secret_name  = "temporal-cloud-private-key-az-tf-managed-ns-002"
      custom_search_attributes = [
        {
          name = "owner"
          type = "Keyword"
        }
      ]
    },
  }
  validation {
    # The list of valid regions can be found following
    # https://registry.terraform.io/providers/temporalio/temporalcloud/latest/docs/data-sources/regions
    condition = alltrue(flatten([
      for namespace in var.temporal_cloud_namespaces : [
        for region in namespace.region : contains([
          "aws-ap-northeast-1",
          "aws-ap-northeast-2",
          "aws-ap-south-1",
          "aws-ap-southeast-1",
          "aws-ap-southeast-2",
          "aws-ca-central-1",
          "aws-eu-central-1",
          "aws-eu-west-1",
          "aws-eu-west-2",
          "aws-sa-east-1",
          "aws-us-east-1",
          "aws-us-east-2",
          "aws-us-west-2",
          "gcp-us-central1",
        ], region)
      ]
    ]))
    error_message = "Invalid region."
  }
  validation {
    condition = alltrue([
      for namespace in var.temporal_cloud_namespaces : length(namespace.region) >= 1 && length(namespace.region) <= 2
    ])
    error_message = "Each namespace must have 1 or 2 regions."
  }
  validation {
    condition = alltrue([
      for namespace in var.temporal_cloud_namespaces : namespace.retention_days >= 1 && namespace.retention_days <= 90
    ])
    error_message = "Invalid retention_days. Must be between 1 and 90 inclusively"
  }
}
