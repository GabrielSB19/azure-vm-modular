resource "azurerm_resource_group" "main" {
    name     = "${var.name_function}-rg"
    location = var.location
}

resource "azurerm_virtual_network" "main" {
    name                = "${var.name_function}-network"
    location            = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name
    address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "main" {
    name                 = "${var.name_function}-subnet"
    resource_group_name  = azurerm_resource_group.main.name
    virtual_network_name = azurerm_virtual_network.main.name
    address_prefixes     = ["10.0.1.0/24"]
}

module "vm" {
    source = "./modules/vm"
    resource_group_name = azurerm_resource_group.main.name
    location = azurerm_resource_group.main.location
    subnet_id = azurerm_subnet.main.id
    name_function = var.name_function
    user = var.username
}