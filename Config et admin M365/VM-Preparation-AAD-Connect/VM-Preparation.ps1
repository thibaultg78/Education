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
$Secure_String_Pwd = ConvertTo-SecureString "SDVPassword123456!" -AsPlainText -Force
Install-ADDSForest -DomainName "sdv.local" -DomainNetBiosName "SDV" -InstallDns:$true `
-NoRebootOnCompletion:$true -SafeModeAdministratorPassword $Secure_String_Pwd

# You main Domain ADDS account will be the Local one you've used previously
# However, it will be now an Active Directory account - you must connect with : SDV\user and your password

# Restarting the server
Restart-Computer



