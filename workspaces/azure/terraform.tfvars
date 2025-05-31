temporal_cloud_namespaces = {
  "az-tf-managed-ns-001" = {
    region           = ["aws-us-east-1"]
    retention_days   = 14
    cert_secret_name = "temporal-cloud-cert-az-tf-managed-ns-001"
    key_secret_name  = "temporal-cloud-private-key-az-tf-managed-ns-001"
    custom_search_attributes = [
      {
        name = "owner"
        type = "Keyword"
      }
    ]
  },
  "az-tf-managed-ns-002" = {
    region           = ["aws-us-east-1"]
    retention_days   = 14
    cert_secret_name = "temporal-cloud-cert-az-tf-managed-ns-002"
    key_secret_name  = "temporal-cloud-private-key-az-tf-managed-ns-002"
    custom_search_attributes = [
      {
        name = "owner"
        type = "Keyword"
      }
    ]
  },
}
