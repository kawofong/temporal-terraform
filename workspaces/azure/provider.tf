terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.30.0"
    }
    temporalcloud = {
      source  = "temporalio/temporalcloud"
      version = "=0.7.1"
    }
  }
}

provider "azurerm" {
  subscription_id = var.az_subscription_id
  features {}
}
