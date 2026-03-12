# 📅 Agendador do Shadow Sync - Registro no Agendador de Tarefas do Windows
# Execute este script UMA VEZ como Administrador para registrar o backup automático.

$TaskName = "Imperio_ShadowSync"
$ScriptPath = "D:\IMPERIO_ANTIGRAVITY\WORKSPACE_SOBERANO\shadow_sync.ps1"
$LogPath = "D:\IMPERIO_ANTIGRAVITY\_BACKUPS\scheduler.log"

$Action = New-ScheduledTaskAction `
    -Execute "powershell.exe" `
    -Argument "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$ScriptPath`""

# Roda a cada 12 horas: meia-noite e meio-dia
$Triggers = @(
    New-ScheduledTaskTrigger -Daily -At "00:00",
    New-ScheduledTaskTrigger -Daily -At "12:00"
)

$Settings = New-ScheduledTaskSettingsSet `
    -ExecutionTimeLimit (New-TimeSpan -Minutes 30) `
    -StartWhenAvailable `
    -RunOnlyIfNetworkAvailable:$false

$Principal = New-ScheduledTaskPrincipal `
    -UserId "SYSTEM" `
    -LogonType ServiceAccount `
    -RunLevel Highest

try {
    Register-ScheduledTask `
        -TaskName $TaskName `
        -Action $Action `
        -Trigger $Triggers `
        -Settings $Settings `
        -Principal $Principal `
        -Description "Shadow Sync do Imperio Antigravity. Backup automatico a cada 12 horas." `
        -Force | Out-Null

    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $LogPath -Value "[$ts] Task '$TaskName' registrada com sucesso." -Encoding UTF8
    Write-Host "✅ Shadow Sync agendado! Rodará automaticamente às 00:00 e 12:00 todos os dias."
} catch {
    Write-Error "ERRO ao registrar tarefa: $($_.Exception.Message)"
}
