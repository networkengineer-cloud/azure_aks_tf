variable "location" {
  type        = string
  default     = "centralus"
  description = "The Azure region to build the resources in."
}

variable "cluster_name" {
  type        = string
  description = "The name to use for the cluster."
}

variable "dns_prefix" {
  type        = string
  description = "An optional value to define a DNS Prefix for the cluster. Default is to use the cluster name. "
  default     = null
}

variable "automatic_channel_upgrade" {
  type        = string
  description = "The upgrade channel to enable for this clusters."
  default     = null

  #   validation {
  #     condition     = contains(["patch", "rapid", "node-image", "stable"], var.automatic_channel_upgrade) || var.automatic_channel_upgrade == null
  #     error_message = "The value is required to be 'patch', 'rapid', 'node-image', 'stable' or 'null."
  #   }
}

variable "azure_policy_enabled" {
  type        = bool
  default     = false
  description = "value"
}

variable "default_pool" {
  type = object({
    max_count                   = number
    min_count                   = number
    node_count                  = number
    node_labels                 = optional(map(string))
    node_taints                 = optional(list(string))
    temporary_name_for_rotation = optional(string)
    vm_size                     = string
    # vnet_subnet_id              = optional(string)
  })
  default = {
    max_count  = 5
    min_count  = 1
    node_count = 1
    vm_size    = "Standard_DS2_v2"
    # vnet_subnet_id = null
  }
  description = "The default values to use for creating the system node pool."
}

variable "kubernetes_version" {
  type        = string
  default     = "1.25"
  description = "The version of Kubernetes to use on the cluster."
}

variable "network_plugin" {
  type        = string
  default     = "kubenet"
  description = "The Network Plugin to use."

  validation {
    condition     = contains(["kubenet", "azure", "none"], var.network_plugin)
    error_message = "The network plugin value must be set to either 'kubenet', 'azure', or 'none'"
  }
}
