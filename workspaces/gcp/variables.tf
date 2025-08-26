
variable "project_id" {
  type = string
}

variable "temporal_cloud_namespaces" {
  type = list(object({
    app                      = string
    domain                   = string
    region                   = list(string)
    environment              = string
    owner                    = string
    tier                     = string
    retention_days           = number
    custom_search_attributes = list(map(string))
    cert_gcp_secret_name     = string
    key_gcp_secret_name      = string
  }))
  default = [
    {
      app                      = "storefront"
      domain                   = "payment"
      region                   = ["gcp-us-central1"]
      environment              = "dev"
      owner                    = "johndoe"
      tier                     = "t0"
      retention_days           = 30
      custom_search_attributes = []
      cert_gcp_secret_name     = "temporal-cloud-cert-storefront-payment-usc1-dev"
      key_gcp_secret_name      = "temporal-cloud-private-key-storefront-payment-usc1-dev"
    },
    {
      app            = "storefront"
      domain         = "fulfillment"
      region         = ["gcp-us-central1"]
      environment    = "prd"
      owner          = "alicebob"
      tier           = "t0"
      retention_days = 30
      custom_search_attributes = [
        {
          name = "owner"
          type = "Keyword"
        }
      ]
      cert_gcp_secret_name = "temporal-cloud-cert-storefront-fulfillment-usc1-prd"
      key_gcp_secret_name  = "temporal-cloud-private-key-storefront-fulfillment-usc1-prd"
    },
  ]
  validation {
    # The list of valid regions can be found following
    # https://registry.terraform.io/providers/temporalio/temporalcloud/latest/docs/data-sources/regions
    condition = alltrue(flatten([
      for namespace in var.temporal_cloud_namespaces : [
        for region in namespace.region : contains([
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
  validation {
    condition = alltrue([
      for namespace in var.temporal_cloud_namespaces : contains(["dev", "stg", "prd"], namespace.environment)
    ])
    error_message = "Invalid environment. Must be either dev, stg or prd"
  }
}
