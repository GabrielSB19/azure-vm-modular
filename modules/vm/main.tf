resource "azurerm_public_ip" "devops_ip" {
    name                = "${var.name_function}-public-ip"
    location            = var.location
    resource_group_name = var.resource_group_name
    allocation_method   = "Static"
}

resource "azurerm_network_interface" "devops_nic" {
    name                = "${var.name_function}-nic"
    location            = var.location
    resource_group_name = var.resource_group_name

    ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.devops_ip.id
    }
}

resource "azurerm_network_security_group" "devops_sg" {
    name                = "${var.name_function}-sg"
    location            = var.location
    resource_group_name = var.resource_group_name


    security_rule {
        name = "test123SSH"
        priority = "100"
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "22"
        source_address_prefix  = "*"
        destination_address_prefix = "*"
    }

    security_rule{
        name = "PING"
        priority = "1000"
        direction = "Inbound"
        access = "Allow"
        protocol = "Icmp"
        source_port_range = "*"
        destination_port_range = "*"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = "Production"
    }
}

resource "azurerm_network_interface_security_group_association" "devops_association" {
    network_interface_id      = azurerm_network_interface.devops_nic.id
    network_security_group_id = azurerm_network_security_group.devops_sg.id
}

resource "azurerm_linux_virtual_machine" "vm_devops" {
    name = "${var.name_function}-machine"
    resource_group_name = var.resource_group_name
    location = var.location
    size = "Standard_F2"
    admin_username = var.user
    network_interface_ids = [azurerm_network_interface.devops_nic.id]

   admin_ssh_key {
        username = var.user
        public_key = file("C:/Users/semillero/id_rsa.pub")
    }

    os_disk {
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer = "0001-com-ubuntu-server-focal"
        sku = "20_04-lts"
        version = "latest"
    }
}