<#
.SYNOPSIS
    Clean all Entra ID groups except protected ones
#>

Clear-Host

# Groups to keep (by DisplayName)
$protectedGroups = @(
    "All Company",
    "Contoso Team",
    "Digital Initiative Public Relations",
    "IT-Department",
    "MSFT",
    "Sales and Marketing",
    "SDV Students",
    "U.S. Sales"
)

Write-Host "Getting all groups..." -ForegroundColor Cyan
$allGroups = Get-MgGroup -All

$deletedCount = 0
$keptCount = 0

foreach ($group in $allGroups) {
    if ($protectedGroups -contains $group.DisplayName) {
        Write-Host "⏭️  Keeping: $($group.DisplayName)" -ForegroundColor Cyan
        $keptCount++
    }
    else {
        Write-Host "Deleting: $($group.DisplayName)" -ForegroundColor Yellow
        Remove-MgGroup -GroupId $group.Id -Confirm:$false
        Write-Host "✅ Deleted: $($group.DisplayName)" -ForegroundColor Green
        $deletedCount++
    }
}

Write-Host "`n✅ Groups cleanup done! Deleted: $deletedCount | Kept: $keptCount" -ForegroundColor Green

# Now clean the recycle bin
Write-Host "`nCleaning groups recycle bin..." -ForegroundColor Cyan
$deletedGroups = Get-MgDirectoryDeletedItemAsGroup

foreach ($group in $deletedGroups) {
    Write-Host "Permanently deleting: $($group.DisplayName)" -ForegroundColor Yellow
    Remove-MgDirectoryDeletedItem -DirectoryObjectId $group.Id -Confirm:$false
    Write-Host "✅ Permanently deleted: $($group.DisplayName)" -ForegroundColor Green
}

Write-Host "`n✅ Recycle bin cleaned!" -ForegroundColor Green

exit 0 # Exit with code 0 to avoid breaking CI/CD pipelines