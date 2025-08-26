terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "=6.49.2"
    }
    temporalcloud = {
      source  = "temporalio/temporalcloud"
      version = "=1.0.0"
    }
  }
}

provider "google" {
  project = var.project_id
}
