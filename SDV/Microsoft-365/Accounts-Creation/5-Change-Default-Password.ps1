<# 
.SYNOPSIS
    Update the default password for accounts created for SDV Entra ID user accounts.
#>

Clear-Host

# Update password for all student accounts
$passwordParams = @{
    passwordProfile = @{
        password                      = "SDVPasswordTemp123!"
        forceChangePasswordNextSignIn = $false
    }
}
1..25 | ForEach-Object {
    $userId = "student{0:D2}@1xyj7c.onmicrosoft.com" -f $_
    Update-MgUser -UserId $userId -BodyParameter $passwordParams -ErrorAction Stop
    Write-Host "Password updated for $userId" -ForegroundColor Green
}

exit 0 # Exit with code 0 to avoid breaking CI/CD pipelines