
variable "project_id" {
  type = string
}

variable "temporal_cloud_namespaces" {
  type = map(object({
    region               = list(string)
    retention_days       = number
    cert_gcp_secret_name = string
    key_gcp_secret_name  = string
  }))
  default = {
    "terraform-managed-namespace-001" = {
      region               = ["aws-us-east-1"]
      retention_days       = 14
      cert_gcp_secret_name = "temporal-cloud-cert-terraform-managed-namespace-001"
      key_gcp_secret_name  = "temporal-cloud-private-key-terraform-managed-namespace-001"
    },
    "terraform-managed-namespace-002" = {
      region               = ["aws-us-east-1"]
      retention_days       = 14
      cert_gcp_secret_name = "temporal-cloud-cert-terraform-managed-namespace-002"
      key_gcp_secret_name  = "temporal-cloud-private-key-terraform-managed-namespace-002"
    },
  }
  validation {
    # The list of valid regions can be found following
    # https://registry.terraform.io/providers/temporalio/temporalcloud/latest/docs/data-sources/regions
    condition = alltrue(flatten([
      for namespace in var.temporal_cloud_namespaces : [
        for region in namespace.region : contains([
          "aws-ap-northeast-1",
          "aws-ap-northeast-2",
          "aws-ap-south-1",
          "aws-ap-southeast-1",
          "aws-ap-southeast-2",
          "aws-ca-central-1",
          "aws-eu-central-1",
          "aws-eu-west-1",
          "aws-eu-west-2",
          "aws-sa-east-1",
          "aws-us-east-1",
          "aws-us-east-2",
          "aws-us-west-2",
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
}
