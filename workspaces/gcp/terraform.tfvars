temporal_cloud_namespaces = {
  "terraform-managed-namespace-001" = {
    region               = ["aws-us-east-1"]
    retention_days       = 14
    cert_gcp_secret_name = "temporal-cloud-cert-terraform-managed-namespace-001"
    key_gcp_secret_name  = "temporal-cloud-private-key-terraform-managed-namespace-001"
    custom_search_attributes = [
      {
        name = "owner"
        type = "Keyword"
      }
    ]
  },
  "terraform-managed-namespace-002" = {
    region               = ["aws-us-east-1"]
    retention_days       = 14
    cert_gcp_secret_name = "temporal-cloud-cert-terraform-managed-namespace-002"
    key_gcp_secret_name  = "temporal-cloud-private-key-terraform-managed-namespace-002"
    custom_search_attributes = [
      {
        name = "owner"
        type = "Keyword"
      }
    ]
  },
}
