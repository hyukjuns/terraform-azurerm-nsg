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

# Tags => source_address_prefix/destination_address_prefix
variable "rules" {
  type        = any
  description = <<EOF"
  name,
  priority,
  direction,
  access,
  protocol,
  source_address_prefix/es,
  source_port_range,
  destination_address_prefix,
  destination_address_prefixex,
  destination_port_range"
  EOF
  default     = []
}

# [Optional] Attach NSG to subnet or nic or neither
variable "attach_to_subnet" {
  type        = list
  description = "Are you attach this nsg to subnet? true or false"
  default     = []
}
variable "attach_to_nic" {
  type        = list
  description = "Are you attach this nsg to subnet? true or false"
  default     = []
}