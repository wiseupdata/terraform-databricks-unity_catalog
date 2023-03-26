########################################################
# Create a Unity Catalog metastore and link it to workspaces
########################################################
# resource "azuread_application" "this" {
#   display_name     = "sp-dbs-wiseupdata-data-dev"
#   owners           = [data.azuread_client_config.current.object_id]
#   sign_in_audience = "AzureADMyOrg"
# }

# # Create the service principals
# resource "azuread_service_principal" "this" {
#   application_id = azuread_application.this.application_id
#   owners         = [data.azuread_client_config.current.object_id]
#   feature_tags {}
#   alternative_names = []
#   description       = ""
# }

########################################################
# Create a Unity Catalog metastore and link it to workspaces
########################################################

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

########################################################
# Create the groups
########################################################

# resource "databricks_group" "data_eng" {
#   display_name = "Data Engineering"
#   depends_on = [
#     databricks_metastore_data_access.main,
#     databricks_metastore_assignment.this
#   ]
# }

# resource "databricks_mws_permission_assignment" "add_admin_group" {
#   workspace_id = local.databricks_workspace_id
#   principal_id = azurerm_databricks_access_connector.main.identity[0].principal_id
#   permissions  = ["ADMIN"]
#   depends_on = [
#     databricks_metastore_data_access.main,
#     databricks_metastore_assignment.this
#   ]
# }

########################################################
# Create the catalogs and schemas
########################################################

# resource "databricks_catalog" "main" {
#   metastore_id = databricks_metastore.this.id
#   name         = "data"
#   comment      = "This catalog is managed by terraform"
#   properties = {
#     purpose = "data area"
#   }
#   depends_on = [databricks_metastore_assignment.this]
# }

# resource "databricks_grants" "grant_catalog" {
#   catalog = databricks_catalog.main.name
#   grant {
#     principal  = "Data Engineering"
#     privileges = ["USAGE", "CREATE"]
#   }

#   depends_on = [
#     azuread_application.this, azuread_service_principal.this
#   ]
# }

# resource "databricks_schema" "main" {
#   catalog_name = databricks_catalog.main.id
#   name         = "raw"
#   comment      = "this database is managed by terraform"
#   properties = {
#     kind = "various"
#   }
#   # depends_on = [
#   #   azuread_application.this, azuread_service_principal.this
#   # ]
# }

# resource "databricks_grants" "grant_schema" {
#   schema = databricks_schema.main.id
#   grant {
#     principal  = "sp-dbs-wiseupdata-data-dev"
#     privileges = ["USAGE", "CREATE"]
#   }
#   depends_on = [
#     azuread_application.this, azuread_service_principal.this
#   ]
# }


########################################################
# External storages
########################################################

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
  storage_account_name  = "dletldataflowdatadev"
  container_access_type = "private"
}

resource "azurerm_role_assignment" "ext_storage" {
  scope                = azurerm_storage_account.ext_storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_databricks_access_connector.ext_access_connector.identity[0].principal_id
}