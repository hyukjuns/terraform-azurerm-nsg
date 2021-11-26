variable "resource_group_name" {
    type = string
    description = "rg name"
}
variable "location" {
    type = string
    description = "rg location"
}
variable "nsg_name" {
    type = string
    description = "nsg name"
}
variable "nsg_rules" {
    type = any
    description = "nsg rules"
}