// az login // az login --use-device-code --tenant f34458be-7cef-47cc-940e-1e2694461a61
// terraform init
// terraform plan
// terraform apply

provider "azurerm" {
  features {}
  subscription_id = "d199b7c1-9da4-4867-910b-6a71b1bed2f8"
}

data "azurerm_resource_group" "rg" {
  name = "RG-Thibault-Gibard"
}

# Virtual Machines Definition
variable "vms" {
  type = list(object({
    name         = string
    vnet_name    = string
    subnet_name  = string
    private_ip   = string
  }))
  default = [
   // { name = "DEVO-VM00", vnet_name = "DEVO-VM00-vnet", subnet_name = "DEVO-VM00-subnet", private_ip = "10.0.0.4" },
    { name = "DEVO-VM11", vnet_name = "DEVO-VM11-vnet", subnet_name = "DEVO-VM11-subnet", private_ip = "10.0.0.4" },
    { name = "DEVO-VM22", vnet_name = "DEVO-VM22-vnet", subnet_name = "DEVO-VM22-subnet", private_ip = "10.0.0.4" }
  ]
}

# Creating Virtual Networks & Subnets
resource "azurerm_virtual_network" "vnet" {
  for_each            = { for vm in var.vms : vm.name => vm }
  name                = each.value.vnet_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]

  subnet {
    name           = each.value.subnet_name
    address_prefixes = ["10.0.0.0/24"]
  }
}

# Network Security Group & Rules
resource "azurerm_network_security_group" "nsg" {
  for_each            = { for vm in var.vms : vm.name => vm }
  name                = "${each.value.name}-nsg"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowRDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Public IPs
resource "azurerm_public_ip" "public_ip" {
  for_each            = { for vm in var.vms : vm.name => vm }
  name                = "${each.value.name}-ip"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Network Interfaces
resource "azurerm_network_interface" "nic" {
  for_each            = { for vm in var.vms : vm.name => vm }
  name                = "${each.value.name}-nic"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = element(azurerm_virtual_network.vnet[each.value.name].subnet[*].id, 0)
    private_ip_address_allocation = "Static"
    private_ip_address            = each.value.private_ip
    public_ip_address_id          = azurerm_public_ip.public_ip[each.value.name].id
  }
}

# NSG
resource "azurerm_network_interface_security_group_association" "nsg_assoc" {
  for_each                  = { for vm in var.vms : vm.name => vm }
  network_interface_id      = azurerm_network_interface.nic[each.value.name].id
  network_security_group_id = azurerm_network_security_group.nsg[each.value.name].id
}

# Virtual Machines
resource "azurerm_windows_virtual_machine" "vm" {
  for_each            = { for vm in var.vms : vm.name => vm }
  name                = each.value.name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  size                = "Standard_B4ms"
  patch_mode          = "AutomaticByPlatform"
  admin_username      = "student"
  admin_password      = "DevoCouCou123456_"

  network_interface_ids = [azurerm_network_interface.nic[each.value.name].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition-hotpatch-smalldisk"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = null
  }
}