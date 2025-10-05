terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.41.0"
    }
  }
}
provider "azurerm" {
  features {}
  subscription_id = "4a56d5b3-94c0-47a0-ab55-850ee42f58bd"
}