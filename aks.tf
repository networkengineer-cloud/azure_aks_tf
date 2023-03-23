resource "azurerm_resource_group" "clsuter_rsg" {
  name     = "${var.cluster_name}-rsg"
  location = var.location

}

resource "random_pet" "pet" {
  length = 1
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = var.cluster_name
  location            = azurerm_resource_group.clsuter_rsg.location
  resource_group_name = azurerm_resource_group.clsuter_rsg.name

  dns_prefix                = coalesce(var.dns_prefix, var.cluster_name)
  automatic_channel_upgrade = var.automatic_channel_upgrade
  azure_policy_enabled      = var.azure_policy_enabled
  kubernetes_version        = var.kubernetes_version

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = var.network_plugin
  }
  default_node_pool {
    name                        = random_pet.pet.id
    enable_auto_scaling         = true
    max_count                   = var.default_pool["max_count"]
    min_count                   = var.default_pool["min_count"]
    node_count                  = var.default_pool["node_count"]
    node_taints                 = var.default_pool["node_taints"]
    node_labels                 = var.default_pool["node_labels"]
    temporary_name_for_rotation = var.default_pool["temporary_name_for_rotation"]
    vm_size                     = var.default_pool["vm_size"]
    # vnet_subnet_id              = var.default_pool["vnet_subnet_id"]
  }

}
