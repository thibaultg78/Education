<#
.SYNOPSIS
    Clean all SharePoint Online sites and containers except protected ones
.DESCRIPTION
    Simple script for Windows Server - installs module and cleans SPO sites + containers
    Warning: Can work only on Windows environment and not macOS or Linux or something else.
    The PowerShell SPO module is not supported outside Windows Server.
    Works perfectly on a new VM on Azure with Windows Server
#>

# Install SharePoint Online module
Write-Host "Installing SharePoint Online module..." -ForegroundColor Cyan
Install-Module -Name Microsoft.Online.SharePoint.PowerShell -Force -AllowClobber
Import-Module Microsoft.Online.SharePoint.PowerShell

# Connect to SharePoint Online
# Use a Global Admin account
Write-Host "`nConnecting to SharePoint Online..." -ForegroundColor Cyan
Connect-SPOService -Url "https://1xyj7c-admin.sharepoint.com"

# ============================================
# PART 1: SITES CLEANUP
# ============================================

Write-Host "`n========================================" -ForegroundColor Magenta
Write-Host "SITES CLEANUP" -ForegroundColor Magenta
Write-Host "========================================" -ForegroundColor Magenta

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

$deletedSitesCount = 0
$keptSitesCount = 0

foreach ($site in $allSites) {
    # Skip root site
    if ($site.Url -eq "https://1xyj7c.sharepoint.com") {
        Write-Host "Skipping root site" -ForegroundColor Gray
        continue
    }
    
    # Keep protected sites
    if ($protectedSites -contains $site.Url) {
        Write-Host "Keeping: $($site.Url)" -ForegroundColor Cyan
        $keptSitesCount++
    }
    else {
        Write-Host "Deleting: $($site.Url)" -ForegroundColor Yellow
        Remove-SPOSite -Identity $site.Url -Confirm:$false
        Write-Host "Deleted: $($site.Url)" -ForegroundColor Green
        $deletedSitesCount++
    }
}

# Empty sites recycle bin
Write-Host "`nEmptying sites recycle bin..." -ForegroundColor Cyan
$deletedSites = Get-SPODeletedSite

foreach ($site in $deletedSites) {
    Write-Host "Permanently deleting site: $($site.Url)" -ForegroundColor Yellow
    Remove-SPODeletedSite -Identity $site.Url -Confirm:$false
    Write-Host "Permanently deleted site: $($site.Url)" -ForegroundColor Green
}

# ============================================
# PART 2: CONTAINERS CLEANUP
# ============================================

Write-Host "`n========================================" -ForegroundColor Magenta
Write-Host "CONTAINERS CLEANUP" -ForegroundColor Magenta
Write-Host "========================================" -ForegroundColor Magenta

# Initialize container counter
$deletedContainersCount = 0

# Get all active containers
Write-Host "`nGetting all active containers..." -ForegroundColor Cyan
try {
    $activeContainers = Get-SPOContainer -Limit All
    
    if ($activeContainers) {
        foreach ($container in $activeContainers) {
            Write-Host "Deleting container: $($container.ContainerId) - $($container.ContainerName)" -ForegroundColor Yellow
            Remove-SPOContainer -Identity $container.ContainerId -Confirm:$false
            Write-Host "Deleted container: $($container.ContainerId)" -ForegroundColor Green
            $deletedContainersCount++
        }
        
        Write-Host "`nDeleted $deletedContainersCount active container(s)" -ForegroundColor Green
    }
    else {
        Write-Host "No active containers found" -ForegroundColor Gray
    }
}
catch {
    Write-Host "Error processing active containers: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "This might be normal if you don't have SharePoint Embedded containers" -ForegroundColor Gray
}

# Empty containers recycle bin
Write-Host "`nEmptying deleted containers..." -ForegroundColor Cyan
try {
    $deletedContainers = Get-SPODeletedContainer
    
    if ($deletedContainers) {
        foreach ($container in $deletedContainers) {
            Write-Host "Permanently deleting container: $($container.ContainerId) - $($container.ContainerName)" -ForegroundColor Yellow
            Remove-SPODeletedContainer -Identity $container.ContainerId -Confirm:$false
            Write-Host "Permanently deleted container: $($container.ContainerId)" -ForegroundColor Green
        }
        
        Write-Host "`nPermanently deleted $($deletedContainers.Count) deleted container(s)" -ForegroundColor Green
    }
    else {
        Write-Host "No deleted containers found in recycle bin" -ForegroundColor Gray
    }
}
catch {
    Write-Host "Error processing deleted containers: $($_.Exception.Message)" -ForegroundColor Red
}

# ============================================
# SUMMARY
# ============================================

Write-Host "`n========================================" -ForegroundColor Magenta
Write-Host "CLEANUP SUMMARY" -ForegroundColor Magenta
Write-Host "========================================" -ForegroundColor Magenta
Write-Host "Sites deleted: $deletedSitesCount" -ForegroundColor Green
Write-Host "Sites kept: $keptSitesCount" -ForegroundColor Cyan
Write-Host "Containers deleted: $deletedContainersCount" -ForegroundColor Green
Write-Host "`nAll done!" -ForegroundColor Green