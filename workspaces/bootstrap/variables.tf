
variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "temporal_cloud_namespaces" {
  type    = list(string)
  default = ["terraform-managed-namespace-001", "terraform-managed-namespace-002"]
}
