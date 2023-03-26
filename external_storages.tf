
resource "azurerm_databricks_access_connector" "ext_access_connector" {
  name                = local.connector_external_name
  resource_group_name = local.rg_name
  location            = local.location
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "ext_storage" {
  scope                = var.stg_ext_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_databricks_access_connector.ext_access_connector.identity[0].principal_id
}

resource "databricks_storage_credential" "external" {
  name = azurerm_databricks_access_connector.ext_access_connector.name
  azure_managed_identity {
    access_connector_id = azurerm_databricks_access_connector.ext_access_connector.id
  }
  comment = "Managed by TF"
  depends_on = [
    databricks_metastore_assignment.this
  ]
}

resource "databricks_external_location" "this" {
  name = "stg-data-raw-dev"
  url = format("abfss://%s@%s.dfs.core.windows.net/",
    var.container_to_catalog_names[0],
  local.stg_ext_name)

  credential_name = databricks_storage_credential.external.id
  comment         = "Managed by TF"
  depends_on = [
    databricks_metastore_assignment.this
  ]
}