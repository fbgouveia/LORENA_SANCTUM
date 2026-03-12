$processes = Get-Process python -ErrorAction SilentlyContinue
foreach ($p in $processes) {
    try {
        $cmdLine = (Get-CimInstance Win32_Process -Filter "ProcessId = $($p.Id)").CommandLine
        if ($cmdLine -like "*hologram_launcher.py*") {
            Write-Output "Terminating Lorena process $($p.Id)..."
            Stop-Process -Id $p.Id -Force
            exit 0
        }
    } catch {
        Write-Warning "Could not access process $($p.Id)"
    }
}

$titleProcess = Get-Process | Where-Object { $_.MainWindowTitle -like '*Hologram*' }
if ($titleProcess) {
    Write-Output "Terminating Hologram by window title..."
    $titleProcess | Stop-Process -Force
    exit 0
}

Write-Warning "Hologram process not found."
exit 1
