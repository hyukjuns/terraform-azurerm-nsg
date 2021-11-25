provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "nsg" {
  name     = "tf-rg"
  location = "koreacentral"
}

module "nsg" {
  source  = "app.terraform.io/cloocus-mspdevops/nsg/azurerm"
  version = "1.0.0"
  resource_group_name = azurerm_resource_group.nsg.name
  location            = azurerm_resource_group.nsg.location
  nsg_name            = "tf-nsg"

  rules = [
    {
      name                       = "ssh"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "*"
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "22"
    },
    {
      name                       = "http"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "*"
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "80,8080"
    },
    {
      name                         = "private_rule"
      priority                     = 120
      direction                    = "Inbound"
      access                       = "Allow"
      protocol                     = "Tcp"
      source_address_prefixes      = ["172.16.0.1", "172.16.0.2"]
      source_port_range            = "*"
      destination_address_prefixes = ["10.0.0.0/24", "192.168.0.1"]
      destination_port_range       = "3000,3001"
    }
  ]

  // attach_to_subnet = [module.network.subnet_id]
  // attach_to_nic = [module.linux.nic_id, module.window.nic_id]
  depends_on = [
    azurerm_resource_group.nsg
  ]
}