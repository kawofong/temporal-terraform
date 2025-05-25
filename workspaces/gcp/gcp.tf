data "google_secret_manager_secret_version" "temporal_cloud_namespace_cert" {
  for_each = var.temporal_cloud_namespaces

  secret = each.value.cert_gcp_secret_name
}

data "google_secret_manager_secret_version" "temporal_cloud_namespace_key" {
  for_each = var.temporal_cloud_namespaces

  secret = each.value.key_gcp_secret_name
}

resource "temporalcloud_namespace" "namespace" {
  for_each = var.temporal_cloud_namespaces

  name               = each.key
  regions            = each.value.region
  accepted_client_ca = base64encode(data.google_secret_manager_secret_version.temporal_cloud_namespace_cert[each.key].secret_data)
  retention_days     = each.value.retention_days
}

locals {
  # Flatten the custom search attributes for namespace for easy iteration
  # This creates a map where each key is unique (e.g., "namespaceName_attributeName")
  # and the value contains the namespace name and the attribute details.
  namespace_search_attributes_flat = merge(flatten([
    for ns_key, ns_value in var.temporal_cloud_namespaces : [
      for sa_index, sa_value in ns_value.custom_search_attributes : {
        "${ns_key}_${sa_value.name}" = {
          namespace_name = ns_key
          attribute_name = sa_value.name
          attribute_type = sa_value.type
        }
      }
    ]
  ])...)
}

resource "temporalcloud_namespace_search_attribute" "custom_search_attributes" {
  for_each = local.namespace_search_attributes_flat

  namespace_id = temporalcloud_namespace.namespace[each.value.namespace_name].id
  name         = each.value.attribute_name
  type         = each.value.attribute_type
}

data "google_secret_manager_secret_version" "temporal_cloud_observability_key" {
  secret = var.temporal_cloud_observability_cert_gcp_secret_name
}

resource "temporalcloud_metrics_endpoint" "observability" {
  accepted_client_ca = base64encode(data.google_secret_manager_secret_version.temporal_cloud_observability_key.secret_data)
}

resource "local_file" "namespaces_yaml" {
  content = yamlencode({
    namespaces = {
      for namespace_name, _ in var.temporal_cloud_namespaces :
      namespace_name => {
        gcp_secret_name_for_cert = data.google_secret_manager_secret_version.temporal_cloud_namespace_cert[namespace_name].name
        gcp_secret_name_for_key  = data.google_secret_manager_secret_version.temporal_cloud_namespace_key[namespace_name].name
      }
    }
  })
  filename = "${path.module}/temporal_cloud_namespaces.yml"
}
