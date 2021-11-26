provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "nsg" {
  name     = var.resource_group_name
  location = var.location
}

module "nsg" {
  source  = "app.terraform.io/cloocus-mspdevops/nsg/azurerm"
  version = "1.0.0"
  resource_group_name = azurerm_resource_group.nsg.name
  location            = azurerm_resource_group.nsg.location
  nsg_name            = var.nsg_name

  rules = var.nsg_rules

  // attach_to_subnet = [module.network.subnet_id]
  // attach_to_nic = [module.linux.nic_id, module.window.nic_id]
  depends_on = [
    azurerm_resource_group.nsg
  ]
}