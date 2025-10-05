module "todo_rg" {
  source   = "../todo_infra/todo-rg"
  rg_name  = "todo-rg"
  location = "Central India"
}

module "todo_vnet" {
  depends_on = [module.todo_rg]
  source     = "../todo_infra/todo-vnet"
  vnet_name  = "vnet1"
  rg_name    = "todo-rg"
  location   = "Central India"
  address_spaces = ["10.0.0.0/16"]
}
module "subnet1" {
  depends_on       = [module.todo_vnet,module.todo_rg]
  source           = "../todo_infra/todo-subnet"
  subnet_name      = "todo-subnet"
  rg_name          = "todo-rg"
  vnet_name        = "vnet1"
  address_prefixes = ["10.0.1.0/24"]
}
module "key_vault_todo" {
  source         = "../todo_infra/key_vault"
  depends_on     = [module.todo_rg]
  key_vault_name = "sonukatijori1008"
  rg_name        = "todo-rg"
  location       = "Central India"

}

module "vmwa-username" {
  source         = "../todo_infra/key_vault_secret"
  depends_on     = [module.key_vault_todo,module.todo_rg]
  secret_name    = "vmwa-username"
  secret_value   = "adminuser"
  rg_name        = "todo-rg"
  key_vault_name = "sonukatijori1008"
}

module "vmwa-password" {
  source         = "../todo_infra/key_vault_secret"
  depends_on     = [module.key_vault_todo,module.todo_rg]
  secret_name    = "vmwa-password"
  secret_value   = "Shashank@1234"
  rg_name        = "todo-rg"
  key_vault_name = "sonukatijori1008"
}
module "pip_todo" {
  source     = "../todo_infra/public_ip"
  depends_on = [module.todo_rg]
  pip_name   = "todo_access_ip"
  rg_name    = "todo-rg"
  location   = module.todo_rg.resource_group_location
}

module "todo_vm" {
  depends_on           = [module.pip_todo, module.todo_rg, module.todo_vnet,module.pip_todo,module.vmwa-password,module.vmwa-username,module.key_vault_todo]
  source               = "../todo_infra/todo-vm"
  nic_name             = "todo-nic_fe"
  rg_name              = "todo-rg"
  location             = module.todo_rg.resource_group_location
  vm_name              = "todo-fe-vm"
  vnet_name            = "vnet1"
  subnet_name          = "todo-subnet"
  pip_name             = "todo_access_ip"
  username             = "vmwa-username"
  password             = "vmwa-password"
  key_vault_name       = "sonukatijori1008"
}

module "subnet2" {
  depends_on       = [module.todo_vnet,module.todo_rg]
  source           = "../todo_infra/todo-subnet"
  subnet_name      = "todo-subnet-be"
  rg_name          = "todo-rg"
  vnet_name        = "vnet1"
  address_prefixes = ["10.0.2.0/24"]
}

module "pip_todo_be" {
  source     = "../todo_infra/public_ip"
  depends_on = [module.todo_rg]
  pip_name   = "todo_access_ip_be"
  rg_name    = "todo-rg"
  location   = module.todo_rg.resource_group_location
}


module "todo_vm_be" {
  depends_on           = [module.todo_rg, module.todo_vnet, module.pip_todo_be, module.subnet2,module.key_vault_todo,module.vmwa-password,module.vmwa-username]
  source               = "../todo_infra/todo-vm"
  nic_name             = "todo-nic_be"
  rg_name              = "todo-rg"
  location             = module.todo_rg.resource_group_location
  vm_name              = "todo-be-vm"
  vnet_name            = "vnet1"
  subnet_name          = "todo-subnet-be"
  pip_name             = "todo_access_ip_be" 
  username = "vmwa-username"
  password = "vmwa-password"
  key_vault_name       = "sonukatijori1008"
}
# module "db_server" {
#   depends_on                   = [module.todo_rg]
#   source                       = "../todo_infra/DB_server"
#   server_name                  = "todo-sql-server"
#   rg_name                      = "todo-rg"
#   location                     = "East US"
#   administrator_login          = "sqladminuser"
#   administrator_login_password = "Shashank@1234"
# }
# module "database" {
#   depends_on  = [module.db_server]
#   source      = "../todo_infra/database"
#   db_name     = "todo_db"
#   server_name = "todo-sql-server"
#   rg_name     = "todo-rg"
# }
