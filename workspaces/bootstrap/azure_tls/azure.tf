resource "azurerm_resource_group" "temporal_cloud" {
  name     = var.az_resource_group_name
  location = var.az_location
}

data "azurerm_client_config" "current" {
}

resource "azurerm_key_vault" "temporal_cloud_key_vault" {
  name                = var.az_key_vault_name
  location            = var.az_location
  resource_group_name = azurerm_resource_group.temporal_cloud.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  enable_rbac_authorization  = true
  soft_delete_retention_days = 7
  purge_protection_enabled   = false # Consider enabling for production environments
}

resource "azurerm_role_assignment" "key_vault_secrets_officer" {
  scope                = azurerm_key_vault.temporal_cloud_key_vault.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

# Azure RBAC propagation can take XX seconds.
# Hence, we wait for 15 seconds to ensure the RBAC is propagated.
resource "null_resource" "rbac_wait" {
  provisioner "local-exec" {
    command = "sleep 15"
  }

  depends_on = [
    azurerm_role_assignment.key_vault_secrets_officer
  ]
}

resource "azurerm_key_vault_secret" "temporal_cloud_private_key_secret" {
  for_each = toset(var.temporal_cloud_namespaces)

  name         = "temporal-cloud-private-key-${each.key}"
  key_vault_id = azurerm_key_vault.temporal_cloud_key_vault.id

  value_wo         = tls_private_key.temporal_cloud_private_key[each.key].private_key_pem
  value_wo_version = 1

  depends_on = [null_resource.rbac_wait]
}

resource "azurerm_key_vault_secret" "temporal_cloud_cert_secret" {
  for_each = toset(var.temporal_cloud_namespaces)

  name         = "temporal-cloud-cert-${each.key}"
  key_vault_id = azurerm_key_vault.temporal_cloud_key_vault.id

  value_wo         = tls_self_signed_cert.temporal_cloud_cert[each.key].cert_pem
  value_wo_version = 1

  depends_on = [null_resource.rbac_wait]
}

