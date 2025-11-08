
$rg = "RG-Thibault-Gibard"
az vm list -g $rg --query "[].name" -o tsv | ForEach-Object { az vm start -g $rg -n $_ }


$rg = "RG-Thibault-Gibard"
az vm list -g $rg --query "[].name" -o tsv | ForEach-Object {
    Start-Job { param($name, $rgName) az vm deallocate -g $rgName -n $name } -ArgumentList $_, $rg
}

Get-Job | Wait-Job



