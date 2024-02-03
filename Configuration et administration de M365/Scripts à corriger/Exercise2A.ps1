#Module 1 - Exercise 2A
#This PowerShell script creates a user account in Azure AD

#Import AzureAD module, in case it was not imported
Import-Module AzureAD

#Get AzureAD Credential
$AzureADCred = Get-Credential

#Connecting to AzureAD
Connect-AzureAD -Credential $AzureADCred

#Get Verified Domain containing .onelearndns.com or provide user option to type a domain which will be used in the user creation for the UserPrincipalName
$Domain = (Get-AzureADDomain | Where-Object {$_.Name -like "*.onelearndns.com"}).Name
if (($TypedDomain = Read-Host "Press enter to accept default value => $domain" ) -eq '') {$domain} else {$TypedDomain}

#Define Password
$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password = "<Password>" #Replace <Password> with your own password

#Avoid request to change password on first login
$PasswordProfile.ForceChangePasswordNextLogin = $false

#Create New Uer
New-AzureADUser -AccountEnabled $True -DisplayName "Sam" -PasswordProfile $PasswordProfile -MailNickName "Sam" -UserPrincipalName "sam@$Domain" -UsageLocation US