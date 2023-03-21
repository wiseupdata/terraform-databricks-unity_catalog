resource "azurerm_databricks_access_connector" "this" {
  name                = "${var.app_name}-databricks-mi"
  resource_group_name = var.rg_name
  location            = var.location
  identity {
    type = "SystemAssigned"
  }
  tags = var.default_tags
}

resource "azurerm_role_assignment" "example" {
  scope                = var.stg_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_databricks_access_connector.this.identity[0].principal_id

}

resource "databricks_metastore" "this" {
  name = "primary"
  storage_root = format("abfss://%s@%s.dfs.core.windows.net/",
    var.container_name,
  var.stg_name)
  force_destroy = true

}

resource "databricks_metastore_data_access" "first" {
  metastore_id = databricks_metastore.this.id
  name         = "the-keys"
  azure_managed_identity {
    access_connector_id = azurerm_databricks_access_connector.this.id
  }

  is_default = true
}

resource "databricks_metastore_assignment" "this" {
  workspace_id         = var.databricks_id
  metastore_id         = databricks_metastore.this.id
  default_catalog_name = "hive_metastore"
}