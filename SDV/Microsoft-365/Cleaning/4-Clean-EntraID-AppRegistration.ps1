<# 
.SYNOPSIS
    Script for deleting Microsoft Entra ID application registrations.
.DESCRIPTION
    Deletes all applications registered in Microsoft Entra ID (except those specified to keep),
    including permanent deletion of applications in the recycle bin.
    Uses Microsoft Graph PowerShell to completely clean up application registrations.
#>

Clear-Host

# App to keep
$keepAppId = "b555720e-0cea-4d42-8dc1-08ec93e520fb" # PowerShell-GitHub-Automation-EntraID

# Get all apps
$allApps = Get-MgApplication

# Filter and delete
foreach ($app in $allApps) {
    if ($app.AppId -ne $keepAppId) {
        Write-Host "Deleting: $($app.DisplayName)" -ForegroundColor Yellow
        Remove-MgApplication -ApplicationId $app.Id -Confirm:$false
        Write-Host "✅ Deleted: $($app.DisplayName)" -ForegroundColor Green
    }
    else {
        Write-Host "⏭️  Keeping: $($app.DisplayName)" -ForegroundColor Cyan
    }
}

# Get all deleted apps
$deletedApps = Get-MgDirectoryDeletedItemAsApplication

# Delete permanently
foreach ($app in $deletedApps) {
    Write-Host "Permanently deleting: $($app.DisplayName)" -ForegroundColor Yellow
    Remove-MgDirectoryDeletedItem -DirectoryObjectId $app.Id -Confirm:$false
    Write-Host "✅ Permanently deleted: $($app.DisplayName)" -ForegroundColor Green
}

Write-Host "`n✅ Recycle bin cleaned!" -ForegroundColor Green

exit 0 # Exit with code 0 to avoid breaking CI/CD pipelines