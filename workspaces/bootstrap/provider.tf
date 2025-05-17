terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "=6.35.0"
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

provider "google" {
  project = var.project_id
  region  = var.region
}
