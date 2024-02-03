$allservices = Get-Service
foreach ($item in $allservices)
{
    if ($item.Status -eq "Running")
    {
        Write-host $item.Name $item.DisplayName $item.Status -ForegroundColor Green
    }

    else
    {
        Write-host $item.Name $item.DisplayName $item.Status -ForegroundColor Red
    }
}