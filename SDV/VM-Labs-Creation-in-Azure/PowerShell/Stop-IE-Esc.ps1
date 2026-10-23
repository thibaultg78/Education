
<#
.SYNOPSIS
    Disable IE Enhanced Security Configuration on selected Azure VMs.

.DESCRIPTION
    Applies the IE ESC registry settings remotely using Azure VM Run Command.

.EXAMPLE
    Connect-AzAccount
    .\Stop-IE-Esc.ps1

.NOTES
    Prerequisites:
    - Az.Compute module and an authenticated Azure context
    - Permission to run commands on the VMs
    - Target VMs must be running
    - Edit $VMNames to choose which VMs to target
#>

# Requires -Modules Az.Compute

$ResourceGroupName = "RG-Thibault-Gibard"
$VMNames = @(
    "SDV-VM00",
    <#"SDV-VM01",
	"SDV-VM02",
	"SDV-VM03",
	"SDV-VM04",
	"SDV-VM05",
	"SDV-VM06",#>
    "SDV-VM07",
    "SDV-VM08"
)

$ScriptString = @'
$AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
$UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0
Write-Output "IE Enhanced Security Configuration disabled."
'@

foreach ($VMName in $VMNames) {
    Write-Host "Applying IE ESC setting to $VMName..." -ForegroundColor Cyan
    $Result = Invoke-AzVMRunCommand -ResourceGroupName $ResourceGroupName `
        -VMName $VMName -CommandId "RunPowerShellScript" -ScriptString $ScriptString
    $Result.Value | ForEach-Object { Write-Host $_.Message }
}
