
resource "azurerm_databricks_access_connector" "ext_access_connector" {
  name                = local.connector_external_name
  resource_group_name = local.rg_name
  location            = local.location
  identity {
    type = "SystemAssigned"
  }
}

#Todo remove let the datalake to adm
resource "azurerm_storage_container" "ext_storage" {
  name                  = "raw"
  storage_account_name  = local.stg_ext_name
  container_access_type = "private"
}

resource "azurerm_role_assignment" "ext_storage" {
  scope                = var.stg_ext_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_databricks_access_connector.ext_access_connector.identity[0].principal_id
}