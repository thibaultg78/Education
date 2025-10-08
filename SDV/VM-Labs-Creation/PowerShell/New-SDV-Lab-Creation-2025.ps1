<#
 # This script is used to create a new SDV Lab environment for Microsoft 365 training.
 # I will connect to an Azure Subscribtion and process the VM creation for 15 VMs
#>

# Connect to Azure Account
#Connect-AzAccount -Tenant "2e2e6db7-6a76-4504-90a7-ec7e7ad01939" `
# -Subscription "6b6a9c6b-f4db-4532-a846-1fcfcf6e4b3f"

# Global parameters
$resourceGroupName = "RG-Thibault-Gibard"
$location = "France Central"
$vmSize = "Standard_B2ms"
$adminUsername = "student"
$adminPassword = ConvertTo-SecureString "SDVStudentPassword123456!" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($adminUsername, $adminPassword)

# For Loop to create 2 VMs
for ($i = 1; $i -le 2; $i++) {
    $vmName = "SDV-VM{0:D2}" -f $i
    
    # Derived names
    $vnetName = "$vmName-VNet"
    $subnetName = "$vmName-Subnet"
    $nicName = "$vmName-NIC"
    $pipName = "$vmName-PIP"
    $nsgName = "$vmName-NSG"
    
    Write-Host "`n=== Creating $vmName ===" -ForegroundColor Green
    
    # NSG with RDP rule
    Write-Host "  Creating NSG..." -ForegroundColor Yellow
    $rdpRule = New-AzNetworkSecurityRuleConfig -Name "Allow-RDP" `
        -Protocol Tcp -Direction Inbound -Priority 1000 `
        -SourceAddressPrefix * -SourcePortRange * `
        -DestinationAddressPrefix * -DestinationPortRange 3389 `
        -Access Allow
    
    $nsg = New-AzNetworkSecurityGroup -Name $nsgName `
        -ResourceGroupName $resourceGroupName `
        -Location $location `
        -SecurityRules $rdpRule
    
    # VNet and Subnet
    Write-Host "  Creating VNet and Subnet..." -ForegroundColor Yellow
    $subnet = New-AzVirtualNetworkSubnetConfig -Name $subnetName `
        -AddressPrefix "10.$i.0.0/24" `
        -NetworkSecurityGroup $nsg
    
    $vnet = New-AzVirtualNetwork -Name $vnetName `
        -ResourceGroupName $resourceGroupName `
        -Location $location `
        -AddressPrefix "10.$i.0.0/16" `
        -Subnet $subnet
    
    $subnet = Get-AzVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $vnet
    
    # Public IP
    Write-Host "  Creating Public IP..." -ForegroundColor Yellow
    $pip = New-AzPublicIpAddress -Name $pipName `
        -ResourceGroupName $resourceGroupName `
        -Location $location `
        -AllocationMethod Static `
        -Sku Standard
    
    # NIC
    Write-Host "  Creating NIC..." -ForegroundColor Yellow
    $nic = New-AzNetworkInterface -Name $nicName `
        -ResourceGroupName $resourceGroupName `
        -Location $location `
        -SubnetId $subnet.Id `
        -PublicIpAddressId $pip.Id `
        -NetworkSecurityGroupId $nsg.Id
    
    # VM Configuration
    Write-Host "  Creating VM..." -ForegroundColor Yellow
    $vmConfig = New-AzVMConfig -VMName $vmName -VMSize $vmSize
    $vmConfig = Set-AzVMOperatingSystem -VM $vmConfig -Windows -ComputerName $vmName -Credential $credential -ProvisionVMAgent -EnableAutoUpdate
    $vmConfig = Set-AzVMSourceImage -VM $vmConfig -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2025-datacenter-azure-edition" -Version "latest"
    $vmConfig = Add-AzVMNetworkInterface -VM $vmConfig -Id $nic.Id
    $vmConfig = Set-AzVMBootDiagnostic -VM $vmConfig -Disable
    
    New-AzVM -ResourceGroupName $resourceGroupName -Location $location -VM $vmConfig | Out-Null
    
    Write-Host "VM created: $vmName | IP: $($pip.IpAddress) | User: $adminUsername" -ForegroundColor Cyan
}

Write-Host "`n=== All VMs are created! ===" -ForegroundColor Green

Exit

# Display the Public IP for my VMs
Get-AzPublicIpAddress | Where-Object {$_.Name -like "*SDV*"}