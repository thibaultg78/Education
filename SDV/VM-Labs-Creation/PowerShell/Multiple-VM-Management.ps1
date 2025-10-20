# Display the Public IP for my VMs
Get-AzPublicIpAddress | Where-Object { $_.Name -like "*SDV*" } | Select-Object Name, IpAddress

# Stop and deallocate VMs with names containing "SDV"
Get-AzVM | Where-Object { $_.Name -like "*SDV*" } | ForEach-Object {
    Stop-AzVM -ResourceGroupName $_.ResourceGroupName -Name $_.Name -Force
}

# Start VMs with names containing "SDV"
Get-AzVM | Where-Object { $_.Name -like "*SDV*" } | ForEach-Object {
    Start-AzVM -ResourceGroupName $_.ResourceGroupName -Name $_.Name
}