locals {
  services = [
    "secretmanager.googleapis.com",
  ]
}

resource "google_project_service" "default" {
  for_each = toset(local.services)

  service            = each.key
  disable_on_destroy = false
}

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

resource "google_secret_manager_secret" "temporal_cloud_private_key" {
  for_each = toset(var.temporal_cloud_namespaces)

  secret_id = "temporal-cloud-private-key-${each.key}"

  labels = {
    temporal-cloud-namespace = each.key
  }

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "temporal_cloud_private_key_version" {
  for_each = toset(var.temporal_cloud_namespaces)

  secret = google_secret_manager_secret.temporal_cloud_private_key[each.key].id

  secret_data_wo_version = 1
  secret_data_wo         = tls_private_key.temporal_cloud_private_key[each.key].private_key_pem
}

resource "google_secret_manager_secret" "temporal_cloud_cert" {
  for_each = toset(var.temporal_cloud_namespaces)

  secret_id = "temporal-cloud-cert-${each.key}"

  labels = {
    temporal-cloud-namespace = each.key
  }

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "temporal_cloud_cert_version" {
  for_each = toset(var.temporal_cloud_namespaces)

  secret = google_secret_manager_secret.temporal_cloud_cert[each.key].id

  secret_data_wo_version = 1
  secret_data_wo         = tls_self_signed_cert.temporal_cloud_cert[each.key].cert_pem
}

