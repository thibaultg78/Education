<# 
.SYNOPSIS
    Snippet to add Global Admin rights to all the SDV Entra ID user accounts.
#>

#Connect-MgGraph -Scopes "User.ReadWrite.All"

# Add Global Admin role to all user accounts
# Get Global Admin role ID
$globalAdminRole = Get-MgDirectoryRole -Filter "DisplayName eq 'Global Administrator'"
if (-not $globalAdminRole) {
    $roleTemplate = Get-MgDirectoryRoleTemplate -Filter "DisplayName eq 'Global Administrator'"
    $globalAdminRole = New-MgDirectoryRole -RoleTemplateId $roleTemplate.Id
}

# Get SDV Users group
$sdvUsersGroup = Get-MgGroup -Filter "DisplayName eq 'SDV Students'"

1..25 | ForEach-Object {
    $userId = "student{0:D2}@1xyj7c.onmicrosoft.com" -f $_
    $user = Get-MgUser -UserId $userId
    
    # Add Global Admin role
    $params = @{
        "@odata.id" = "https://graph.microsoft.com/v1.0/directoryObjects/$($user.Id)"
    }
    New-MgDirectoryRoleMemberByRef -DirectoryRoleId $globalAdminRole.Id -BodyParameter $params
    
    # Add to SDV Users group
    New-MgGroupMember -GroupId $sdvUsersGroup.Id -DirectoryObjectId $user.Id
    
    Write-Host "Added $userId to Global Admin role and SDV Users group" -ForegroundColor Green
}