module "todo_rg" {
  source = "../todo_infra/todo-rg"

  rg_name  = "todo-rg"
  location = "East US"
}
module "todo_rg1" {
  source = "../todo_infra/todo-rg"

  rg_name  = "todo-rg1"
  location = "East US"
}
module "todo_vnet" {
  depends_on = [module.todo_rg]
  source     = "../todo_infra/todo-vnet"
  vnet_name  = "vnet1"
  rg_name    = "todo-rg"
  location   = "East US"
}
module "subnet1" {
  depends_on  = [module.todo_vnet]
  source      = "../todo_infra/todo-subnet"
  subnet_name = "todo-subnet"
  rg_name     = "todo-rg"
  vnet_name = "vnet1"
  address_prefixes = ["10.0.1.0/24"]
}
module "key_vault_todo"{
  source = "../todo_infra/key_vault"
  depends_on = [module.todo_rg]
  key_vault_name = "tala-chabhi"
  rg_name = "todo-rg"
  location = "East US"

}

module "username"{
  source = "../todo_infra/key_vault_secret"
  depends_on = [module.key_vault_todo]
  secret_name = "fe-username"
  secret_value = "adminuser"
  rg_name = "todo-rg"
  key_vault_name = "tala-chabhi"
}

module "password"{
  source = "../todo_infra/key_vault_secret"
  depends_on = [module.key_vault_todo]
  secret_name = "fe-password"
  secret_value = "Shashank@1234"
  rg_name = "todo-rg"
  key_vault_name = "tala-chabhi"
}
module "pip_todo"{
  source = "../todo_infra/public_ip"
  depends_on = [module.todo_rg]
  pip_name = "todo_access_ip"
  rg_name = "todo-rg"
  location = "East US"
}

module "todo_vm" {
  depends_on = [ module.pip_todo,module.todo_rg,module.todo_vnet,module.key_vault_todo ]
  source = "../todo_infra/todo-vm"
  nic_name = "todo-nic_fe"
  rg_name = "todo-rg"
  location = "East US"
  vm_name = "todo-fe-vm"
  vnet_name = "vnet1"
  subnet_name = "todo-subnet"
  pip_name = "todo_access_ip"
  username_secret_name = "fe-username"
  password_secret_name = "fe-password"
  key_vault_name = "tala-chabhi"
}

module "subnet2" {
  depends_on  = [module.todo_vnet]
  source      = "../todo_infra/todo-subnet"
  subnet_name = "todo-subnet-be"
  rg_name     = "todo-rg"
  vnet_name   = "vnet1"
  address_prefixes = ["10.0.2.0/24"]
}

module "pip_todo_be"{
  source = "../todo_infra/public_ip"
  depends_on = [module.todo_rg]
  pip_name = "todo_access_ip_be"
  rg_name = "todo-rg"
  location = "East US"
}


module "todo_vm_be" {
  depends_on = [ module.todo_rg,module.todo_vnet,module.key_vault_todo,module.pip_todo_be,module.subnet2 ]
  source = "../todo_infra/todo-vm"
  nic_name = "todo-nic_be"
  rg_name = "todo-rg"
  location = "East US"
  vm_name = "todo-be-vm"
  vnet_name = "vnet1"
  subnet_name = "todo-subnet-be"
  pip_name = "todo_access_ip_be"
  username_secret_name = "fe-username"
  password_secret_name = "fe-password"
  key_vault_name = "tala-chabhi"
}
