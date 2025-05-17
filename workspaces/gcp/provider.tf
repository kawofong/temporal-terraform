terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "=6.35.0"
    }
    temporalcloud = {
      source  = "temporalio/temporalcloud"
      version = "=0.7.1"
    }
  }
}

provider "google" {
  project = var.project_id
}
