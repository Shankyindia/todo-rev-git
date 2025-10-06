resource "azurerm_resource_group" "todo_rg" {
  name     = var.rg_name
  location = var.location
}
output "resource_group_location" {
  description = "The location of the Azure Resource Group"
  value       = azurerm_resource_group.todo_rg.location
}