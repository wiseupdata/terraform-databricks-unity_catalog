data "azurerm_resource_group" "this" {
  name = local.resource_group
}

data "azurerm_client_config" "current" {
}

data "azurerm_databricks_workspace" "this" {
  name                = local.databricks_workspace_name
  resource_group_name = local.resource_group
}

data "azuread_client_config" "current" {}


data "azurerm_storage_account" "ext_storages" {
  count = var.ext_storages
  name                = var.ext_storages[count.index].stg_name
  resource_group_name = var.ext_storages[count.index].rg_name
}