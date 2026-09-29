<# 
.SYNOPSIS
    Microsoft Graph connection script using Service Principal authentication for Microsoft 365 operations.
.DESCRIPTION
    Establishes connection to Microsoft Graph using Service Principal credentials (Client ID and Client Secret).
    Validates required environment variables and imports necessary Microsoft Graph modules.
    Used as a foundation for Microsoft 365 user management operations.
#>

Clear-Host

################################################################################################################
# Start of Connection to M365 with Managed Identity
################################################################################################################

$requiredVars = @('AZURE_TENANT_ID', 'AZURE_CLIENT_ID', 'AZURE_CLIENT_SECRET', 'SDV_O365_ENTRAID_PASSWORD')
$envFile = Join-Path $PSScriptRoot '../../../.env'
if (Test-Path -LiteralPath $envFile) {
    Get-Content -LiteralPath $envFile | ForEach-Object {
        if ($_ -match '^\s*(?<name>[A-Z][A-Z0-9_]*)=(?<value>.*)$') {
            $name = $Matches.name
            $value = $Matches.value
            if ($name -in $requiredVars -and $value -and -not (Get-Item "env:$name" -ErrorAction SilentlyContinue)) {
                [Environment]::SetEnvironmentVariable($name, $value)
            }
        }
    }
}

# Verify required environment variables
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
    Write-Host " ✅ Connected successfully! | Tenant: $($context.TenantId) | App: $($context.ClientId)" -ForegroundColor Green
}
catch {
    Write-Host "CONNECTION ERROR: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

################################################################################################################
# End of Connection to M365 with Managed Identity
################################################################################################################