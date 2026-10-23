<# 
.SYNOPSIS
    Update the default password for accounts created for SDV Entra ID user accounts.
#>

Clear-Host

# Update password for all student accounts
$passwordParams = @{
    passwordProfile = @{
        password                      = "SDVPwdTemp123456?"
        forceChangePasswordNextSignIn = $false
    }
}
1..30 | ForEach-Object {
    $userId = "student{0:D2}@1xyj7c.onmicrosoft.com" -f $_
    try {
        Update-MgUser -UserId $userId -BodyParameter $passwordParams -ErrorAction Stop
        Write-Host "Password updated for $userId" -ForegroundColor Green
    }
    catch {
        Write-Warning "Could not update $userId. Continuing with the next account. $($_.Exception.Message)"
    }
}

exit 0 # Exit with code 0 to avoid breaking CI/CD pipelines

