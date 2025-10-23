# Display the Public IP for my VMs
Get-AzPublicIpAddress | Where-Object { $_.Name -like "*SDV*" } | Select-Object Name, IpAddress, Status

# Stop and deallocate VMs with names containing "SDV"
Get-AzVM | Where-Object { $_.Name -like "*SDV*" } | ForEach-Object {
    Stop-AzVM -ResourceGroupName $_.ResourceGroupName -Name $_.Name -Force
}

# Start VMs with names containing "SDV"
Get-AzVM | Where-Object { $_.Name -like "*SDV*" } | ForEach-Object {
    Start-AzVM -ResourceGroupName $_.ResourceGroupName -Name $_.Name
}

# Display the VM name its power state
# Get-AzVM -Status | Where-Object { $_.Name -like "*SDV*" } | Select-Object Name, PowerState
Get-AzVM -Status | Where-Object { $_.Name -like "*SDV*" } | Select-Object Name, ResourceGroupName, PowerState, Location
