<# 
.SYNOPSIS
    Test user account creation script for Microsoft Entra ID for SDV Students for M365 Labs.
.DESCRIPTION
    Creates 25 student accounts (student01 to student25) with Service Principal authentication.
#>

Clear-Host

# Basic configuration
$domain = "1xyj7c.onmicrosoft.com"
$numberOfStudents = 25
$alternateEmail = "formateur_Thibault.gibard@supdevinci-edu.fr"

# Temporary password for all accounts
$passwordProfile = @{
    Password                      = $env:SDV_O365_ENTRAID_PASSWORD
    ForceChangePasswordNextSignIn = $false
}

Write-Host "`nCreating $numberOfStudents student accounts..." -ForegroundColor Cyan

# User creation
$successCount = 0
$errorCount = 0

for ($i = 1; $i -le $numberOfStudents; $i++) {
    $studentNumber = "student{0:D2}" -f $i
    $upn = "$studentNumber@$domain"
    
    try {
        # User parameter preparation
        $userParams = @{
            AccountEnabled    = $false
            DisplayName       = $studentNumber
            MailNickname      = $studentNumber
            UserPrincipalName = $upn
            PasswordProfile   = $passwordProfile
            GivenName         = $studentNumber
            Surname           = $studentNumber
            JobTitle          = "IT Student"
            Department        = "SDV Paris"
            OfficeLocation    = "Paris"
            BusinessPhones    = @("123-555-1211")
            MobilePhone       = "123-555-6641"
            FaxNumber         = "123-555-9821"
            OtherMails        = @($alternateEmail)
            StreetAddress     = "1 Microsoft way"
            City              = "Redmond"
            State             = "Wa"
            PostalCode        = "98052"
            Country           = "United States"
            UsageLocation     = "FR"
        }

        # User creation
        New-MgUser @userParams | Out-Null
        
        Write-Host "✅ $upn created" -ForegroundColor Green
        $successCount++
    }
    catch {
        Write-Host "❌ $upn : $($_.Exception.Message)" -ForegroundColor Red
        $errorCount++
    }
}