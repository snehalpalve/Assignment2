resource "azurerm_resource_group" "kpmgrg" {
  name     = local.resource_group_name
  location = local.location
}