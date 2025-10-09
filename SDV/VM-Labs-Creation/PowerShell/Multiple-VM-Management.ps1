# Connect to Azure in PowerShell
Connect-AzAccount
Select-AzSubscription -Subs1criptionId "d199b7c1-9da4-4867-910b-6a71b1bed2f8"

# Resource Group & Location
$ResourceGroupName = "RG-Thibault-Gibard"
$Location = "West Europe"

# List VM
$allvm = Get-AzVM -ResourceGroupName $ResourceGroupName

# Stopping VM
foreach ($vm in $allvm) {
    Stop-AzVM -ResourceGroupName $ResourceGroupName -Name $vm.Name -Force
}

# Starting VM
foreach ($vm in $allvm) {
    Start-AzVM -ResourceGroupName $ResourceGroupName -Name $vm.Name
}

# Display public IP 
Get-AzPublicIpAddress -ResourceGroupName $ResourceGroupName