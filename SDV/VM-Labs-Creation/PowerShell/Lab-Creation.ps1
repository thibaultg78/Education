# Connect to Azure in PowerShell
Connect-AzAccount
Select-AzSubscription -SubscriptionId "d199b7c1-9da4-4867-910b-6a71b1bed2f8"

# Resource Group & Location
$ResourceGroupName = "RG-Thibault-Gibard"
$Location = "West Europe"

# VNet & Subnet creation
$VNetName = "SDV-VM02-vnet" # Specific
$AddressSpace = "10.0.0.0/16"
$SubnetName = "default"
$SubnetAddressRange = "10.0.0.0/24"

# Network configuration for the VM
$VMName = "SDV-VM02"
$NICName = "sdv-vm02-" + (Get-Random -Minimum 100 -Maximum 999)  # Génération d'un nom unique
$NSGName = "SDV-VM02-nsg"
$PublicIPName = "SDV-VM02-ip"
$PrivateIPAddress = "10.0.0.4"

# VM specification
$VMSize = "Standard_B4ms"
$Publisher = "MicrosoftWindowsServer"
$Offer = "WindowsServer"
$SKU = "2022-datacenter-azure-edition-hotpatch-smalldisk"
$Version = "latest"

# Identifiants d'administration (remplace avec des valeurs sécurisées)
$AdminUsername = "student"
$AdminPassword = ConvertTo-SecureString "SDVCouCou123456_" -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($AdminUsername, $AdminPassword)

# Creation of a new VNet
New-AzVirtualNetwork -ResourceGroupName $ResourceGroupName -Location $Location -Name $VNetName -AddressPrefix $AddressSpace

# Creation of a new Subnet
$VNet = Get-AzVirtualNetwork -ResourceGroupName $ResourceGroupName -Name $VNetName
$SubnetConfig = Add-AzVirtualNetworkSubnetConfig -Name $SubnetName -AddressPrefix $SubnetAddressRange -VirtualNetwork $VNet
Set-AzVirtualNetwork -VirtualNetwork $VNet

# Public IP creation
$PublicIP = New-AzPublicIpAddress -ResourceGroupName $ResourceGroupName -Location $Location -Name $PublicIPName -AllocationMethod Static -Sku Standard

# Creation of 3389 rule to connect to the VM
$NSGRule = New-AzNetworkSecurityRuleConfig -Name "AllowRDP" -Protocol Tcp -Direction Inbound `
    -Priority 100 -SourceAddressPrefix "*" -SourcePortRange "*" -DestinationAddressPrefix "*" `
    -DestinationPortRange 3389 -Access Allow

# NSG creation with previous rule
$NSG = New-AzNetworkSecurityGroup -ResourceGroupName $ResourceGroupName -Location $Location -Name $NSGName -SecurityRules $NSGRule

# Creation of a new interface network for the VM
$VNet = Get-AzVirtualNetwork -ResourceGroupName $ResourceGroupName -Name $VNetName
$Subnet = Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $VNet -Name $SubnetName

# Associating network interface & NSG
$NIC = New-AzNetworkInterface -ResourceGroupName $ResourceGroupName -Location $Location `
    -Name $NICName -SubnetId $Subnet.Id -PrivateIpAddress $PrivateIPAddress `
    -PublicIpAddressId $PublicIP.Id -NetworkSecurityGroupId $NSG.Id

# Creating the VM
$VMConfig = New-AzVMConfig -VMName $VMName -VMSize $VMSize |
    Set-AzVMOperatingSystem -Windows -ComputerName $VMName -Credential $Credential |
    Set-AzVMSourceImage -PublisherName $Publisher -Offer $Offer -Skus $SKU -Version $Version |
    Add-AzVMNetworkInterface -Id $NIC.Id |
    Set-AzVMBootDiagnostic -Disable

New-AzVM -ResourceGroupName $ResourceGroupName -Location $Location -VM $VMConfig

# Change Layour Keyboard in the VM
# Set-WinUserLanguageList -LanguageList fr-FR
