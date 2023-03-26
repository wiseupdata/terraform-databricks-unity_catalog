resource "databricks_metastore" "this" {
  name = local.metastore_name
  storage_root = format("abfss://%s@%s.dfs.core.windows.net/",
    azurerm_storage_container.this.name,
  azurerm_storage_container.this.storage_account_name)
  force_destroy = true
}

resource "databricks_metastore_data_access" "main" {
  metastore_id = databricks_metastore.this.id
  name         = local.metastore_key_name
  azure_managed_identity {
    access_connector_id = azurerm_databricks_access_connector.main.id
  }

  is_default = true
}

resource "databricks_metastore_assignment" "this" {
  workspace_id         = local.databricks_workspace_id
  metastore_id         = databricks_metastore.this.id
  default_catalog_name = var.default_catalog_name
}
