<#
.SYNOPSIS
    Clean all Entra ID groups except protected ones
#>

Clear-Host

# Manual script only to delete all CA policies
# Must connect with a Global Admin account and not a Managed Identity
Connect-MgGraph -Scopes "Policy.ReadWrite.ConditionalAccess"

$policies = Get-MgIdentityConditionalAccessPolicy

foreach ($policy in $policies) {
    Write-Host "Deleting: $($policy.DisplayName)" -ForegroundColor Yellow
    Remove-MgIdentityConditionalAccessPolicy -ConditionalAccessPolicyId $policy.Id -Confirm:$false
    Write-Host "✅ Deleted: $($policy.DisplayName)" -ForegroundColor Green
}

Write-Host "`n✅ All CA policies deleted!" -ForegroundColor Green