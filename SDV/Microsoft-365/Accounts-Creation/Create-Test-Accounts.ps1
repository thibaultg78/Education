<# 
.SYNOPSIS
    Test user account creation script for Microsoft Entra ID for SDV Students for M365 Labs.
.DESCRIPTION
    Creates 25 student accounts (student01 to student25) with Service Principal authentication.
#>

Clear-Host

# Verify required environment variables
$requiredVars = @('AZURE_TENANT_ID', 'AZURE_CLIENT_ID', 'AZURE_CLIENT_SECRET', 'SDV_O365_ENTRAID_PASSWORD')
$missingVars = @()

foreach ($var in $requiredVars) {
    if (-not (Get-Item "env:$var" -ErrorAction SilentlyContinue)) {
        $missingVars += $var
    }
}

if ($missingVars.Count -gt 0) {
    Write-Host "ERROR: Missing environment variables:" -ForegroundColor Red
    $missingVars | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
    exit 1
}

# Install/Import modules
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Authentication)) {
    Write-Host "Installing Microsoft.Graph.Authentication module..." -ForegroundColor Yellow
    Install-Module Microsoft.Graph.Authentication -Scope CurrentUser -Force
}

if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Users)) {
    Write-Host "Installing Microsoft.Graph.Users module..." -ForegroundColor Yellow
    Install-Module Microsoft.Graph.Users -Scope CurrentUser -Force
}

Import-Module Microsoft.Graph.Authentication
Import-Module Microsoft.Graph.Users

# Connect with Service Principal
Write-Host "Connecting to Microsoft Graph with Service Principal..." -ForegroundColor Cyan
try {
    $secureSecret = ConvertTo-SecureString $env:AZURE_CLIENT_SECRET -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential($env:AZURE_CLIENT_ID, $secureSecret)
    
    Connect-MgGraph -TenantId $env:AZURE_TENANT_ID -ClientSecretCredential $credential -NoWelcome
    
    # Verify connection
    $context = Get-MgContext
    Write-Host " ✅ Connected successfully!" -ForegroundColor Green
    Write-Host "  Tenant: $($context.TenantId)" -ForegroundColor Gray
    Write-Host "  App: $($context.ClientId)" -ForegroundColor Gray
}
catch {
    Write-Host "CONNECTION ERROR: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

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

# Disconnect
Disconnect-MgGraph | Out-Null