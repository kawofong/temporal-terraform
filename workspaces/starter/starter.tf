locals {
  # A mapping of Temporal Cloud region names to their short names
  region_mapping = {
    "aws-ap-northeast-1" = "apne1",
    "aws-ap-northeast-2" = "apne2",
    "aws-ap-south-1"     = "aps1",
    "aws-ap-southeast-1" = "apse1",
    "aws-ap-southeast-2" = "apse2",
    "aws-ca-central-1"   = "cac1",
    "aws-eu-central-1"   = "euc1",
    "aws-eu-west-1"      = "euw1",
    "aws-eu-west-2"      = "euw2",
    "aws-sa-east-1"      = "sae1",
    "aws-us-east-1"      = "use1",
    "aws-us-east-2"      = "use2",
    "aws-us-west-2"      = "usw2",
    "gcp-us-central1"    = "usc1",
  }
  namespaces = {
    # Namespace name format: <app>-<domain>-<region>-<environment>
    for namespace in var.namespaces : "${namespace.app}-${namespace.domain}-${local.region_mapping[namespace.region[0]]}-${namespace.environment}" => namespace
  }
}

resource "tls_private_key" "temporal_cloud_private_key" {
  for_each = local.namespaces

  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "temporal_cloud_cert" {
  for_each = local.namespaces

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
  for_each = local.namespaces

  name               = each.key
  regions            = each.value.region
  accepted_client_ca = base64encode(tls_self_signed_cert.temporal_cloud_cert[each.key].cert_pem)
  retention_days     = each.value.retention_days
}

resource "temporalcloud_namespace_tags" "namespace_tags" {
  for_each = local.namespaces

  namespace_id = temporalcloud_namespace.namespace[each.key].id
  tags = {
    "app"         = each.value.app
    "environment" = each.value.environment
    "owner"       = each.value.owner
    "tier"        = each.value.tier
  }
}

locals {
  secrets_directory = "${path.module}/.secrets"
}

resource "local_sensitive_file" "private_key" {
  for_each = local.namespaces

  content  = tls_private_key.temporal_cloud_private_key[each.key].private_key_pem
  filename = "${local.secrets_directory}/${each.key}.key"
}

resource "local_sensitive_file" "cert" {
  for_each = local.namespaces

  content  = tls_self_signed_cert.temporal_cloud_cert[each.key].cert_pem
  filename = "${local.secrets_directory}/${each.key}.pem"
}

resource "local_file" "namespaces_yaml" {
  content = yamlencode({
    namespaces = {
      for namespace_name, _ in local.namespaces :
      namespace_name => {
        private_key_file = abspath(local_sensitive_file.private_key[namespace_name].filename)
        cert_file        = abspath(local_sensitive_file.cert[namespace_name].filename)
      }
    }
  })
  filename = "${path.module}/temporal_cloud_namespaces.yml"
}
