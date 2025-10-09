# Connect to Azure in PowerShell
#Connect-AzAccount
Connect-AzAccount
#Select-AzSubscription -SubscriptionId "d199b7c1-9da4-4867-910b-6a71b1bed2f8"

# Cleaning
Clear-Host

# Global Variables
$ResourceGroupName = "RG-Thibault-Gibard"
$Location = "West Europe"

# VM Configuration
$VMs = @(
    @{ Name = "SDV-VM00"; VNet = "SDV-VM00-vnet"; Subnet = "SDV-VM00-subnet"; PrivateIP = "10.0.0.4" },
    @{ Name = "SDV-VM01"; VNet = "SDV-VM01-vnet"; Subnet = "SDV-VM01-subnet"; PrivateIP = "10.0.0.4" },
    @{ Name = "SDV-VM02"; VNet = "SDV-VM02-vnet"; Subnet = "SDV-VM02-subnet"; PrivateIP = "10.0.0.4" },
    @{ Name = "SDV-VM03"; VNet = "SDV-VM03-vnet"; Subnet = "SDV-VM03-subnet"; PrivateIP = "10.0.0.4" },
    @{ Name = "SDV-VM04"; VNet = "SDV-VM04-vnet"; Subnet = "SDV-VM04-subnet"; PrivateIP = "10.0.0.4" },
    @{ Name = "SDV-VM05"; VNet = "SDV-VM05-vnet"; Subnet = "SDV-VM05-subnet"; PrivateIP = "10.0.0.4" },
    @{ Name = "SDV-VM06"; VNet = "SDV-VM06-vnet"; Subnet = "SDV-VM06-subnet"; PrivateIP = "10.0.0.4" }
)

# Windows Server configuration
$VMSize = "Standard_B4ms"
$Publisher = "MicrosoftWindowsServer"
$Offer = "WindowsServer"
$SKU = "2022-datacenter-azure-edition-hotpatch-smalldisk"
$Version = "latest"

# Identifiants d'administration (à sécuriser)
$AdminUsername = "student"
$AdminPassword = ConvertTo-SecureString "SDVCouCou123456_" -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($AdminUsername, $AdminPassword)

foreach ($VM in $VMs) {
    $VMName = $VM.Name
    $VNetName = $VM.VNet
    $SubnetName = $VM.Subnet
    $PrivateIPAddress = $VM.PrivateIP
    $PublicIPName = "$VMName-ip"
    $NSGName = "$VMName-nsg"
    $NICName = "$VMName-nic"

    ### Virtual Network & Subnet creation ###
    $SubnetConfig = New-AzVirtualNetworkSubnetConfig -Name $SubnetName -AddressPrefix "10.0.0.0/24"
    $VNet = New-AzVirtualNetwork -ResourceGroupName $ResourceGroupName -Location $Location `
        -Name $VNetName -AddressPrefix "10.0.0.0/16" -Subnet $SubnetConfig

    ### Public IP creation ###
    $PublicIP = New-AzPublicIpAddress -ResourceGroupName $ResourceGroupName -Location $Location `
        -Name $PublicIPName -AllocationMethod Static -Sku Standard

    ### NSG & 3389 opening creation ###
    $NSGRule = New-AzNetworkSecurityRuleConfig -Name "AllowRDP" -Protocol Tcp -Direction Inbound `
        -Priority 100 -SourceAddressPrefix "*" -SourcePortRange "*" -DestinationAddressPrefix "*" `
        -DestinationPortRange 3389 -Access Allow
    $NSG = New-AzNetworkSecurityGroup -ResourceGroupName $ResourceGroupName -Location $Location `
        -Name $NSGName -SecurityRules $NSGRule

    ### Network interface creation for each vm ###
    $Subnet = Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $VNet -Name $SubnetName
    $NIC = New-AzNetworkInterface -ResourceGroupName $ResourceGroupName -Location $Location `
        -Name $NICName -SubnetId $Subnet.Id -PrivateIpAddress $PrivateIPAddress `
        -PublicIpAddressId $PublicIP.Id -NetworkSecurityGroupId $NSG.Id

    ### VM generation ###
    $VMConfig = New-AzVMConfig -VMName $VMName -VMSize $VMSize |
        Set-AzVMOperatingSystem -Windows -ComputerName $VMName -Credential $Credential |
        Set-AzVMSourceImage -PublisherName $Publisher -Offer $Offer -Skus $SKU -Version $Version |
        Add-AzVMNetworkInterface -Id $NIC.Id |
        Set-AzVMBootDiagnostic -Disable

    New-AzVM -ResourceGroupName $ResourceGroupName -Location $Location -VM $VMConfig -AsJob
}


# Change Layour Keyboard in the VM
# Set-WinUserLanguageList -LanguageList fr-FR