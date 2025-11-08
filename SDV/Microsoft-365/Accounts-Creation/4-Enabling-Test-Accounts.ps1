<# 
.SYNOPSIS
    Snippet to ENABLE all the SDV Entra ID user accounts.
#>

Clear-Host

# Basic configuration
$domain = "1xyj7c.onmicrosoft.com"
    
# Enable all user accounts at once
$params = @{
    accountEnabled = $true
}
foreach ($i in 1..25) {
    $userId = "student{0:D2}@$domain" -f $i
    Update-MgUser -UserId $userId -BodyParameter $params
    Write-Host "Enabling: $userId"
}

# Display the enabled/disabled status of all student accounts
Get-MgUser -All -Property UserPrincipalName, AccountEnabled  `
| Where-Object { $_.UserPrincipalName -like 'student*' } `
| Select-Object UserPrincipalName, AccountEnabled
