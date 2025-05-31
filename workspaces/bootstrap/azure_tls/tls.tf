resource "tls_private_key" "temporal_cloud_private_key" {
  for_each = toset(var.temporal_cloud_namespaces)

  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "temporal_cloud_cert" {
  for_each = toset(var.temporal_cloud_namespaces)

  private_key_pem = tls_private_key.temporal_cloud_private_key[each.key].private_key_pem

  validity_period_hours = 8760 # 1 year
  is_ca_certificate     = true

  subject {
    common_name  = "temporal.io"
    organization = "Temporal Technologies, "
  }

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "client_auth",
  ]
}
