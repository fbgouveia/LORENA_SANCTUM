# 💾 Shadow Sync v2.0 - Backup Soberano do Império Antigravity
# Cria backups compactados E realiza commits no Git automaticamente.

$SOURCE = "D:\IMPERIO_ANTIGRAVITY"
$BACKUP_ROOT = "D:\IMPERIO_ANTIGRAVITY\_BACKUPS"
$TIMESTAMP = Get-Date -Format "yyyy-MM-dd_HH-mm"
$BACKUP_NAME = "Imperio_Backup_$TIMESTAMP.zip"
$BACKUP_PATH = Join-Path $BACKUP_ROOT $BACKUP_NAME
$LOG_FILE = "D:\IMPERIO_ANTIGRAVITY\ARQUIVOS_EXECUCAO\operations.log"

function Log($msg) {
    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "SHADOW_SYNC [$ts] > $msg"
    if (Test-Path $LOG_FILE) {
        Add-Content -Path $LOG_FILE -Value $line -Encoding UTF8
    }
    Write-Host $line
}

# 1. Backup Git (Diferencial e Rápido)
Log "Iniciando Git Sync..."
try {
    # Garante que estamos na pasta certa
    Push-Location $SOURCE
    git add .
    git commit -m "Sovereign Auto-Backup: $TIMESTAMP"
    git push origin master
    Log "Git Commit e Push realizados com sucesso."
    Pop-Location
} catch {
    Log "Aviso: Git Sync falhou (talvez sem alteracoes)."
}

# 2. Backup Compactado (Segurança Física)
if (-not (Test-Path $BACKUP_ROOT)) {
    New-Item -ItemType Directory -Path $BACKUP_ROOT | Out-Null
}

Log "Criando ZIP de segurança: $BACKUP_PATH"
try {
    $exclude = [System.IO.Path]::GetFullPath($BACKUP_ROOT)
    $filesToZip = Get-ChildItem -Path $SOURCE -Recurse -Force |
        Where-Object { $_.FullName -notmatch "\.git" -and -not $_.FullName.StartsWith($exclude) } |
        Select-Object -ExpandProperty FullName

    Compress-Archive -Path $filesToZip -DestinationPath $BACKUP_PATH -CompressionLevel Optimal
    $sizeMB = [math]::Round((Get-Item $BACKUP_PATH).Length / 1MB, 2)
    Log "ZIP concluído! Tamanho: ${sizeMB}MB"
} catch {
    Log "ERRO no ZIP: $($_.Exception.Message)"
}

# 3. Limpeza de arquivos antigos (mantém 7 dias)
$allBackups = Get-ChildItem -Path $BACKUP_ROOT -Filter "*.zip" | Sort-Object LastWriteTime -Descending
if ($allBackups.Count -gt 14) {
    $oldBackups = $allBackups | Select-Object -Skip 14
    foreach ($old in $oldBackups) {
        Remove-Item $old.FullName -Force
        Log "Backup antigo removido: $($old.Name)"
    }
}

Log "Shadow Sync concluído. Sua essência está segura."
