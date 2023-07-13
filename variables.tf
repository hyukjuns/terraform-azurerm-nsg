# Required
variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
}
variable "location" {
  type        = string
  description = "location"
}
variable "nsg_name" {
  type        = string
  description = "NSG Name"
}

# Service Tags => source_address_prefix/destination_address_prefix
variable "rules" {
  type        = any
  description = "name,priority,direction,access,protocol,source_address_prefix,source_address_prefixes,source_port_range,destination_address_prefix,destination_address_prefixex,destination_port_range"
  default     = []
}

# [Optional] Attach NSG to subnet or nic or neither
variable "attach_to_subnet" {
  type        = list(any)
  description = "subnet id 나열"
  default     = []
}
variable "attach_to_nic" {
  type        = list(any)
  description = "nic id 나열"
  default     = []
}