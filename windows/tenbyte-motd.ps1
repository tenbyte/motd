$esc = [char]27
$Cyan = "$esc[36m"
$Blue = "$esc[0;34m"
$White = "$esc[37m"
$Bold = "$esc[1m"
$Reset = "$esc[0m"

$LabelWidth = 11
$ValueWidth = 30

function Get-FallbackMemoryBytes {
    try {
        Add-Type -AssemblyName Microsoft.VisualBasic -ErrorAction Stop
        $computerInfo = New-Object Microsoft.VisualBasic.Devices.ComputerInfo
        return [uint64]$computerInfo.TotalPhysicalMemory
    }
    catch {
        return $null
    }
}

function Get-JsonCache {
    param(
        [string]$Path,
        [int]$MaxAgeHours
    )

    if (-not (Test-Path -LiteralPath $Path)) {
        return $null
    }

    try {
        $cache = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
        if (-not $cache.Timestamp) {
            return $null
        }

        $age = (Get-Date) - [DateTime]$cache.Timestamp
        if ($age.TotalHours -le $MaxAgeHours) {
            return $cache
        }
    }
    catch {
        return $null
    }

    return $null
}

function Set-JsonCache {
    param(
        [string]$Path,
        [object]$Value
    )

    try {
        $Value | ConvertTo-Json | Set-Content -LiteralPath $Path -Encoding UTF8
    }
    catch {
        return
    }
}

function Get-UptimeSpan {
    try {
        $tickCount = [Environment]::TickCount64
        if (-not $tickCount) {
            $tickCount = [Environment]::TickCount
        }
    }
    catch {
        $tickCount = [Environment]::TickCount
    }

    if ($tickCount -lt 0) {
        $tickCount = [int64]$tickCount + [uint32]::MaxValue + 1
    }

    return [TimeSpan]::FromMilliseconds($tickCount)
}

function Get-SystemInfoCache {
    param([string]$Path)

    $cache = Get-JsonCache -Path $Path -MaxAgeHours 24
    if ($cache) {
        return $cache
    }

    $memoryBytes = Get-FallbackMemoryBytes
    $info = [pscustomobject]@{
        Timestamp = (Get-Date).ToString("o")
        OS = Get-WindowsName
        CPU = Get-CpuName
        RAM = if ($memoryBytes) { "{0:N0} GB" -f ($memoryBytes / 1GB) } else { "unknown RAM" }
    }

    Set-JsonCache -Path $Path -Value $info
    return $info
}

function Get-WindowsName {
    try {
        $cv = Get-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -ErrorAction Stop
        $productName = $cv.ProductName
        if ([int]$cv.CurrentBuild -ge 22000) {
            $productName = $productName -replace "Windows 10", "Windows 11"
        }

        $name = if ($cv.DisplayVersion) {
            "$productName $($cv.DisplayVersion)"
        } else {
            $productName
        }

        if ($cv.CurrentBuild) {
            return "$name ($($cv.CurrentBuild))"
        }

        return $name
    }
    catch {
        return [Environment]::OSVersion.VersionString
    }
}

function Get-CpuName {
    try {
        $cpu = Get-ItemProperty -LiteralPath "HKLM:\HARDWARE\DESCRIPTION\System\CentralProcessor\0" -ErrorAction Stop
        if ($cpu.ProcessorNameString) {
            return ($cpu.ProcessorNameString -replace "\s+", " ").Trim()
        }
    }
    catch {
        return $null
    }

    if ($env:PROCESSOR_IDENTIFIER) {
        return "$env:PROCESSOR_IDENTIFIER ($env:NUMBER_OF_PROCESSORS cores)"
    }

    return "unknown CPU"
}

function Get-LocalAddresses {
    $result = [ordered]@{
        IPv4 = $null
        IPv6 = $null
    }

    try {
        $interfaces = [System.Net.NetworkInformation.NetworkInterface]::GetAllNetworkInterfaces() |
            Where-Object {
                $_.OperationalStatus -eq [System.Net.NetworkInformation.OperationalStatus]::Up -and
                $_.NetworkInterfaceType -ne [System.Net.NetworkInformation.NetworkInterfaceType]::Loopback
            }

        foreach ($interface in $interfaces) {
            foreach ($address in $interface.GetIPProperties().UnicastAddresses) {
                $ip = $address.Address

                if (-not $result.IPv4 -and $ip.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork) {
                    $value = $ip.ToString()
                    if ($value -notlike "169.254.*") {
                        $result.IPv4 = $value
                    }
                }

                if (-not $result.IPv6 -and $ip.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetworkV6) {
                    if (-not $ip.IsIPv6LinkLocal -and -not $ip.IsIPv6Multicast -and -not $ip.IsIPv6SiteLocal) {
                        $result.IPv6 = $ip.ToString()
                    }
                }
            }

            if ($result.IPv4 -and $result.IPv6) {
                return $result
            }
        }
    }
    catch {
        return $result
    }

    return $result
}

function Write-MotdRow {
    param(
        [string]$Icon,
        [string]$Label,
        [string]$Value
    )

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return
    }

    $cleanValue = ($Value -replace "[`r`n`t]+", " ").Trim()
    if ($cleanValue.Length -gt $ValueWidth) {
        $cleanValue = $cleanValue.Substring(0, $ValueWidth)
    }

    Write-Host ("{0}| {1}{2,-2} {3}{4,-$LabelWidth} {0}| {0}{5,-$ValueWidth} {0}|{6}" -f $White, $Blue, $Icon, $Cyan, $Label, $cleanValue, $Reset)
}

function Write-Border {
    $left = "-" * ($LabelWidth + 5)
    $right = "-" * ($ValueWidth + 2)
    Write-Host ("{0}+{1}+{2}+{3}" -f $White, $left, $right, $Reset)
}

$hostname = [Environment]::MachineName
$systemCacheFile = Join-Path ([System.IO.Path]::GetTempPath()) "tenbyte_motd_system.json"
$systemInfo = Get-SystemInfoCache -Path $systemCacheFile
$distro = $systemInfo.OS
$cpuName = $systemInfo.CPU
$ram = $systemInfo.RAM
$shell = "PowerShell $($PSVersionTable.PSVersion)"
$span = Get-UptimeSpan
$uptime = "{0}d {1}h {2}m" -f $span.Days, $span.Hours, $span.Minutes

$localAddresses = Get-LocalAddresses
$localIPv4 = $localAddresses.IPv4
$localIPv6 = $localAddresses.IPv6

Write-Host "${Cyan}  __ ${Reset}${White}    _             _           _       "
Write-Host "${Cyan}  \ \ ${Reset}${White}  | |_ ___ _ __ | |__  _   _| |_ ___ "
Write-Host "${Cyan}   \ \ ${Reset}${White} | __/ _ \ '_ \| '_ \| | | | __/ _ \"
Write-Host "${Cyan}   / / ${Reset}${White} | ||  __/ | | | |_) | |_| | ||  __/"
Write-Host "${Cyan}  /_/ ${Reset}${White}   \__\___|_| |_|_.__/ \__, |\__\___|"
Write-Host "                              |___/         ${Reset}"
Write-Host "${Bold}${Cyan}       POWERED BY TENBYTE ${Reset}"
Write-Host ""

Write-Border
Write-MotdRow "[]" "OS" $distro
Write-MotdRow "@>" "Host" $hostname
Write-MotdRow "::" "CPU+RAM" "$cpuName | $ram"
Write-MotdRow '$>' "Shell" $shell
Write-MotdRow "^^" "Uptime" $uptime
Write-MotdRow "<>" "Local IPv4" $localIPv4
Write-MotdRow "<6" "Local IPv6" $localIPv6
Write-Border
