# Creating one catalog per area
resource "databricks_catalog" "main" {
  count        = length(var.areas)
  metastore_id = databricks_metastore.this.id
  name         = "${var.areas[count.index]}_${var.env}"
  comment      = "This catalog is managed by terraform to area ${var.areas[count.index]}"
  properties = {
    purpose = "${var.areas[count.index]} area"
  }
  depends_on = [databricks_metastore_assignment.this]
}

# Crating one schema for each area
resource "databricks_schema" "main" {
  for_each     = { for entry in local.area_and_schema : "${entry.area}.${entry.schema}" => entry }
  catalog_name = each.value.area
  name         = each.value.schema
  comment      = "Managed by terraform for area: ${each.value.area} layer: ${each.value.schema}"
  properties = {
    kind = "various"
  }
}
