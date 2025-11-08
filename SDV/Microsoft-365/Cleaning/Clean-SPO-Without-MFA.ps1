<#
.SYNOPSIS
    Clean SharePoint Online sites using temporary admin account without MFA
#>

$domain = "1xyj7c.onmicrosoft.com"
$tempUserUPN = "spo-cleanup-temp@$domain"
$tempPassword = "TempCleanup$(Get-Random -Minimum 1000 -Maximum 9999)!"

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

Write-Host "Step 1: Creating temporary admin account..." -ForegroundColor Cyan
$userParams = @{
    AccountEnabled    = $true
    DisplayName       = "SPO Cleanup Temp"
    MailNickname      = "spo-cleanup-temp"
    UserPrincipalName = $tempUserUPN
    PasswordProfile   = @{
        Password                      = $tempPassword
        ForceChangePasswordNextSignIn = $false
    }
    UsageLocation     = "FR"
}
$tempUser = New-MgUser @userParams
Write-Host "✅ Temp user created: $tempUserUPN" -ForegroundColor Green

Write-Host "`nStep 2: Assigning SharePoint Admin role..." -ForegroundColor Cyan
Start-Sleep -Seconds 10
$spoAdminRole = Get-MgDirectoryRole -Filter "DisplayName eq 'SharePoint Administrator'"
if (-not $spoAdminRole) {
    $roleTemplate = Get-MgDirectoryRoleTemplate -Filter "DisplayName eq 'SharePoint Administrator'"
    $spoAdminRole = New-MgDirectoryRole -RoleTemplateId $roleTemplate.Id
}
$params = @{ "@odata.id" = "https://graph.microsoft.com/v1.0/directoryObjects/$($tempUser.Id)" }
New-MgDirectoryRoleMemberByRef -DirectoryRoleId $spoAdminRole.Id -BodyParameter $params
Write-Host "✅ SharePoint Admin role assigned" -ForegroundColor Green

Write-Host "`nStep 3: Waiting for role propagation (30 seconds)..." -ForegroundColor Cyan
Start-Sleep -Seconds 30

Write-Host "`nStep 4: Installing SharePoint Online module..." -ForegroundColor Cyan
Install-Module -Name Microsoft.Online.SharePoint.PowerShell -Force -AllowClobber
Import-Module Microsoft.Online.SharePoint.PowerShell

Write-Host "`nStep 5: Connecting to SharePoint Online with temp account..." -ForegroundColor Cyan
$securePassword = ConvertTo-SecureString $tempPassword -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential($tempUserUPN, $securePassword)
Connect-SPOService -Url "https://1xyj7c-admin.sharepoint.com" -Credential $cred

Write-Host "`nStep 6: Getting all sites..." -ForegroundColor Cyan
$allSites = Get-SPOSite -Limit All
$deletedCount = 0
$keptCount = 0

foreach ($site in $allSites) {
    if ($site.Url -eq "https://1xyj7c.sharepoint.com") {
        Write-Host "⏭️  Skipping root site" -ForegroundColor Gray
        continue
    }
    
    if ($protectedSites -contains $site.Url) {
        Write-Host "⏭️  Keeping: $($site.Url)" -ForegroundColor Cyan
        $keptCount++
    }
    else {
        Write-Host "Deleting: $($site.Url)" -ForegroundColor Yellow
        Remove-SPOSite -Identity $site.Url -Confirm:$false
        Write-Host "✅ Deleted: $($site.Url)" -ForegroundColor Green
        $deletedCount++
    }
}

Write-Host "`nStep 7: Emptying recycle bin..." -ForegroundColor Cyan
$deletedSites = Get-SPODeletedSite
foreach ($site in $deletedSites) {
    Write-Host "Permanently deleting: $($site.Url)" -ForegroundColor Yellow
    Remove-SPODeletedSite -Identity $site.Url -Confirm:$false
    Write-Host "✅ Permanently deleted: $($site.Url)" -ForegroundColor Green
}

Disconnect-SPOService

Write-Host "`nStep 8: Deleting temporary account..." -ForegroundColor Cyan
Remove-MgUser -UserId $tempUser.Id
Write-Host "✅ Temp account deleted" -ForegroundColor Green

Write-Host "`n✅ All done!" -ForegroundColor Green
Write-Host "  Deleted: $deletedCount" -ForegroundColor Green
Write-Host "  Kept: $keptCount" -ForegroundColor Cyan

exit 0