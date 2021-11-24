data "azurerm_resource_group" "nsg" {
  name = var.resource_group_name
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  resource_group_name = data.azurerm_resource_group.nsg.name
  location            = coalesce(var.location, data.azurerm_resource_group.nsg.location)
}

resource "azurerm_network_security_rule" "nsg" {
  count                                 = length(var.rules)
  name                                  = lookup(var.rules[count.index], "name", "default_rule_name")
  priority                              = lookup(var.rules[count.index], "priority")
  direction                             = lookup(var.rules[count.index], "direction", "Inbound")
  access                                = lookup(var.rules[count.index], "access", "Allow")
  protocol                              = lookup(var.rules[count.index], "protocol", "Tcp")
  source_address_prefix                 = (lookup(var.rules[count.index], "source_application_security_group_ids", null) == null && lookup(var.rules[count.index], "source_address_prefixes", null) == null) ? lookup(var.rules[count.index], "source_address_prefix", "*") : null
  source_address_prefixes               = lookup(var.rules[count.index], "source_application_security_group_ids", null) == null ? lookup(var.rules[count.index], "source_address_prefixes", null) : null
  source_port_range                     = lookup(var.rules[count.index], "source_port_range", "*") == "*" ? "*" : null
  source_port_ranges                    = lookup(var.rules[count.index], "source_port_range", "*") == "*" ? null : split(",", var.rules[count.index].source_port_range)
  destination_address_prefix            = (lookup(var.rules[count.index], "destination_application_security_group_ids", null) == null && lookup(var.rules[count.index], "destination_address_prefixes", null) == null) ? lookup(var.rules[count.index], "destination_address_prefix", "*") : null
  destination_address_prefixes          = lookup(var.rules[count.index], "destination_application_security_group_ids", null) == null ? lookup(var.rules[count.index], "destination_address_prefixes", null) : null
  destination_port_range                = lookup(var.rules[count.index], "destination_port_range", "*") == "*" ? "*" : null
  destination_port_ranges               = lookup(var.rules[count.index], "destination_port_range", "*") == "*" ? null : split(",", var.rules[count.index].destination_port_range)
  source_application_security_group_ids = lookup(var.rules[count.index], "source_application_security_group_ids", null)

  network_security_group_name = azurerm_network_security_group.nsg.name
  resource_group_name         = data.azurerm_resource_group.nsg.name
}

resource "azurerm_subnet_network_security_group_association" "nsg" {
  count                     = (var.attach_to_subnet == null) ? 0 : length(var.attach_to_subnet)
  subnet_id                 = var.attach_to_subnet[count.index]
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_interface_security_group_association" "nsg" {
  count                     = (var.attach_to_nic == null) ? 0 : length(var.attach_to_nic)
  network_interface_id      = var.attach_to_nic[count.index]
  network_security_group_id = azurerm_network_security_group.nsg.id
}