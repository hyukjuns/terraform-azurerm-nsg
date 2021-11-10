# terraform-azurerm-nsg
for azure nsg modules
### nsg
- nsg
    - Required Values
        ```
        resource_group_name
        location
        nsg_name
        rules
        ```
        ```
        rules
        "[name, priority, direction, access, protocol, ,source_address_prefix/es, source_port_range, destination_address_prefix/es, destination_port_range,source_application_security_group_ids]"

        서비스 태그 및 *(Any)는 source_address_prefix/destination_address_prefix 에 선언
        복수 주소는 source_address_prefixes/destination_address_prefixes 에 list로 선언

        *포트가 여러개 일 경우 source_port_range/destination_port_range 에 string 형식으로("3000, 3001") 선언
        ```
    - Optional Values
        ```
        attach_to_subnet
        attach_to_nic
        *리스트 변수 이며, nsg를 연결할 subnet 혹은 nic의 id를 리스트에 나열,
        선언하지 않을 경우 경우 nsg를 attach하지 않는것으로 간주
        ```
    - outputs
        ```
        nsg_name
        ```