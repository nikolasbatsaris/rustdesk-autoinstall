# install_rustdesk.ps1

$zipUrl = "https://github.com/rustdesk/rustdesk/releases/latest/download/rustdesk-1.2.3-windows_x64.zip"
$tempZip = "$env:TEMP\rustdesk.zip"
$extractDir = "$env:TEMP\rustdesk"

# Download RustDesk zip
Invoke-WebRequest -Uri $zipUrl -OutFile $tempZip -UseBasicParsing

# Extract it
Expand-Archive -Path $tempZip -DestinationPath $extractDir -Force

# Launch RustDesk
$rdeskExe = Get-ChildItem -Path $extractDir -Filter "rustdesk.exe" -Recurse | Select-Object -First 1
if ($rdeskExe) {
    Start-Process $rdeskExe.FullName
} else {
    Write-Host "RustDesk executable not found."
}
