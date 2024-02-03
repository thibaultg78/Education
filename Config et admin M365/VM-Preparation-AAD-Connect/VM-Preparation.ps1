# Installing Active Directory Domain Services Role
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

# Creating the new Active Directory Forest/Domain
Install-ADDSForest -DomainName "sdv.local" -DomainNetBiosName "SDV" -InstallDns:$true -NoRebootCompletion:$true

# You main Domain ADDS account will be the Local one you've used previously
# However, it will be now an Active Directory account - you must connect with : SDV\user and your password

# Restarting the server
Restart-Computer



