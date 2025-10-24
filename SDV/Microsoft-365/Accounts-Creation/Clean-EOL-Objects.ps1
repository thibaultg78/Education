<#
.SYNOPSIS
    Clean all the Exchange Online objects that have been done by the Students during the M365 Labs for Sup de Vinci
#>

# Install-Module -Name ExchangeOnlineManagement

# Connexion à Exchange Online
# Connect-ExchangeOnline

# Removing all Mail Contacts except specific one
$contactAGarder = "thibault.gibard@devoteam.com"

$tousLesContacts = Get-MailContact

$contactsASupprimer = $tousLesContacts | Where-Object { $_.ExternalEmailAddress -ne "SMTP:$contactAGarder" }

Write-Host "Contacts à supprimer: $($contactsASupprimer.Count)"
$contactsASupprimer | Select-Object DisplayName, ExternalEmailAddress

foreach ($contact in $contactsASupprimer) {
    Remove-MailContact -Identity $contact.Identity -Confirm:$false
    Write-Host "Supprimé: $($contact.DisplayName)"
}

Write-Host "Contacts cleanup completed!" -ForegroundColor Green

# Cleaning Standard & Dynamic Distribution Lists

$toutesLesDL = Get-DistributionGroup
$toutesLesDDL = Get-DynamicDistributionGroup

Write-Host "Distribution Lists à supprimer: $($toutesLesDL.Count)"
$toutesLesDL | Select-Object DisplayName, PrimarySmtpAddress

Write-Host "Dynamic Distribution Lists à supprimer: $($toutesLesDDL.Count)"
$toutesLesDDL | Select-Object DisplayName, PrimarySmtpAddress

foreach ($dl in $toutesLesDL) {
    Remove-DistributionGroup -Identity $dl.Identity -Confirm:$false
    Write-Host "Supprimé DL: $($dl.DisplayName)"
}

foreach ($ddl in $toutesLesDDL) {
    Remove-DynamicDistributionGroup -Identity $ddl.Identity -Confirm:$false
    Write-Host "Supprimé DDL: $($ddl.DisplayName)"
}

Write-Host "Distribution Lists cleanup completed!" -ForegroundColor Green

