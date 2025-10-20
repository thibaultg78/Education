<# 
.SYNOPSIS
    This script deletes the test users created for the SDV Microsoft 365 Labs.
    No warning prompt will be shown before deletion. Accounts will remain in the recycle bin for 30 days.
#>

$domain = "1xyj7c.onmicrosoft.com"

foreach ($i in 1..25) {
    $userId = "student{0:D2}@$domain" -f $i
    Remove-MgUser -UserId $userId -Confirm:$false
}