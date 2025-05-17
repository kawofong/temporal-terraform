resource "tls_private_key" "temporal_cloud_private_key" {
  for_each = var.namespaces

  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "temporal_cloud_cert" {
  for_each = var.namespaces

  private_key_pem = tls_private_key.temporal_cloud_private_key[each.key].private_key_pem

  validity_period_hours = 8760 # 1 year
  is_ca_certificate     = true

  subject {
    common_name  = "example.com"
    organization = "ACME Examples, Inc"
  }

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "client_auth",
  ]
}

resource "temporalcloud_namespace" "namespace" {
  for_each = var.namespaces

  name               = each.key
  regions            = each.value.region
  accepted_client_ca = base64encode(tls_self_signed_cert.temporal_cloud_cert[each.key].cert_pem)
  retention_days     = each.value.retention_days
}

locals {
  secrets_directory = "${path.module}/.secrets"
}

resource "local_sensitive_file" "private_key" {
  for_each = var.namespaces

  content  = tls_private_key.temporal_cloud_private_key[each.key].private_key_pem
  filename = "${local.secrets_directory}/${each.key}.key"
}

resource "local_sensitive_file" "cert" {
  for_each = var.namespaces

  content  = tls_self_signed_cert.temporal_cloud_cert[each.key].cert_pem
  filename = "${local.secrets_directory}/${each.key}.pem"
}

resource "local_file" "namespaces_yaml" {
  content = yamlencode({
    namespaces = {
      for namespace_name, _ in var.namespaces :
      namespace_name => {
        private_key_file = abspath(local_sensitive_file.private_key[namespace_name].filename)
        cert_file        = abspath(local_sensitive_file.cert[namespace_name].filename)
      }
    }
  })
  filename = "${path.module}/temporal_cloud_namespaces.yml"
}
