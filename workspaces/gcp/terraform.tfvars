temporal_cloud_namespaces = [
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