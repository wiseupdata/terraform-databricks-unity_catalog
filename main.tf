resource "azurerm_databricks_access_connector" "this" {
  name                = local.connector_name
  resource_group_name = local.rg_name
  location            = var.location
  identity {
    type = var.identity_type
  }
  tags = local.default_tags
}

resource "azurerm_role_assignment" "this" {
  scope                = var.stg_metastore_id
  role_definition_name = var.role_name
  principal_id         = azurerm_databricks_access_connector.this.identity[0].principal_id
}

resource "azurerm_storage_container" "this" {
  name                  = var.container_name
  storage_account_name  = var.stg_metastore_name
  container_access_type = "private"
}

resource "databricks_metastore" "this" {
  name = local.metastore_name
  storage_root = format("abfss://%s@%s.dfs.core.windows.net/",
    azurerm_storage_container.this.name,
  azurerm_storage_container.this.storage_account_name)
  force_destroy = true
}

resource "databricks_metastore_data_access" "first" {
  metastore_id = databricks_metastore.this.id
  name         = local.metastore_key_name
  azure_managed_identity {
    access_connector_id = azurerm_databricks_access_connector.this.id
  }

  is_default = true
}

resource "databricks_metastore_assignment" "this" {
  workspace_id         = var.databricks_id
  metastore_id         = databricks_metastore.this.id
  default_catalog_name = var.default_catalog_name
}
