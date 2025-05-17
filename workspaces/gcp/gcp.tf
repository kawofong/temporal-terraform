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
