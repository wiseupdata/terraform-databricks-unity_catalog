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
  default = "auto-name"
}

variable "env" {
  description = "System environment."
  type        = string
  default     = "dev"
}

variable "stg_id" {
  type = string
}

variable "stg_name" {
  type = string
}

variable "databricks_id" {
  type = number
}

variable "databricks_url" {
  type = string
}

locals {

  basic_tags = {
    "managed_by" : "terraform",
    "app_name" : var.app_name,
    "env" : var.env,
    "company" : var.company_name
  }

  rg_name = var.rg_name != "auto-name" ? var.rg_name : "rg-${var.app_name}-workspaces-${var.company_name}-${var.env}"

  metastore_name = "${var.app_name}-${var.company_name}-metastore"
  connector_name = "${var.app_name}-${var.company_name}-mi"
  default_tags   = keys(var.default_tags)[0] == "auto-create" ? local.basic_tags : var.default_tags

  dbs_key_metastore_key_name = "${var.app_name}-${var.company_name}-metastore-key"

}

