variable "temporal_cloud_namespaces" {
  type = list(string)
  default = [
    "az-tf-managed-ns-001",
    "az-tf-managed-ns-002",
  ]
}

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
