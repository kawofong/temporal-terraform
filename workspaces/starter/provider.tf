terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "=2.5.3"
    }
    temporalcloud = {
      source  = "temporalio/temporalcloud"
      version = "=0.7.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "=4.1.0"
    }
  }
}

provider "temporalcloud" {
  endpoint       = "saas-api.tmprl.cloud:443" # Temporal Cloud SaaS endpoint; this never changes
  allow_insecure = false                      # secure connection to Temporal Cloud by default
}

provider "tls" {}
