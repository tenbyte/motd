param(
    [string]$InstallPath = (Join-Path $HOME ".tenbyte_motd.ps1")
)

$ErrorActionPreference = "Stop"

$documents = [Environment]::GetFolderPath("MyDocuments")
$profilePaths = @(
    (Join-Path $documents "PowerShell\profile.ps1"),
    (Join-Path $documents "WindowsPowerShell\profile.ps1")
) | Select-Object -Unique

function Remove-TenbyteBlock {
    param([string]$Content)

    $pattern = "(?ms)^# TENBYTE MOTD BEGIN.*?# TENBYTE MOTD END\r?\n?"
    return [regex]::Replace($Content, $pattern, "").TrimEnd()
}

Write-Host "[TENBYTE] Restoring PowerShell profiles..."

foreach ($profilePath in $profilePaths) {
    if (-not (Test-Path -LiteralPath $profilePath)) {
        continue
    }

    $content = Get-Content -LiteralPath $profilePath -Raw
    $nextContent = Remove-TenbyteBlock -Content $content
    Set-Content -LiteralPath $profilePath -Value $nextContent -Encoding UTF8
    Write-Host "[TENBYTE] Cleaned profile: $profilePath"
}

if (Test-Path -LiteralPath $InstallPath) {
    Remove-Item -LiteralPath $InstallPath -Force
    Write-Host "[TENBYTE] Removed $InstallPath"
}

Write-Host "[TENBYTE] MOTD removed."
