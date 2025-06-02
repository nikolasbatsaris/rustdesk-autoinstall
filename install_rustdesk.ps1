<#
.SYNOPSIS
    Download the latest RustDesk release for Windows and run it.
#>

# ── 0. Housekeeping ────────────────────────────────────────────────────────────
$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12   # old PS5 boxes

# ── 1. Detect CPU word-size ────────────────────────────────────────────────────
$arch = if ((Get-CimInstance Win32_OperatingSystem).OSArchitecture -like '*64*') {
    'x86_64'       # GitHub asset uses this token for 64-bit
} else {
    'x86'
}

# ── 2. Query GitHub for the latest release ─────────────────────────────────────
$apiUrl  = 'https://api.github.com/repos/rustdesk/rustdesk/releases/latest'
$headers = @{ 'User-Agent' = 'PowerShell' }      # GitHub requires it
$latest  = Invoke-RestMethod -Uri $apiUrl -Headers $headers

# ── 3. Pick the first *.exe* asset that matches our architecture ───────────────
$asset   = $latest.assets |
           Where-Object { $_.name -match "$arch\.exe$" } |
           Select-Object -First 1

if (-not $asset) {
    Write-Error "Couldn’t find a Windows-$arch installer in the latest release."
    exit 1
}

# ── 4. Download to %TEMP% and launch ───────────────────────────────────────────
$tempFile = Join-Path $env:TEMP $asset.name
Invoke-WebRequest -Uri $asset.browser_download_url `
                  -OutFile $tempFile `
                  -Headers $headers `
                  -UseBasicParsing

Start-Process -FilePath $tempFile
