<#
.SYNOPSIS
    Generate multiple Azure VMs for SDV Labs.

.DESCRIPTION
    VMs will be created in a stopped state by default.

.EXAMPLE
    .\Multiple-VM-Creation.ps1
    Creates multiple Azure VMs for SDV Labs with default configuration

.NOTES
    File Name     : Multiple-VM-Creation.ps1
    Author        : Thibault Gibard
    Date          : 2025-01-20
    Version       : 1.0
    
    Prerequisites:
    - Azure PowerShell module (Az) installed
    - Authenticated connection to Azure (Connect-AzAccount)
    - Appropriate permissions to create VMs and networking resources
    - Valid Azure subscription
    
    Description:
    - Creates 12 Windows Server 2022 VMs (SDV-VM00 to SDV-VM11)
    - Each VM has its own VNet, subnet, public IP, and NSG
    - VMs are created in stopped state for cost optimization
    - Default credentials: student/SDVCouCou123456_
    - RDP access enabled on port 3389
#>


# Connect to Azure in PowerShell
#Connect-AzAccount
#Select-AzSubscription -SubscriptionId "6b6a9c6b-f4db-4532-a846-1fcfcf6e4b3f" -TenantId "2e2e6db7-6a76-4504-90a7-ec7e7ad01939" # sub-idf-01

# Cleaning
Clear-Host

# Global Variables
$ResourceGroupName = "RG-Thibault-Gibard"
$Location = "West Europe"

# VM Configuration
$VMs = @(
    <#@{ Name = "SDV-VM00"; VNet = "SDV-VM00-vnet"; Subnet = "SDV-VM00-subnet"; PrivateIP = "10.0.0.4" },
    @{ Name = "SDV-VM01"; VNet = "SDV-VM01-vnet"; Subnet = "SDV-VM01-subnet"; PrivateIP = "10.0.0.4" }#>
    @{ Name = "SDV-VM02"; VNet = "SDV-VM02-vnet"; Subnet = "SDV-VM02-subnet"; PrivateIP = "10.0.0.4" },
    @{ Name = "SDV-VM03"; VNet = "SDV-VM03-vnet"; Subnet = "SDV-VM03-subnet"; PrivateIP = "10.0.0.4" },
    @{ Name = "SDV-VM04"; VNet = "SDV-VM04-vnet"; Subnet = "SDV-VM04-subnet"; PrivateIP = "10.0.0.4" },
    @{ Name = "SDV-VM05"; VNet = "SDV-VM05-vnet"; Subnet = "SDV-VM05-subnet"; PrivateIP = "10.0.0.4" },
    @{ Name = "SDV-VM06"; VNet = "SDV-VM06-vnet"; Subnet = "SDV-VM06-subnet"; PrivateIP = "10.0.0.4" },
    @{ Name = "SDV-VM07"; VNet = "SDV-VM07-vnet"; Subnet = "SDV-VM07-subnet"; PrivateIP = "10.0.0.4" },
    @{ Name = "SDV-VM08"; VNet = "SDV-VM08-vnet"; Subnet = "SDV-VM08-subnet"; PrivateIP = "10.0.0.4" },
    @{ Name = "SDV-VM09"; VNet = "SDV-VM09-vnet"; Subnet = "SDV-VM09-subnet"; PrivateIP = "10.0.0.4" },
    @{ Name = "SDV-VM10"; VNet = "SDV-VM10-vnet"; Subnet = "SDV-VM10-subnet"; PrivateIP = "10.0.0.4" },
    @{ Name = "SDV-VM11"; VNet = "SDV-VM11-vnet"; Subnet = "SDV-VM11-subnet"; PrivateIP = "10.0.0.4" },
    @{ Name = "SDV-VM12"; VNet = "SDV-VM12-vnet"; Subnet = "SDV-VM12-subnet"; PrivateIP = "10.0.0.4" }
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

# Change Layout Keyboard in the VM
# Set-WinUserLanguageList -LanguageList fr-FR