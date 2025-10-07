

# Lab Creation

SDV-Nantes-5-RSG

New-AzResourceGroup -Name "SDV-Nantes-0-RSG" -Location westeurope
New-AzResourceGroup -Name "SDV-Nantes-1-RSG" -Location westeurope
New-AzResourceGroup -Name "SDV-Nantes-2-RSG" -Location westeurope
New-AzResourceGroup -Name "SDV-Nantes-3-RSG" -Location westeurope
New-AzResourceGroup -Name "SDV-Nantes-4-RSG" -Location westeurope
New-AzResourceGroup -Name "SDV-Nantes-5-RSG" -Location westeurope
New-AzResourceGroup -Name "SDV-Nantes-50-RSG" -Location westeurope
New-AzResourceGroup -Name "SDV-Nantes-6-RSG" -Location westeurope
New-AzResourceGroup -Name "SDV-Nantes-7-RSG" -Location westeurope
New-AzResourceGroup -Name "SDV-Nantes-8-RSG" -Location westeurope
New-AzResourceGroup -Name "SDV-Nantes-9-RSG" -Location westeurope
New-AzResourceGroup -Name "SDV-Nantes-10-RSG" -Location westeurope
New-AzResourceGroup -Name "SDV-Nantes-11-RSG" -Location westeurope

# Lab Creation

New-AzResourceGroupDeployment -Name "deployment_group00" -ResourceGroupName `
"SDV-Nantes-0-RSG" -TemplateFile ./template-lab0.json -Mode Complete -Force

New-AzResourceGroupDeployment -Name "deployment_group01" -ResourceGroupName `
"SDV-Nantes-1-RSG" -TemplateFile ./template-lab1.json -Mode Complete -Force

New-AzResourceGroupDeployment -Name "deployment_group02" -ResourceGroupName `
"SDV-Nantes-2-RSG" -TemplateFile ./template-lab2.json -Mode Complete -Force

New-AzResourceGroupDeployment -Name "deployment_group03" -ResourceGroupName `
"SDV-Nantes-3-RSG" -TemplateFile ./template-lab3.json -Mode Complete -Force

New-AzResourceGroupDeployment -Name "deployment_group04" -ResourceGroupName `
"SDV-Nantes-4-RSG" -TemplateFile ./template-lab4.json -Mode Complete -Force

New-AzResourceGroupDeployment -Name "deployment_group05" -ResourceGroupName `
"SDV-Nantes-5-RSG" -TemplateFile ./template-lab5.json -Mode Complete -Force

New-AzResourceGroupDeployment -Name "deployment_group50" -ResourceGroupName `
"SDV-Nantes-50-RSG" -TemplateFile ./template-lab50.json -Mode Complete -Force

New-AzResourceGroupDeployment -Name "deployment_group06" -ResourceGroupName `
"SDV-Nantes-6-RSG" -TemplateFile ./template-lab6.json -Mode Complete -Force

New-AzResourceGroupDeployment -Name "deployment_group07" -ResourceGroupName `
"SDV-Nantes-7-RSG" -TemplateFile ./template-lab7.json -Mode Complete -Force

New-AzResourceGroupDeployment -Name "deployment_group08" -ResourceGroupName `
"SDV-Nantes-8-RSG" -TemplateFile ./template-lab8.json -Mode Complete -Force

New-AzResourceGroupDeployment -Name "deployment_group09" -ResourceGroupName `
"SDV-Nantes-9-RSG" -TemplateFile ./template-lab9.json -Mode Complete -Force

New-AzResourceGroupDeployment -Name "deployment_group10" -ResourceGroupName `
"SDV-Nantes-10-RSG" -TemplateFile ./template-lab10.json -Mode Complete -Force

New-AzResourceGroupDeployment -Name "deployment_group11" -ResourceGroupName `
"SDV-Nantes-11-RSG" -TemplateFile ./template-lab11.json -Mode Complete -Force

# Get all the publi address IP (careful it will display also my personal IPs)

Get-AzPublicIpAddress

# Stop all the VM by RSG

$all_rsg = @(
    "SDV-Nantes-0-RSG", 
    "SDV-Nantes-1-RSG", 
    "SDV-Nantes-2-RSG",
    "SDV-Nantes-3-RSG", 
    "SDV-Nantes-4-RSG", 
    "SDV-Nantes-5-RSG", 
    "SDV-Nantes-6-RSG", 
    "SDV-Nantes-7-RSG", 
    "SDV-Nantes-8-RSG", 
    "SDV-Nantes-9-RSG",
    "SDV-Nantes-10-RSG",
    "SDV-Nantes-11-RSG"
)

foreach ($rsg in $all_rsg) {
    $allvm = Get-AzVM -ResourceGroupName $rsg
    
    foreach ($vm in $allvm) {
        Write-Host "Stopping VM: " $vm.Name
        Stop-AzVM -ResourceGroupName $rsg -Name $vm.Name -Force
    }
}

# Start all VM by RSG

$all_rsg = @(
    "SDV-Nantes-0-RSG", 
    "SDV-Nantes-1-RSG", 
    "SDV-Nantes-2-RSG",
    "SDV-Nantes-3-RSG", 
    "SDV-Nantes-4-RSG", 
    "SDV-Nantes-5-RSG", 
    "SDV-Nantes-6-RSG", 
    "SDV-Nantes-7-RSG", 
    "SDV-Nantes-8-RSG", 
    "SDV-Nantes-9-RSG",
    "SDV-Nantes-10-RSG",
    "SDV-Nantes-11-RSG"
)

foreach ($rsg in $all_rsg) {
    $allvm = Get-AzVM -ResourceGroupName $rsg
    
    foreach ($vm in $allvm) {
        Write-Host "Stopping VM: " $vm.Name
        Start-AzVM -ResourceGroupName $rsg -Name $vm.Name -Force
    }
}