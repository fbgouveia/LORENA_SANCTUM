# 💾 Shadow Sync v1.0 - Backup Soberano do Império Antigravity
# Cria backups compactados de todo o ecosistema no Drive D.
# Agende este script via Agendador de Tarefas do Windows para rodar a cada 12 horas.

$SOURCE = "D:\IMPERIO_ANTIGRAVITY"
$BACKUP_ROOT = "D:\IMPERIO_ANTIGRAVITY\_BACKUPS"
$TIMESTAMP = Get-Date -Format "yyyy-MM-dd_HH-mm"
$BACKUP_NAME = "Imperio_Backup_$TIMESTAMP.zip"
$BACKUP_PATH = Join-Path $BACKUP_ROOT $BACKUP_NAME
$LOG_FILE = "D:\IMPERIO_ANTIGRAVITY\ARQUIVOS_EXECUCAO\operations.log"

function Log($msg) {
    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "SHADOW_SYNC [$ts] > $msg"
    Add-Content -Path $LOG_FILE -Value $line -Encoding UTF8
    Write-Host $line
}

# Garante que a pasta de backup existe
if (-not (Test-Path $BACKUP_ROOT)) {
    New-Item -ItemType Directory -Path $BACKUP_ROOT | Out-Null
    Log "Criada pasta de backups: $BACKUP_ROOT"
}

Log "Iniciando Shadow Sync... destino: $BACKUP_PATH"

try {
    # Compacta tudo exceto a própria pasta de backups para evitar recursião
    $exclude = [System.IO.Path]::GetFullPath($BACKUP_ROOT)
    
    $filesToZip = Get-ChildItem -Path $SOURCE -Recurse -Force |
        Where-Object { -not $_.FullName.StartsWith($exclude) } |
        Select-Object -ExpandProperty FullName

    Compress-Archive -Path $filesToZip -DestinationPath $BACKUP_PATH -CompressionLevel Optimal
    $sizeMB = [math]::Round((Get-Item $BACKUP_PATH).Length / 1MB, 2)
    Log "Backup concluído com SUCESSO! Tamanho: ${sizeMB}MB -> $BACKUP_NAME"
} catch {
    Log "ERRO no backup: $($_.Exception.Message)"
    exit 1
}

# Limpeza: mantém apenas os últimos 7 backups
$allBackups = Get-ChildItem -Path $BACKUP_ROOT -Filter "*.zip" | Sort-Object LastWriteTime -Descending
if ($allBackups.Count -gt 7) {
    $oldBackups = $allBackups | Select-Object -Skip 7
    foreach ($old in $oldBackups) {
        Remove-Item $old.FullName -Force
        Log "Backup antigo removido: $($old.Name)"
    }
}

Log "Shadow Sync concluído. O Império está protegido."
