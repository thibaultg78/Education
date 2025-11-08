<# 
.SYNOPSIS
    Snippet to DISABLE all the SDV Entra ID user accounts.
#>

Clear-Host

# Basic configuration
$domain = "1xyj7c.onmicrosoft.com"

# Disable all user accounts at once
$params = @{
    accountEnabled = $false
}
foreach ($i in 1..25) {
    $userId = "student{0:D2}@$domain" -f $i
    Update-MgUser -UserId $userId -BodyParameter $params
    Write-Host "Disabling: $userId"
}

# Display the enabled/disabled status of all student accounts
Get-MgUser -All -Property UserPrincipalName, AccountEnabled  `
| Where-Object { $_.UserPrincipalName -like 'student*' } `
| Select-Object UserPrincipalName, AccountEnabled

exit 0 # Exit with code 0 to avoid breaking CI/CD pipelines