terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.30.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "=2.5.3"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "=4.1.0"
    }

  }
}

provider "azurerm" {
  subscription_id = var.az_subscription_id
  features {}
}
