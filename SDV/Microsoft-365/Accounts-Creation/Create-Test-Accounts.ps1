<#
.SYNOPSIS
    Test user account creation script for Microsoft Entra ID for SDV Students for M365 Labs.

.DESCRIPTION
    Accounts will be created in a disabled state by default.

.EXAMPLE
    .\Create-Test-Accounts.ps1
    Runs the script with default parameters

.NOTES
    File Name     : Create-Test-Accounts.ps1
    Author        : Thibault Gibard
    Date          : 2025-10-20
    Version       : 1.0
    
    Prerequisites:
    - Microsoft.Graph.Users module installed
    - Appropriate permissions in Entra ID
    - Authenticated connection to Microsoft Graph
#>

# Installation du module si nécessaire (décommenter si besoin)
# Install-Module Microsoft.Graph -Scope CurrentUser

# Connexion à Microsoft Graph avec les permissions nécessaires
#Connect-MgGraph -Scopes "User.ReadWrite.All"

Clear-Host

# Chemin vers le fichier CSV
$csvPath = "/home/codespace/Education/SDV/Microsoft-365/Accounts-Creation/Import_User_Sample.csv"

# Import du fichier CSV
$users = Import-Csv -Path $csvPath

# Mot de passe temporaire pour tous les comptes
$passwordProfile = @{
    Password                      = $env:SDV_O365_ENTRAID_PASSWORD
    ForceChangePasswordNextSignIn = $false
}

# Création des utilisateurs
foreach ($user in $users) {
    try {
        # Préparation des paramètres de l'utilisateur
        $userParams = @{
            AccountEnabled    = $false  # Compte désactivé
            DisplayName       = $user.'Display name'
            MailNickname      = $user.Username.Split('@')[0]
            UserPrincipalName = $user.Username
            PasswordProfile   = $passwordProfile
            GivenName         = $user.'First name'
            Surname           = $user.'Last name'
            JobTitle          = $user.'Job title'
            Department        = $user.Department
            OfficeLocation    = $user.'Office number'
            BusinessPhones    = @($user.'Office phone')
            MobilePhone       = $user.'Mobile phone'
            FaxNumber         = $user.Fax
            StreetAddress     = $user.Address
            City              = $user.City
            State             = $user.'State or province'
            PostalCode        = $user.'ZIP or postal code'
            Country           = $user.'Country or region'
            UsageLocation     = "FR"  # Définir selon votre pays
        }

        # Ajout de l'email alternatif si présent
        if ($user.'Alternate email address') {
            $userParams.OtherMails = @($user.'Alternate email address')
        }

        # Création de l'utilisateur
        New-MgUser @userParams
        
        Write-Host "Utilisateur créé avec succès: $($user.Username)" -ForegroundColor Green
    }
    catch {
        Write-Host "Erreur lors de la création de $($user.Username): $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Déconnexion
#Disconnect-MgGraph

Write-Host "Script terminé!" -ForegroundColor Cyan
