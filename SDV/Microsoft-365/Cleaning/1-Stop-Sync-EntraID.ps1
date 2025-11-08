<#
.SYNOPSIS
    Stopping Azure AD Sync (DirSync) for the Sup de Vinci M365 Labs Tenant
#>

# Get organization ID and disable sync
$orgId = (Get-MgOrganization).Id
Set-MgOrganization -OrganizationId $orgId -OnPremisesSyncEnabled:$false

Write-Host "✅ Entra ID Connect sync disabled!" -ForegroundColor Green

# Verify
Get-MgOrganization | Select-Object OnPremisesSyncEnabled

exit 0 # Exit with code 0 to avoid breaking CI/CD pipelines

<#
# Old version
# Install v1.0 and beta Microsoft Graph PowerShell modules 
Install-Module Microsoft.Graph -Force
Install-Module Microsoft.Graph.Beta -AllowClobber -Force 

# Connect With Hybrid Identity Administrator Account
Connect-MgGraph -scopes "Organization.ReadWrite.All,Directory.ReadWrite.All"

# Verify the current status of the DirSync Type
Get-MgOrganization | Select OnPremisesSyncEnabled 

# Store the Tenant ID in a variable named organizationId
$organizationId = (Get-MgOrganization).Id

# Store the False value for the DirSyncEnabled Attribute
$params = @{
  onPremisesSyncEnabled = $false
}

# Perform the update
Update-MgOrganization -OrganizationId $organizationId -BodyParameter $params 

# Check that the command worked
Get-MgOrganization | Select OnPremisesSyncEnabled
#>