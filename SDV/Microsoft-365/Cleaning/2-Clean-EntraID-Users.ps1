<#
.SYNOPSIS
    Clean all the configuration that has been done by the Students during the M365 Labs for Sup de Vinci
#>

# Connect to Microsoft Graph (if not already connected)
#Connect-MgGraph -Scopes "User.ReadWrite.All"

# List of UserPrincipalNames to KEEP (DO NOT DELETE)
$comptesAConserver = @(
    "AdeleV@1xyj7c.onmicrosoft.com",
    "AlexW@1xyj7c.onmicrosoft.com",
    "DiegoS@1xyj7c.onmicrosoft.com",
    "GradyA@1xyj7c.onmicrosoft.com",
    "HenriettaM@1xyj7c.onmicrosoft.com",
    "IsaiahL@1xyj7c.onmicrosoft.com",
    "JohannaL@1xyj7c.onmicrosoft.com",
    "JoniS@1xyj7c.onmicrosoft.com",
    "LeeG@1xyj7c.onmicrosoft.com",
    "LidiaH@1xyj7c.onmicrosoft.com",
    "LynneR@1xyj7c.onmicrosoft.com",
    "MeganB@1xyj7c.onmicrosoft.com",
    "MiriamG@1xyj7c.onmicrosoft.com",
    "NestorW@1xyj7c.onmicrosoft.com",
    "PattiF@1xyj7c.onmicrosoft.com",
    "PradeepG@1xyj7c.onmicrosoft.com",
    "thibault.gibard_devoteam.com#EXT#@1xyj7c.onmicrosoft.com",
    "thibault@1xyj7c.onmicrosoft.com"
)

# Get ALL users
Write-Host "Retrieving all users..." -ForegroundColor Yellow
$tousLesUtilisateurs = Get-MgUser -All

# Filter users to delete
$utilisateursASupprimer = $tousLesUtilisateurs | Where-Object { 
    $_.UserPrincipalName -notin $comptesAConserver 
}

# Display the number of users that will be deleted
Write-Host "`n=== WARNING ===" -ForegroundColor Red
Write-Host "Total number of users: $($tousLesUtilisateurs.Count)" -ForegroundColor Cyan
Write-Host "Users to KEEP: $($comptesAConserver.Count)" -ForegroundColor Green
Write-Host "Users to DELETE: $($utilisateursASupprimer.Count)" -ForegroundColor Red

# Display the list of users that will be deleted
Write-Host "`nUsers that will be DELETED:" -ForegroundColor Red
$utilisateursASupprimer | Select-Object DisplayName, UserPrincipalName | Format-Table

# Ask for confirmation
$confirmation = Read-Host "`nAre you ABSOLUTELY SURE you want to delete these $($utilisateursASupprimer.Count) accounts? (Type 'YES' in uppercase to confirm)"

if ($confirmation -eq "YES") {
    Write-Host "`nDeletion in progress..." -ForegroundColor Yellow
    
    foreach ($user in $utilisateursASupprimer) {
        try {
            Remove-MgUser -UserId $user.Id -Confirm:$false
            Write-Host "✅ Deleted: $($user.DisplayName) ($($user.UserPrincipalName))" -ForegroundColor Green
        }
        catch {
            Write-Host "❌ Error deleting $($user.DisplayName): $_" -ForegroundColor Red
        }
    }
    
    Write-Host "`nDeletion completed!" -ForegroundColor Green
}
else {
    Write-Host "`nOperation cancelled. No accounts were deleted." -ForegroundColor Yellow
}

exit 0 # Exit with code 0 to avoid breaking CI/CD pipelines