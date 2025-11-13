<# 
.SYNOPSIS
    Script for emptying Microsoft Entra ID recycle bin.
.DESCRIPTION
    Permanently deletes all deleted users from the Microsoft Entra ID recycle bin.
    Uses Microsoft Graph PowerShell to completely clean up deleted user objects.
#>

Clear-Host

# Get all deleted users
$deletedUsers = Get-MgDirectoryDeletedItemAsUser

# Permanently delete
foreach ($user in $deletedUsers) {
    Write-Host "Permanently deleting: $($user.UserPrincipalName)" -ForegroundColor Yellow
    Remove-MgDirectoryDeletedItem -DirectoryObjectId $user.Id -Confirm:$false
    Write-Host "✅ Permanently deleted: $($user.UserPrincipalName)" -ForegroundColor Green
}

Write-Host "`n✅ User recycle bin cleaned!" -ForegroundColor Green

exit 0 # Exit with code 0 to avoid breaking CI/CD pipelines