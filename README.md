# terraform-azurerm-nsg
## 환경 준비
### OS
- MacOS or Linux or WSL2
### Registry
terraform cloud private repository
### Version & Provider
- Terraform( > 0.13.0)
- hashicorp/azurerm( > 2.60.0)
## 사용 예제
[usage-sample](./usage-sample)
```
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "nsg" {
  name     = "tf-rg"
  location = "koreacentral"
}
module "nsg" {
  source  = "app.terraform.io/cloocus-mspdevops/nsg/azurerm"
  version = "x.x.x"
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
```
## Inputs
### Required
```
resource_group_name (string)
location (string)
nsg_name (srting)
rules (any)
```
### Optional
```
attach_to_subnet (list)
attach_to_nic (list)
```
### rules 입력시 참고사항
- rules

    name,\
    priority,\
    direction,\
    access,\
    protocol,\
    source_address_prefix,\
    source_address_prefixes,\
    source_port_range,\
    destination_address_prefix,\
    destination_address_prefixes,\
    destination_port_range,\
    source_application_security_group_ids

- 서비스 태그 및 *(Any)는 source_address_prefix/destination_address_prefix 에 선언
- 복수 주소는 source_address_prefixes/destination_address_prefixes 에 list로 선언

- 포트가 여러개 일 경우 source_port_range/destination_port_range 에 string 형식으로("3000, 3001") 선언

## Outputs
[details](./outputs.tf)
```
nsg_name
nsg_id
```