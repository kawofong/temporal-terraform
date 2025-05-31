data "azurerm_key_vault" "temporal_secrets" {
  name                = var.az_key_vault_name
  resource_group_name = var.az_resource_group_name
}

data "azurerm_key_vault_secret" "temporal_certs" {
  for_each = var.temporal_cloud_namespaces

  name         = each.value.cert_secret_name
  key_vault_id = data.azurerm_key_vault.temporal_secrets.id
}

data "azurerm_key_vault_secret" "temporal_keys" {
  for_each = var.temporal_cloud_namespaces

  name         = each.value.key_secret_name
  key_vault_id = data.azurerm_key_vault.temporal_secrets.id
}
