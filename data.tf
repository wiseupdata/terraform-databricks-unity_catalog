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

data "azurerm_storage_account" "this" {
  name                = var.ext_storages[0].stg_name
  resource_group_name = var.ext_storages[0].rg_name
}