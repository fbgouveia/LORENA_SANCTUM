$processes = Get-Process
foreach ($p in $processes) {
    if ($p.MainWindowTitle -like "*CORE OPS*" -or $p.MainWindowTitle -like "*ANTIGRAVITY*") {
        Write-Output "Found process: $($p.Name) (ID: $($p.Id)) with Title: $($p.MainWindowTitle)"
        Write-Output "Terminating $($p.Id)..."
        Stop-Process -Id $p.Id -Force
    }
}
