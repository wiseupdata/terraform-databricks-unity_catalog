resource "azurerm_databricks_access_connector" "main" {
  name                = local.connector_name
  resource_group_name = local.rg_name
  location            = local.location
  identity {
    type = var.identity_type
  }
  tags = local.default_tags
}

resource "azurerm_storage_account" "this" {
  name                     = local.stg_name_to_metastore
  resource_group_name      = local.rg_name
  location                 = local.location
  tags                     = local.default_tags
  account_tier             = var.stg_account_tier
  account_replication_type = var.stg_replication
  is_hns_enabled           = true
}

resource "azurerm_storage_container" "this" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}

resource "azurerm_role_assignment" "this" {
  scope                = azurerm_storage_account.this.id
  role_definition_name = var.role_name
  principal_id         = azurerm_databricks_access_connector.main.identity[0].principal_id
}