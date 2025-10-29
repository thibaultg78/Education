<# 
.SYNOPSIS
    Snippet to DISABLE all the SDV Entra ID user accounts.
#>

#Connect-MgGraph -Scopes "User.ReadWrite.All"

# Disable all user accounts at once
$params = @{
    accountEnabled = $false
}
1..25 | ForEach-Object {
    $userId = "student{0:D2}@1xyj7c.onmicrosoft.com" -f $_
    Update-MgUser -UserId $userId -BodyParameter $params
}

# Display the enabled/disabled status of all student accounts
Get-MgUser -All -Property UserPrincipalName, AccountEnabled  `
    | Where-Object { $_.UserPrincipalName -like 'student*' } `
    | Select-Object UserPrincipalName, AccountEnabled