#Module 1 - Exercise 2B
#This PowerShell script assign a role to an existing user

#Import AzureAD module, in case it was not imported
Import-Module AzureAD

#Request credential if we haven't connected yet
if ($AzureADCred -eq $null) {$AzureADCred = Get-Credential}
Connect-AzureAD -Credential $AzureADCred

# Fetch user to assign to role
$roleMember = (Get-AzureADUser -SearchString "Sam")

# Fetch Company Administrator role instance
$role = Get-AzureADDirectoryRole | Where-Object {$_.displayName -eq 'Company Administrator'}

# If role instance does not exist, instantiate it based on the role template
if ($role -eq $null) {
    # Instantiate an instance of the role template
    $roleTemplate = Get-AzureADDirectoryRoleTemplate | Where-Object {$_.displayName -eq 'Company Administrator'}
    Enable-AzureADDirectoryRole -RoleTemplateId $roleTemplate.ObjectId

    # Fetch Company Administrator role instance again
    $role = Get-AzureADDirectoryRole | Where-Object {$_.displayName -eq 'Company Administrator'}
}

# Add user to role
Add-AzureADDirectoryRoleMember -ObjectId $role.ObjectId -RefObjectId $roleMember.ObjectId

# Fetch role membership for role to confirm
#Get-AzureADDirectoryRoleMember -ObjectId $role.ObjectId | Get-AzureADUser 
Get-AzureADDirectoryRoleMember -ObjectId $role.ObjectId | ?{$_.ObjectType -eq "user"} | Get-AzureADUser