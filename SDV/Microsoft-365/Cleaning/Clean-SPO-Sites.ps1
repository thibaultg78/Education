<#
.SYNOPSIS
    Clean all the SPO Websites that has been done by the Students during the M365 Labs for Sup de Vinci
#>

#Install-Module -Name Microsoft.Online.SharePoint.PowerShell # Module Installation

Install-Module -Name PnP.PowerShell

Import-Module Microsoft.Online.SharePoint.PowerShell

Connect-SPOService -Url https://1xyj7c-admin.sharepoint.com

$sitesAGarder = @("All Company", "Applications", "Communication site", "Contoso Team", "Digital Initiative Public Relations", "Give @ Contoso", "Live @ Contoso", "MSFT", "Retail", "Sales and Marketing", "Sample Team Site", "U.S. Sales", "Work @ Contoso")

$tousLesSites = Get-SPOSite

$sitesASupprimer = $tousLesSites | Where-Object { $_.Title -notin $sitesAGarder }

Write-Host "Sites à supprimer: $($sitesASupprimer.Count)"
$sitesASupprimer | Select-Object Title, Url

foreach ($site in $sitesASupprimer) {
    Remove-SPOSite -Identity $site.Url -Confirm:$false
    Write-Host "Supprimé: $($site.Title)"
}

Write-Host "Terminé"