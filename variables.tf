variable "app_name" {
  type = string
}

variable "location" {
  description = "Default location for all resources"
  type        = string
}

variable "env" {
  description = "Sytem environment"
  type        = string
}

variable "rg_name" {
  type = string
}

variable "stg_id" {
  type = string
}

variable "stg_name" {
  type = string
}

variable "container_name" {
  type = string
}

variable "databricks_url" {
  type = string
}

variable "databricks_id" {
  type = string
}

variable "default_tags" {
  type = map(string)
  default = {
    "managed_by" = "terraform"
  }

}