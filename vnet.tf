resource "azurerm_virtual_network" "vnet" {
  count               = var.build_vnet ? 1 : 0
  name                = "${var.cluster_name}-vnet"
  location            = azurerm_resource_group.clsuter_rsg.location
  resource_group_name = azurerm_resource_group.clsuter_rsg.name

  address_space = var.address_space
}

locals {
  address_prefixes = cidrsubnet(element(var.address_space, 0), 4, 0)
}

resource "azurerm_subnet" "node_pool" {
  count                = var.build_vnet ? 1 : 0
  name                 = "${var.cluster_name}-subnet"
  resource_group_name  = azurerm_resource_group.clsuter_rsg.name
  virtual_network_name = azurerm_virtual_network.vnet[0].name

  address_prefixes  = [local.address_prefixes]
  service_endpoints = var.service_endpoints
}
