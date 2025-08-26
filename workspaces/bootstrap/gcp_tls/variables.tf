
variable "gcp_project_id" {
  type = string
}

variable "gcp_region" {
  type    = string
  default = "us-central1"
}

variable "temporal_cloud_namespaces" {
  type = list(string)
  default = [
    "storefront-fulfillment-usc1-prd",
    "storefront-payment-usc1-dev",
  ]
}
