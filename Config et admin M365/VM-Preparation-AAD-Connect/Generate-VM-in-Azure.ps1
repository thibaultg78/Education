#####################################################################
# Create Labs VM
# School: SUP DE VINCI
# Group: ASI 3-24 SRC ISI NANTES 
#####################################################################

# Connect to Azure
Connect-AzAccount

# MCT Subscribtion
Select-AzSubscription -Tenant 8fce7df7-df3d-419b-94f1-31483245b3c7 -Subscription "b23edba1-d2f9-42d4-8503-5dd98d3a3e22"


# Resource Groups creation
# Creating 10 resource groups different for each student groups
# for ($i = 1; $i -le 10; $i++) {
#     if ($i -eq 10) {
#         $name = "Group10"
#     }
#     else {
#         $name = "Group0" + $i
#     }
#     $name
#     New-AzResourceGroup -Name $name -Location 'North Europe' 
# }

# Deletion of all Resource Groups
Remove-AzResourceGroup -Name "Group01" -Force
Remove-AzResourceGroup -Name "Group02" -Force
Remove-AzResourceGroup -Name "Group03" -Force
Remove-AzResourceGroup -Name "Group04" -Force
Remove-AzResourceGroup -Name "Group05" -Force
Remove-AzResourceGroup -Name "Group06" -Force
Remove-AzResourceGroup -Name "Group07" -Force
Remove-AzResourceGroup -Name "Group08" -Force
Remove-AzResourceGroup -Name "Group09" -Force
Remove-AzResourceGroup -Name "Group10" -Force

# Creation of new Resource Groups
New-AzResourceGroup -Name "Group01" -Location 'North Europe' 
New-AzResourceGroup -Name "Group02" -Location 'North Europe'
New-AzResourceGroup -Name "Group03" -Location 'North Europe' 
New-AzResourceGroup -Name "Group04" -Location 'North Europe' 
New-AzResourceGroup -Name "Group05" -Location 'North Europe' 
New-AzResourceGroup -Name "Group06" -Location 'North Europe' 
New-AzResourceGroup -Name "Group07" -Location 'North Europe' 
New-AzResourceGroup -Name "Group08" -Location 'North Europe' 
New-AzResourceGroup -Name "Group09" -Location 'North Europe' 
New-AzResourceGroup -Name "Group10" -Location 'North Europe' 

# Credentials
$VMLocalAdminUser = "student"
$VMLocalAdminSecurePassword = ConvertTo-SecureString "SDVStudent123456?!" -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($VMLocalAdminUser, $VMLocalAdminSecurePassword);

# Parameters
$LocationName = "northeurope"

# Public IP creation
New-AzPublicIpAddress -Name "SDVVMGroup01pip" -ResourceGroupName "Group01" -AllocationMethod Static -Location $LocationName
New-AzPublicIpAddress -Name "SDVVMGroup02pip" -ResourceGroupName "Group02" -AllocationMethod Static -Location $LocationName
New-AzPublicIpAddress -Name "SDVVMGroup03pip" -ResourceGroupName "Group03" -AllocationMethod Static -Location $LocationName
New-AzPublicIpAddress -Name "SDVVMGroup04pip" -ResourceGroupName "Group04" -AllocationMethod Static -Location $LocationName
New-AzPublicIpAddress -Name "SDVVMGroup05pip" -ResourceGroupName "Group05" -AllocationMethod Static -Location $LocationName
New-AzPublicIpAddress -Name "SDVVMGroup06pip" -ResourceGroupName "Group06" -AllocationMethod Static -Location $LocationName
New-AzPublicIpAddress -Name "SDVVMGroup07pip" -ResourceGroupName "Group07" -AllocationMethod Static -Location $LocationName
New-AzPublicIpAddress -Name "SDVVMGroup08pip" -ResourceGroupName "Group08" -AllocationMethod Static -Location $LocationName
New-AzPublicIpAddress -Name "SDVVMGroup09pip" -ResourceGroupName "Group09" -AllocationMethod Static -Location $LocationName
New-AzPublicIpAddress -Name "SDVVMGroup10pip" -ResourceGroupName "Group10" -AllocationMethod Static -Location $LocationName

# VM creation
New-AzVM -Name "SDVVMGroup01" -Credential $Credential -SecurityType "Standard" `
    -ResourceGroupName "Group01" -Location $LocationName `-Size "Standard_B2ms" `
    -Image "MicrosoftWindowsServer:WindowsServer:2022-datacenter-g2:latest" -PublicIpAddressName "SDVVMGroup01pip"

New-AzVM -Name "SDVVMGroup02" -Credential $Credential -SecurityType "Standard" `
    -ResourceGroupName "Group02" -Location $LocationName `-Size "Standard_B2ms" `
    -Image "MicrosoftWindowsServer:WindowsServer:2022-datacenter-g2:latest" -PublicIpAddressName "SDVVMGroup02pip"

New-AzVM -Name "SDVVMGroup03" -Credential $Credential -SecurityType "Standard" `
    -ResourceGroupName "Group03" -Location $LocationName `-Size "Standard_B2ms" `
    -Image "MicrosoftWindowsServer:WindowsServer:2022-datacenter-g2:latest" -PublicIpAddressName "SDVVMGroup03pip"

New-AzVM -Name "SDVVMGroup04" -Credential $Credential -SecurityType "Standard" `
    -ResourceGroupName "Group04" -Location $LocationName `-Size "Standard_B2ms" `
    -Image "MicrosoftWindowsServer:WindowsServer:2022-datacenter-g2:latest" -PublicIpAddressName "SDVVMGroup04pip"

New-AzVM -Name "SDVVMGroup05" -Credential $Credential -SecurityType "Standard" `
    -ResourceGroupName "Group05" -Location $LocationName `-Size "Standard_B2ms" `
    -Image "MicrosoftWindowsServer:WindowsServer:2022-datacenter-g2:latest" -PublicIpAddressName "SDVVMGroup05pip"

New-AzVM -Name "SDVVMGroup06" -Credential $Credential -SecurityType "Standard" `
    -ResourceGroupName "Group06" -Location $LocationName `-Size "Standard_B2ms" `
    -Image "MicrosoftWindowsServer:WindowsServer:2022-datacenter-g2:latest" -PublicIpAddressName "SDVVMGroup06pip"

New-AzVM -Name "SDVVMGroup07" -Credential $Credential -SecurityType "Standard" `
    -ResourceGroupName "Group07" -Location $LocationName `-Size "Standard_B2ms" `
    -Image "MicrosoftWindowsServer:WindowsServer:2022-datacenter-g2:latest" -PublicIpAddressName "SDVVMGroup07pip"

New-AzVM -Name "SDVVMGroup08" -Credential $Credential -SecurityType "Standard" `
    -ResourceGroupName "Group08" -Location $LocationName `-Size "Standard_B2ms" `
    -Image "MicrosoftWindowsServer:WindowsServer:2022-datacenter-g2:latest" -PublicIpAddressName "SDVVMGroup08pip"

New-AzVM -Name "SDVVMGroup09" -Credential $Credential -SecurityType "Standard" `
    -ResourceGroupName "Group09" -Location $LocationName `-Size "Standard_B2ms" `
    -Image "MicrosoftWindowsServer:WindowsServer:2022-datacenter-g2:latest" -PublicIpAddressName "SDVVMGroup09pip"

New-AzVM -Name "SDVVMGroup10" -Credential $Credential -SecurityType "Standard" `
    -ResourceGroupName "Group10" -Location $LocationName `-Size "Standard_B2ms" `
    -Image "MicrosoftWindowsServer:WindowsServer:2022-datacenter-g2:latest" -PublicIpAddressName "SDVVMGroup10pip"

# Stopping Virtual Machine
Stop-AzVM -ResourceGroupName "Group01" -Name "SDVVMGroup01" -NoWait
Stop-AzVM -ResourceGroupName "Group02" -Name "SDVVMGroup02" -NoWait
Stop-AzVM -ResourceGroupName "Group03" -Name "SDVVMGroup03" -NoWait
Stop-AzVM -ResourceGroupName "Group04" -Name "SDVVMGroup04" -NoWait
Stop-AzVM -ResourceGroupName "Group05" -Name "SDVVMGroup05" -Nowait
Stop-AzVM -ResourceGroupName "Group06" -Name "SDVVMGroup06" -Nowait
Stop-AzVM -ResourceGroupName "Group07" -Name "SDVVMGroup07" -Nowait
Stop-AzVM -ResourceGroupName "Group08" -Name "SDVVMGroup08" -Nowait
Stop-AzVM -ResourceGroupName "Group09" -Name "SDVVMGroup09" -Nowait
Stop-AzVM -ResourceGroupName "Group010" -Name "SDVVMGroup10" -NoWait

# Starting Virtual Machine
Start-AzVM -ResourceGroupName "Group01" -Name "SDVVMGroup01"
Start-AzVM -ResourceGroupName "Group02" -Name "SDVVMGroup02"
Start-AzVM -ResourceGroupName "Group03" -Name "SDVVMGroup03"
Start-AzVM -ResourceGroupName "Group04" -Name "SDVVMGroup04"
Start-AzVM -ResourceGroupName "Group05" -Name "SDVVMGroup05"
Start-AzVM -ResourceGroupName "Group06" -Name "SDVVMGroup06"
Start-AzVM -ResourceGroupName "Group07" -Name "SDVVMGroup07"
Start-AzVM -ResourceGroupName "Group08" -Name "SDVVMGroup08"
Start-AzVM -ResourceGroupName "Group09" -Name "SDVVMGroup09"
Start-AzVM -ResourceGroupName "Group010" -Name "SDVVMGroup10"

# Get all IP Addresses
foreach ($rsg in (Get-AzResourceGroup)) {
    Get-AzPublicIpAddress -ResourceGroupName $rsg.ResourceGroupName
}

#####################################################################
# End of Script
#####################################################################