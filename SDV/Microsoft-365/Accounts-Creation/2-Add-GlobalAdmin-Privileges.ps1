<# 
.SYNOPSIS
    Snippet to add Global Admin rights to all the SDV Entra ID user accounts.
#>

Clear-Host

# Basic configuration
$domain = "1xyj7c.onmicrosoft.com"

# Add Global Admin role to all user accounts
# Get Global Admin role ID
$globalAdminRole = Get-MgDirectoryRole -Filter "DisplayName eq 'Global Administrator'"
if (-not $globalAdminRole) {
    $roleTemplate = Get-MgDirectoryRoleTemplate -Filter "DisplayName eq 'Global Administrator'"
    $globalAdminRole = New-MgDirectoryRole -RoleTemplateId $roleTemplate.Id
}

# Get SDV Users group
$sdvUsersGroup = Get-MgGroup -Filter "DisplayName eq 'SDV Students'"

foreach ($i in 1..25) {
    # Formater le numéro étudiant avec zéro devant
    if ($i -lt 10) {
        $studentNumber = "student0$i"
    }
    else {
        $studentNumber = "student$i"
    }

    $userId = "$studentNumber@$domain"
    $user = Get-MgUser -UserId $userId
    
    # Add Global Admin role
    $params = @{
        "@odata.id" = "https://graph.microsoft.com/v1.0/directoryObjects/$($user.Id)"
    }
    New-MgDirectoryRoleMemberByRef -DirectoryRoleId $globalAdminRole.Id -BodyParameter $params
    Write-Host "Providing $userId Global Admin privileges" -ForegroundColor Yellow
    
    # Add to SDV Users group
    New-MgGroupMember -GroupId $sdvUsersGroup.Id -DirectoryObjectId $user.Id
    Write-Host "Added $userId to Global Admin role and SDV Users group" -ForegroundColor Green
}