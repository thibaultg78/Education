output "vm_info" {
  description = "Informations des VMs créées"
  value = [
    for i in range(var.vm_count) : {
      vm_name   = azurerm_windows_virtual_machine.vm[i].name
      public_ip = azurerm_public_ip.pip[i].ip_address
      username  = var.admin_username
    }
  ]
}

output "vm_names" {
  description = "Liste des noms de VMs"
  value       = [for vm in azurerm_windows_virtual_machine.vm : vm.name]
}

output "public_ips" {
  description = "Liste des IPs publiques"
  value       = [for pip in azurerm_public_ip.pip : pip.ip_address]
}