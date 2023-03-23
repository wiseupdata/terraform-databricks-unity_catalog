terraform {
  required_version = ">=1.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "~>1"
    }
  }
}

provider "azurerm" {
  features {
  }
}
