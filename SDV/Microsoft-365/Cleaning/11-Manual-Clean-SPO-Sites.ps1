<#
.SYNOPSIS
    Clean all SharePoint Online sites except protected ones
.DESCRIPTION
    Simple script for Windows Server - installs module and cleans SPO sites
    Warning: Can work only on Windows environment and not macOS or Linux or something else.
    The PowerShell SPO module is not supported outside Windows Server or Windows Desktop
#>

# Install SharePoint Online module
Write-Host "Installing SharePoint Online module..." -ForegroundColor Cyan
Install-Module -Name Microsoft.Online.SharePoint.PowerShell -Force -AllowClobber
Import-Module Microsoft.Online.SharePoint.PowerShell

# Connect to SharePoint Online
# Use a Global Admin account
Write-Host "`nConnecting to SharePoint Online..." -ForegroundColor Cyan
Connect-SPOService -Url "https://1xyj7c-admin.sharepoint.com"

# Sites to keep
$protectedSites = @(
    "https://1xyj7c.sharepoint.com/sites/allcompany",
    "https://1xyj7c.sharepoint.com/sites/appcatalog",
    "https://1xyj7c.sharepoint.com",
    "https://1xyj7c.sharepoint.com/sites/wcontosoteam",
    "https://1xyj7c.sharepoint.com/sites/DigitalInitiativePublicRelations2",
    "https://1xyj7c.sharepoint.com/sites/wgive",
    "https://1xyj7c.sharepoint.com/sites/wlive",
    "https://1xyj7c.sharepoint.com/sites/MSFT",
    "https://1xyj7c.sharepoint.com/sites/SalesandMarketing",
    "https://1xyj7c.sharepoint.com/sites/U.S.Sales",
    "https://1xyj7c.sharepoint.com/sites/work"
)

Write-Host "`nGetting all sites..." -ForegroundColor Cyan
$allSites = Get-SPOSite -Limit All

$deletedCount = 0
$keptCount = 0

foreach ($site in $allSites) {
    # Skip root site
    if ($site.Url -eq "https://1xyj7c.sharepoint.com") {
        Write-Host "Skipping root site" -ForegroundColor Gray
        continue
    }
    
    # Keep protected sites
    if ($protectedSites -contains $site.Url) {
        Write-Host "Keeping: $($site.Url)" -ForegroundColor Cyan
        $keptCount++
    }
    else {
        Write-Host "Deleting: $($site.Url)" -ForegroundColor Yellow
        Remove-SPOSite -Identity $site.Url -Confirm:$false
        Write-Host "Deleted: $($site.Url)" -ForegroundColor Green
        $deletedCount++
    }
}

Write-Host "`nEmptying recycle bin..." -ForegroundColor Cyan
$deletedSites = Get-SPODeletedSite

foreach ($site in $deletedSites) {
    Write-Host "Permanently deleting: $($site.Url)" -ForegroundColor Yellow
    Remove-SPODeletedSite -Identity $site.Url -Confirm:$false
    Write-Host "Permanently deleted: $($site.Url)" -ForegroundColor Green
}

Write-Host "`nAll done!" -ForegroundColor Green
Write-Host "  Deleted: $deletedCount" -ForegroundColor Green
Write-Host "  Kept: $keptCount" -ForegroundColor Cyan