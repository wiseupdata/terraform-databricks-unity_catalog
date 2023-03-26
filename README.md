Easy create a Databricks Unit Catalog!

---

<a href="https://github.com/wiseupdata/terraform-databricks-unity_catalog">
<img align="left" alt="Wise Up Data's Instagram" width="22px" src="https://raw.githubusercontent.com/wiseupdata/terraform-databricks-unity_catalog/main/assets/instagram.png" />   
</a> 
<a href="https://github.com/wiseupdata/terraform-databricks-unity_catalog">
  <img align="left" alt="wise Up Data's Discord" width="22px" src="https://raw.githubusercontent.com/wiseupdata/terraform-databricks-unity_catalog/main/assets/discord.svg" />
</a>
<a href="https://github.com/wiseupdata/terraform-databricks-unity_catalog">
  <img align="left" alt="wise Up Data | Twitter" width="22px" src="https://raw.githubusercontent.com/wiseupdata/terraform-databricks-unity_catalog/main/assets/twitter.svg" />
</a>
<a href="https://github.com/wiseupdata/terraform-databricks-unity_catalog">
  <img align="left" alt="wise Up Data's LinkedIN" width="22px" src="https://raw.githubusercontent.com/wiseupdata/terraform-databricks-unity_catalog/ffaf28ec794c1704499e0b1af48cd62771a544da/assets/linkedin.svg" />
</a>

![visitors](https://visitor-badge.glitch.me/badge?page_id=wiseupdata.terraform-databricks-unity_catalog&left_color=green&right_color=black)
![GitHub](https://img.shields.io/github/license/wiseupdata/terraform-databricks-unity_catalog)

---

<h1>
<img align="left" alt="DP-203" src="https://raw.githubusercontent.com/wiseupdata/terraform-databricks-unity_catalog/main/assets/terraform.png" width="100" />

Module - Databricks Unit Catalog in Azure 🚀️

</h1>
Last version tested | Terraform 4.1 azurerm 3.48 databricks 1.13

## Simple config. ❤️

main.tf

```
module "unity_catalog" {
  source  = "wiseupdata/unity_catalog/databricks"
  version = "0.0.1"

  stg_id_to_metastore = "your_storage_account_to_save_the_metastore"
  databricks_resource_id = "your_main_databricks_to_be_the_driver_to_your_metastore"
}
```

## Features ✨️

- Auto-generated tags
- Auto-generated the variable names
- Apply's the Standard, environment as suffix
- All variables are aptionals and can be overwrite with a custom value


## Hello world 🎉

> with az cli logged and with the right permissions! `az login` 👀️

Create a new directory.

```
mkdir tmp && cd tmp 
```

Create the main file with some infos.

```
cat <<EOF > main.tf
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "azurerm" {
  subscription_id = local.subscription_id
  features {}
}

provider "databricks" {
  host = local.databricks_workspace_host
}

module "unity_catalog" {
  source  = "wiseupdata/unity_catalog/databricks"
  version = "0.0.1"

  stg_id_to_metastore = "your_storage_account_to_save_the_metastore"
  databricks_resource_id = "your_main_databricks_to_be_the_driver_to_your_metastore"
}

output "databricks_workspaces_outputs" {
  value = module.databricks_workspaces
}
EOF
```

Create the resources in Azure 🤜

```
terraform init
terraform fmt -recursive
terraform validate
terraform plan -out plan.output
terraform apply plan.output
```

---

# Clean the resources 🏳

```
terraform destroy -auto-approve
cd ..
rm -Rf tmp
```


# References🤘

1. [Wise Up Data - Github](https://github.com/wiseupdata)
1. [Azure Databricks Prices](https://azure.microsoft.com/en-us/pricing/details/databricks/)
1. [Azure Databricks bellied per second](https://azure.microsoft.com/en-us/products/databricks/#heading-oc808f)
1. [Terraform setup](https://registry.terraform.io/providers/databricks/databricks/latest/docs/guides/unity-catalog-azure#provider-initialization)
1. [Terraform create groups](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_permission_assignment)
1. [Documentation 1](https://learn.microsoft.com/en-us/azure/databricks/data-governance/unity-catalog/automate)

---


# One of The most cheaper azure clusters is the one below

You can test in single mode.

![](https://raw.githubusercontent.com/wiseupdata/terraform-databricks-unity_catalog/main/assets/20230323_202510_image.png)

<br>

# Troubleshoot 😕

Recreate a workspace!

```
# Find all your resources!
terraform state list 

# Recreate the one with issue
terraform apply -replace=resource_with_issue
```
