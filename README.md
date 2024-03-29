<!-- BEGIN_TF_DOCS -->
# terraform-azurerm-nsg
Azure Network Security Group Module <br>
Terraform Cloud Module Registry에 등록하여 관리 하는 VCS 입니다.
### Terraform Cloud Module Registry에 연결하기 위한 VCS Naming Convention
- ```terraform-<PROVIDER>-<MODULENAME>```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.0 |

## Modules

No modules.

## Usage
```
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "nsg" {
  name     = "tf-rg"
  location = "koreacentral"
}
module "nsg" {
  source  = "<TFC_REGISTRY>"
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

  attach_to_subnet = [module.network.subnet_id]
  # attach_to_nic = [module.linux.nic_id, module.window.nic_id]
  depends_on = [
    azurerm_resource_group.nsg
  ]
}
```

## Resources

| Name | Type |
|------|------|
| [azurerm_network_interface_security_group_association.nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_network_security_group.nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_subnet_network_security_group_association.nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_resource_group.nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs
- 서비스 태그 및 *(Any)는 source_address_prefix/destination_address_prefix 에 선언
- 복수 주소는 source_address_prefixes/destination_address_prefixes 에 list로 선언

- 포트가 여러개 일 경우 source_port_range/destination_port_range 에 string 형식으로("3000, 3001") 선언

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attach_to_nic"></a> [attach\_to\_nic](#input\_attach\_to\_nic) | nic id 나열 | `list` | `[]` | no |
| <a name="input_attach_to_subnet"></a> [attach\_to\_subnet](#input\_attach\_to\_subnet) | subnet id 나열 | `list` | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | location | `string` | n/a | yes |
| <a name="input_nsg_name"></a> [nsg\_name](#input\_nsg\_name) | NSG Name | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource Group Name | `string` | n/a | yes |
| <a name="input_rules"></a> [rules](#input\_rules) | name,priority,direction,access,protocol,source\_address\_prefix,source\_address\_prefixes,source\_port\_range,destination\_address\_prefix,destination\_address\_prefixex,destination\_port\_range | `any` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nsg_id"></a> [nsg\_id](#output\_nsg\_id) | The ID of the Network Security Group. |
| <a name="output_nsg_name"></a> [nsg\_name](#output\_nsg\_name) | The Name of the Network Security Group. |
<!-- END_TF_DOCS -->
