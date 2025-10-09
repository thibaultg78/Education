output "public_ips" {
    value = { for vm in azurerm_windows_virtual_machine.vm : vm.name => azurerm_public_ip.public_ip[vm.name].ip_address }
  }