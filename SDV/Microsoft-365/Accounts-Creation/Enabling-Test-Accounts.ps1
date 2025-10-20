<# 
.SYNOPSIS
    Snippet to ENABLE all the SDV Entra ID user accounts.
#>

#Connect-MgGraph -Scopes "User.ReadWrite.All"

$params = @{
    accountEnabled = $true
}
Update-MgUser -UserId "user01@1xyj7c.onmicrosoft.com" -BodyParameter $params
Update-MgUser -UserId "user02@1xyj7c.onmicrosoft.com" -BodyParameter $params
Update-MgUser -UserId "user03@1xyj7c.onmicrosoft.com" -BodyParameter $params
Update-MgUser -UserId "user04@1xyj7c.onmicrosoft.com" -BodyParameter $params
Update-MgUser -UserId "user05@1xyj7c.onmicrosoft.com" -BodyParameter $params
Update-MgUser -UserId "user06@1xyj7c.onmicrosoft.com" -BodyParameter $params
Update-MgUser -UserId "user07@1xyj7c.onmicrosoft.com" -BodyParameter $params
Update-MgUser -UserId "user08@1xyj7c.onmicrosoft.com" -BodyParameter $params
Update-MgUser -UserId "user09@1xyj7c.onmicrosoft.com" -BodyParameter $params
Update-MgUser -UserId "user10@1xyj7c.onmicrosoft.com" -BodyParameter $params
Update-MgUser -UserId "user11@1xyj7c.onmicrosoft.com" -BodyParameter $params
Update-MgUser -UserId "user12@1xyj7c.onmicrosoft.com" -BodyParameter $params
Update-MgUser -UserId "user13@1xyj7c.onmicrosoft.com" -BodyParameter $params
Update-MgUser -UserId "user14@1xyj7c.onmicrosoft.com" -BodyParameter $params
Update-MgUser -UserId "user15@1xyj7c.onmicrosoft.com" -BodyParameter $params
Update-MgUser -UserId "user16@1xyj7c.onmicrosoft.com" -BodyParameter $params
Update-MgUser -UserId "user17@1xyj7c.onmicrosoft.com" -BodyParameter $params
Update-MgUser -UserId "user18@1xyj7c.onmicrosoft.com" -BodyParameter $params
Update-MgUser -UserId "user19@1xyj7c.onmicrosoft.com" -BodyParameter $params
Update-MgUser -UserId "user20@1xyj7c.onmicrosoft.com" -BodyParameter $params
Update-MgUser -UserId "user21@1xyj7c.onmicrosoft.com" -BodyParameter $params
Update-MgUser -UserId "user22@1xyj7c.onmicrosoft.com" -BodyParameter $params
Update-MgUser -UserId "user23@1xyj7c.onmicrosoft.com" -BodyParameter $params
Update-MgUser -UserId "user24@1xyj7c.onmicrosoft.com" -BodyParameter $params
Update-MgUser -UserId "user25@1xyj7c.onmicrosoft.com" -BodyParameter $params


# Désactiver tous les comptes utilisateurs en une fois
Get-MgUser -Filter "userPrincipalName startswith 'student'" | ForEach-Object {
    Update-MgUser -UserId $_.Id -AccountEnabled $false
}
