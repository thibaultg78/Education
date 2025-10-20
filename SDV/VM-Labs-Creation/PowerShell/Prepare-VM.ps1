#####################################################################
# Configuration & Administration Microsoft 365 / Offce 365
# School: SUP DE VINCI
# Group: ASI 3-24 SRC ISI NANTES 
#####################################################################

# Connect in RDP to the Windows Server
# Use the Local Administrator and password account provided by the teacher
# Open Windows PowerShell prompt with Admin privileges and execute the following snippets

# Disable FW to avoid any lock by the school intrastructure (unsafe but not production)
Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled False

# Disable IE Enhanced Security Configuration (ESC)
$AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
$UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0
Stop-Process -Name Explorer # It will be restarted automatically
Write-Host "IE Enhanced Security Configuration (ESC) has been disabled." -ForegroundColor Green

# Installing Active Directory Domain Services Role
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

# Creating the new Active Directory Forest/Domain
# You will need to confirm the installation

# Restoration Password: Mandatory but not needed for us
$Secure_String_Pwd = ConvertTo-SecureString "SDVPassword123456!" -AsPlainText -Force

# Naming your ADDS Forest/Domain depending on your group number

#$GroupNumber = Read-Host "What is your group number?"
#$DomainName = "SDV" + $GroupNumber + ".local"

$DomainName = "SDV.local"
Install-ADDSForest -DomainName $DomainNAme -DomainNetBiosName "SDV" -InstallDns:$true `
    -NoRebootOnCompletion:$true -SafeModeAdministratorPassword $Secure_String_Pwd

# Restarting the server
Restart-Computer

# You main Domain ADDS account will be the Local one you've used previously
# However, it will be now an Active Directory account - you must connect with : SDV\user and the same password

# Creation of new Organizational Unit 
New-ADOrganizationalUnit "SDV"

# Creation of the OU arborescence
New-ADOrganizationalUnit -Name "Users" -Path "OU=SDV,DC=SDV,DC=LOCAL"
New-ADOrganizationalUnit -Name "Groups" -Path "OU=SDV,DC=SDV,DC=LOCAL"
New-ADOrganizationalUnit -Name "Computers" -Path "OU=SDV,DC=SDV,DC=LOCAL"
New-ADOrganizationalUnit -Name "Servers" -Path "OU=SDV,DC=SDV,DC=LOCAL"

# Installing StarWars scripts
# You will have to answer Y (Yes) to several questions
Install-Module StarWars -Confirm -SkipPublisherCheck

# Users creation
New-StarWarsADUser -Path 'OU=Users,OU=SDV,DC=SDV,DC=LOCAL'

# Groups creation
New-StarWarsADGroup -Path 'OU=Groups,OU=SDV,DC=SDV,DC=LOCAL'

# Adding people in the groups
Add-StarWarsADUserToAdGroup

# Finally, Download and Install : Azure AD Connect / Microsoft Entra ID Connect
# https://download.microsoft.com/download/B/0/0/B00291D0-5A83-4DE7-86F5-980BC00DE05A/AzureADConnect.msi

#####################################################################
# End of Script
#####################################################################