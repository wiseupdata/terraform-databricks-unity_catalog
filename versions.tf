terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "1.10.0"
    }
  }
}

provider "databricks" {
  host = var.databricks_url
}