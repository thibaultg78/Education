// terraform init
// terraform plan
// terraform apply

//az login --use-device-code --tenant "2e2e6db7-6a76-4504-90a7-ec7e7ad01939" && az account set --subscription "6b6a9c6b-f4db-4532-a846-1fcfcf6e4b3f"


resource "azurerm_network_security_group" "nsg" {
  count               = var.vm_count
  name                = "SDV-VM${format("%02d", count.index + 1)}-NSG"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.main.name

  security_rule {
    name                       = "Allow-RDP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Virtual Network (1 par VM)
resource "azurerm_virtual_network" "vnet" {
  count               = var.vm_count
  name                = "SDV-VM${format("%02d", count.index + 1)}-VNet"
  address_space       = ["10.${count.index + 1}.0.0/16"]
  location            = var.location
  resource_group_name = data.azurerm_resource_group.main.name
}

# Subnet (1 par VM)
resource "azurerm_subnet" "subnet" {
  count                = var.vm_count
  name                 = "SDV-VM${format("%02d", count.index + 1)}-Subnet"
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.vnet[count.index].name
  address_prefixes     = ["10.${count.index + 1}.0.0/24"]
}

# Association NSG au Subnet
resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  count                     = var.vm_count
  subnet_id                 = azurerm_subnet.subnet[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg[count.index].id
}

# Public IP (1 par VM)
resource "azurerm_public_ip" "pip" {
  count               = var.vm_count
  name                = "SDV-VM${format("%02d", count.index + 1)}-PIP"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Network Interface (1 par VM)
resource "azurerm_network_interface" "nic" {
  count               = var.vm_count
  name                = "SDV-VM${format("%02d", count.index + 1)}-NIC"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet[count.index].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip[count.index].id
  }
}

# Association NSG à la NIC
resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  count                     = var.vm_count
  network_interface_id      = azurerm_network_interface.nic[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg[count.index].id
}

# Virtual Machines
resource "azurerm_windows_virtual_machine" "vm" {
  count               = var.vm_count
  name                = "SDV-VM${format("%02d", count.index + 1)}"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  patch_mode          = "AutomaticByPlatform"

  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2025-datacenter-azure-edition"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = null
  }
}