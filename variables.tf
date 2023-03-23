variable "app_name" {
  description = "The name of the application, dbs is the abbreviation to Databricks"
  type        = string
  default     = "databricks"
}

variable "company_name" {
  description = "The name of the company."
  type        = string
  default     = "wiseupdata"
}

variable "identity_type" {
  type    = string
  default = "SystemAssigned"
}

variable "default_tags" {
  description = "Default tags for all resources"
  type        = map(string)
  default = {
    "auto-create" = "true"
  }
}

variable "role_name" {
  type    = string
  default = "Storage Blob Data Contributor"
}

variable "default_catalog_name" {
  type    = string
  default = "hive_metastore"
}

variable "container_name" {
  type    = string
  default = "managed-dbs"
}

variable "location" {
  description = "Specifies the supported Azure location where the resource has to be created. Changing this forces a new resource to be created."
  type        = string
  default     = "ukwest"
}

variable "rg_name" {
  type    = string
  default = "auto-extract"
}

variable "env" {
  description = "System environment."
  type        = string
  default     = "dev"
}

variable "stg_id_to_metastore" {
  type = string
}

variable "metastore_name" {
  type    = string
  default = "auto-create"
}

variable "connector_name" {
  type    = string
  default = "auto-create"
}

variable "metastore_key_name" {
  type    = string
  default = "auto-create"
}

variable "databricks_resource_id" {
  description = "The Azure resource ID for the databricks workspace deployment."
}

locals {

  basic_tags = {
    "managed_by" : "terraform",
    "app_name" : var.app_name,
    "env" : var.env,
    "company" : var.company_name
  }



  metastore_name = var.metastore_name == "auto-create" ? "${var.app_name}-${var.company_name}-metastore" : var.metastore_name
  connector_name = var.connector_name == "auto-create" ? "${var.app_name}-${var.company_name}-connector" : var.connector_name
  default_tags   = keys(var.default_tags)[0] == "auto-create" ? local.basic_tags : var.default_tags

  metastore_key_name = var.metastore_key_name == "auto-create" ? "${var.app_name}-${var.company_name}-metastore-key" : var.metastore_key_name

  resource_regex            = "(?i)subscriptions/(.+)/resourceGroups/(.+)/providers/Microsoft.Databricks/workspaces/(.+)"
  subscription_id           = regex(local.resource_regex, var.databricks_resource_id)[0]
  resource_group            = regex(local.resource_regex, var.databricks_resource_id)[1]
  databricks_workspace_name = regex(local.resource_regex, var.databricks_resource_id)[2]
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  databricks_workspace_host = data.azurerm_databricks_workspace.this.workspace_url
  databricks_workspace_id   = data.azurerm_databricks_workspace.this.workspace_id
  prefix                    = replace(replace(lower(data.azurerm_resource_group.this.name), "rg", ""), "-", "")

  rg_name = var.rg_name == "auto-extract" ? local.resource_group : var.rg_name

  stg_regex             = "(?i)subscriptions/(.+)/resourceGroups/(.+)/providers/Microsoft.Storage/storageAccounts/(.+)"
  stg_name_to_metastore = regex(local.stg_regex, var.stg_id_to_metastore)[2]

}

