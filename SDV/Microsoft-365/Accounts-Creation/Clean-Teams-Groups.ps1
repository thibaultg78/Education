<#
.SYNOPSIS
    Clean all the configuration that has been done by the Students during the M365 Labs for Sup de Vinci
#>

# Install-Module -Name MicrosoftTeams # Module Installation
# Import-Module MicrosoftTeams # Module Import

#Connect-MicrosoftTeams

$teamsAGarder = @("Digital Initiative Public Relations", "Sales and Marketing", "Retail", "U.S. Sales", "MSFT")

$tousLesTeams = Get-Team

$teamsASupprimer = $tousLesTeams | Where-Object { $_.DisplayName -notin $teamsAGarder }

Write-Host "Teams à supprimer: $($teamsASupprimer.Count)"
$teamsASupprimer | Select-Object DisplayName

foreach ($team in $teamsASupprimer) {
    Remove-Team -GroupId $team.GroupId
    Write-Host "Supprimé: $($team.DisplayName)"
}

Write-Host "Done" -ForegroundColor Green