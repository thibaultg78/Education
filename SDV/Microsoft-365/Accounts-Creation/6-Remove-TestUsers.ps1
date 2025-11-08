<# 
.SYNOPSIS
    This script deletes the test users created for the SDV Microsoft 365 Labs.
    No warning prompt will be shown before deletion. Accounts will remain in the recycle bin for 30 days.
#>

<# 
.SYNOPSIS
    Update the default password for accounts created for SDV Entra ID user accounts.
#>

Clear-Host

################################################################################################################
# End of Connection to M365 with Managed Identity
################################################################################################################
# Basic configuration
$domain = "1xyj7c.onmicrosoft.com"

# Remove all test user accounts
foreach ($i in 1..25) {
    $userId = "student{0:D2}@$domain" -f $i
    Remove-MgUser -UserId $userId -Confirm:$false
    Write-Host "Deleted: $userId !" -ForegroundColor Green
}

exit 0 # Exit with code 0 to avoid breaking CI/CD pipelines