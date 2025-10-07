#Module 1 - Exercise 2C
#This PowerShell script assign licenses to a user

#Import AzureAD module, in case it was not imported
Import-Module AzureAD

#Connect to Azure AD
if ($AzureADCred -eq $null) {$AzureADCred = Get-Credential}
Connect-AzureAD -Credential $AzureADCred

# Create the objects we'll need to add and remove licenses
$license = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
$licenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses

# Find the SkuID of the license we want to add - in this example we'll use the EMSPREMIUM license
$license.SkuId = (Get-AzureADSubscribedSku | Where-Object -Property SkuPartNumber -Value "EMSPREMIUM" -EQ).SkuID

# Remove ENTERPRISEPREMIUM = Office 365 Enterprise E5 licenses from 10 users
$Licenses.AddLicenses = @();$Licenses.RemoveLicenses =  (Get-AzureADSubscribedSku | Where-Object -Property SkuPartNumber -Value "EMSPREMIUM" -EQ).SkuID;$n=0;$ErrorActionPreference = "SilentlyContinue"; Get-AzureAdUser | ForEach {For ($i=0; $i -le ($_.AssignedLicenses | Measure).Count ; $i++){if(($_.AssignedLicenses[$i].Skuid -eq $license.SkuId) -and ($n -le 9) -and ($_.UserPrincipalName -notlike "admin@*")){$n++; Set-AzureADUserLicense -ObjectId $_.UserPrincipalName -AssignedLicenses $licenses}}};$Licenses.RemoveLicenses = @();$Licenses.AddLicenses = @();$ErrorActionPreference = "Continue";


# Get the user from the directory
$ID = (Get-AzureADUser -SearchString "Sam").objectid 

# Set the Office license as the license we want to add in the $licenses object
$licenses.AddLicenses = $license

# Add EMS license to User SAM
Set-AzureADUserLicense -ObjectId $ID -AssignedLicenses $licenses

# Fetch the user to check if licenses were correctly assigned
Get-AzureADUserLicenseDetail -ObjectId $ID