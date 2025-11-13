<#
.SYNOPSIS
    Clean all the Exchange Online objects that have been created by the Students during the M365 Labs for Sup de Vinci
#>

# Install-Module -Name ExchangeOnlineManagement

# Connect to Exchange Online
# Connect-ExchangeOnline

# Removing all Mail Contacts except specific one
$contactAGarder = "thibault.gibard@devoteam.com"

$tousLesContacts = Get-MailContact

$contactsASupprimer = $tousLesContacts | Where-Object { $_.ExternalEmailAddress -ne "SMTP:$contactAGarder" }

Write-Host "Contacts to delete: $($contactsASupprimer.Count)"
$contactsASupprimer | Select-Object DisplayName, ExternalEmailAddress

foreach ($contact in $contactsASupprimer) {
    Remove-MailContact -Identity $contact.Identity -Confirm:$false
    Write-Host "Deleted: $($contact.DisplayName)"
}

Write-Host "Contacts cleanup completed!" -ForegroundColor Green

# Cleaning Standard & Dynamic Distribution Lists
$toutesLesDL = Get-DistributionGroup
$toutesLesDDL = Get-DynamicDistributionGroup

Write-Host "Distribution Lists to delete: $($toutesLesDL.Count)"
$toutesLesDL | Select-Object DisplayName, PrimarySmtpAddress

Write-Host "Dynamic Distribution Lists to delete: $($toutesLesDDL.Count)"
$toutesLesDDL | Select-Object DisplayName, PrimarySmtpAddress

# Cleaning Standard Distribution Lists
foreach ($dl in $toutesLesDL) {
    if ($dl.DisplayName -eq "IT-Department") {
        Write-Host "Ignored (default Microsoft object): $($dl.DisplayName)" -ForegroundColor Yellow
        continue
    }
    
    try {
        Remove-DistributionGroup -Identity $dl.Identity -Confirm:$false
        Write-Host "Deleted DL: $($dl.DisplayName)"
    }
    catch {
        Write-Host "Error deleting $($dl.DisplayName): $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Cleaning Dynamic Distribution Lists
foreach ($ddl in $toutesLesDDL) {
    Remove-DynamicDistributionGroup -Identity $ddl.Identity -Confirm:$false
    Write-Host "Deleted DDL: $($ddl.DisplayName)"
}

Write-Host "Distribution Lists cleanup completed!" -ForegroundColor Green

# Cleaning Public Folders created during the labs
# The folder is at the root, not under IPM_SUBTREE
Get-PublicFolder "\groupe_24" | fl Name, ContentMailbox, MailEnabled

# Disable mail if enabled
Disable-MailPublicFolder -Identity "\groupe_24" -Confirm:$false

# Delete the folder
Remove-PublicFolder -Identity "\groupe_24" -Recurse -Confirm:$false

# Check public folder mailboxes (after complete reconnection)
Get-Mailbox -PublicFolder

# Delete the mailbox if empty and not primary
Remove-Mailbox -PublicFolder -Identity "Groupe_24" -Confirm:$false