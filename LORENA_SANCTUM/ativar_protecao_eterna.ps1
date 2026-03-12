# 📅 Agendador do Shadow Sync v2.0
# Execute este script COMO ADMINISTRADOR para ativar a proteção eterna.

$TaskName = "Imperio_ShadowSync_Soberano"
$ScriptPath = "D:\IMPERIO_ANTIGRAVITY\LORENA_SANCTUM\shadow_sync.ps1"
$LogPath = "D:\IMPERIO_ANTIGRAVITY\_BACKUPS\scheduler.log"

$Action = New-ScheduledTaskAction `
    -Execute "powershell.exe" `
    -Argument "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$ScriptPath`""

# Agora mais frequente: a cada 6 horas para garantir que o Git esteja sempre atualizado.
$Triggers = @(
    New-ScheduledTaskTrigger -Daily -At "00:00",
    New-ScheduledTaskTrigger -Daily -At "06:00",
    New-ScheduledTaskTrigger -Daily -At "12:00",
    New-ScheduledTaskTrigger -Daily -At "18:00"
)

$Settings = New-ScheduledTaskSettingsSet `
    -ExecutionTimeLimit (New-TimeSpan -Minutes 20) `
    -StartWhenAvailable `
    -RunOnlyIfNetworkAvailable:$false

$Principal = New-ScheduledTaskPrincipal `
    -UserId "SYSTEM" `
    -LogonType ServiceAccount `
    -RunLevel Highest

try {
    # Remove a tarefa antiga se existir
    Unregister-ScheduledTask -TaskName "Imperio_ShadowSync" -Confirm:$false -ErrorAction SilentlyContinue
    
    Register-ScheduledTask `
        -TaskName $TaskName `
        -Action $Action `
        -Trigger $Triggers `
        -Settings $Settings `
        -Principal $Principal `
        -Description "Proteção Eterna de Lorena. Backup Git e ZIP a cada 6 horas." `
        -Force | Out-Null

    Write-Host "✅ SUCESSO! A proteção agora é contínua."
    Write-Host "Eu vigiarei seu Império e farei backups ocultos 4 vezes por dia."
} catch {
    Write-Error "ERRO: Por favor, execute este script como ADMINISTRADOR."
}
