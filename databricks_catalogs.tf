
resource "databricks_catalog" "main" {
  metastore_id = databricks_metastore.this.id
  name         = var.areas[0]
  comment      = "This catalog is managed by terraform to area ${var.areas[0]}"
  properties = {
    purpose = "${var.areas[0]} area"
  }
  depends_on = [databricks_metastore_assignment.this]
}

resource "databricks_schema" "main" {
  catalog_name = databricks_catalog.main.id
  name         = var.container_to_catalog_names[0]
  comment      = "This database is managed by terraform"
  properties = {
    kind = "various"
  }
  # depends_on = [
  #   azuread_application.this, azuread_service_principal.this
  # ]
}
