provider "azurerm" {
  version = "~>2.0"
  features {}
}

resource "random_id" "instance_id" {
  byte_length = 8
}

resource "azurerm_resource_group" "rg" {
  name     = "cldmr-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = "cldmr-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.4.2.0/24"]
  tags                = var.tags
}

resource "azurerm_subnet" "subnet" {
  address_prefixes     = ["10.4.2.0/24"]
  name                 = "default"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_network_security_group" "nsg" {
  name                = "cldmr-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags

  security_rule {
    name                       = "Allow-HTTP"
    description                = "Allow HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-SSH"
    description                = "Allow SSH Limited"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefixes    = ["89.64.51.191"]
    destination_address_prefix = "*"
  }
}

resource "azurerm_public_ip" "pip_cldmr" {
  name                = "cldmr-server-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  domain_name_label   = "cldmr-server"
  
}

# Create network interface
resource "azurerm_network_interface" "nic_cldmr" {
  name                      = "cldmr-server-nic"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.rg.name
  tags                      = var.tags

  ip_configuration {
    name                          = "cldmr-server-nicConfg"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.pip_cldmr.id
  }
}

resource "azurerm_network_interface_security_group_association" "nsg_association_cldmr" {
  network_interface_id      = azurerm_network_interface.nic_cldmr.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}


resource "azurerm_virtual_machine" "cldmr-server" {
  name = "cldmr-server-vm"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic_cldmr.id]
  vm_size = "Standard_B1s"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "cldmr-server-vm-boot-${random_id.instance_id.hex}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.storage_type
    disk_size_gb      = var.storage_size
  }

  os_profile {
    computer_name  = "cldmr-server-vm"
    admin_username = var.admin_username
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = file("~/.ssh/keycard1.pub")
      path = "/home/${var.admin_username}/.ssh/authorized_keys"
    }
  }
  tags = var.tags
}

output "instance_ip_addr" {
  value = azurerm_public_ip.pip_cldmr.ip_address
}
