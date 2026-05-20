param(
    [string]$InstallPath = (Join-Path $HOME ".tenbyte_motd.ps1"),
    [switch]$IncludeWindowsPowerShell
)

$ErrorActionPreference = "Stop"

$motdUrl = "https://raw.githubusercontent.com/tenbyte/motd/refs/heads/main/windows/tenbyte-motd.ps1"
$localMotd = Join-Path $PSScriptRoot "tenbyte-motd.ps1"
$documents = [Environment]::GetFolderPath("MyDocuments")
$profilePaths = @(@(
    (Join-Path $documents "PowerShell\profile.ps1")
) | Select-Object -Unique)

if ($IncludeWindowsPowerShell) {
    $profilePaths += Join-Path $documents "WindowsPowerShell\profile.ps1"
}

$beginMarker = "# TENBYTE MOTD BEGIN"
$endMarker = "# TENBYTE MOTD END"
$profileBlock = @"
$beginMarker
. "$InstallPath"
$endMarker
"@

function Remove-TenbyteBlock {
    param([string]$Content)

    $pattern = "(?ms)^# TENBYTE MOTD BEGIN.*?# TENBYTE MOTD END\r?\n?"
    return [regex]::Replace($Content, $pattern, "").TrimEnd()
}

Write-Host "[TENBYTE] Installing Windows MOTD..."

if (Test-Path -LiteralPath $localMotd) {
    Copy-Item -LiteralPath $localMotd -Destination $InstallPath -Force
} else {
    Invoke-WebRequest -Uri $motdUrl -OutFile $InstallPath
}

foreach ($profilePath in $profilePaths) {
    $profileDirectory = Split-Path -Parent $profilePath
    New-Item -ItemType Directory -Path $profileDirectory -Force | Out-Null

    $content = if (Test-Path -LiteralPath $profilePath) {
        Get-Content -LiteralPath $profilePath -Raw
    } else {
        ""
    }

    $content = Remove-TenbyteBlock -Content $content
    $nextContent = if ([string]::IsNullOrWhiteSpace($content)) {
        $profileBlock
    } else {
        "$content`r`n`r`n$profileBlock"
    }

    Set-Content -LiteralPath $profilePath -Value $nextContent -Encoding UTF8
    Write-Host "[TENBYTE] Updated profile: $profilePath"
}

if (-not $IncludeWindowsPowerShell) {
    Write-Host "[TENBYTE] Skipped Windows PowerShell 5.1 profile. Use -IncludeWindowsPowerShell if you explicitly want it."
}

Write-Host "[TENBYTE] MOTD installed."
Write-Host "[TENBYTE] Restart PowerShell or run: . `"$InstallPath`""
