data "azurerm_subnet" "subnet1" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.rg_name
}
data "azurerm_key_vault" "key_vault_todo" {
  name                = var.key_vault_name
  resource_group_name = var.rg_name
}
data "azurerm_key_vault_secret" "username" {
  name         = var.username
  key_vault_id = data.azurerm_key_vault.key_vault_todo.id
}
data "azurerm_key_vault_secret" "password" {
  name         = var.password
  key_vault_id = data.azurerm_key_vault.key_vault_todo.id
}
data "azurerm_public_ip" "pip_todo" {
  name                = var.pip_name
  resource_group_name = var.rg_name
}