# AI Office installer for Windows. Usage (paste into PowerShell):
#   irm https://kakigawatei.github.io/ai-office/install.ps1 | iex
# This file is ASCII only on purpose (old PowerShell reads web text as ANSI). Japanese messages live inside the kit.
& {
  $ErrorActionPreference = 'Stop'
  try { [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12 } catch {}
  $kit = Join-Path $env:USERPROFILE 'ai-office-kit'
  $tmp = Join-Path $env:TEMP ('aioffice_' + [guid]::NewGuid().ToString('N'))
  Write-Host '=== AI Office installer (Windows) ==='
  Write-Host 'Downloading the kit...'
  New-Item -ItemType Directory -Force $tmp | Out-Null
  Invoke-WebRequest -UseBasicParsing 'https://kakigawatei.github.io/ai-office/kit.zip' -OutFile (Join-Path $tmp 'kit.zip')
  Add-Type -AssemblyName System.IO.Compression.FileSystem
  [IO.Compression.ZipFile]::ExtractToDirectory((Join-Path $tmp 'kit.zip'), $tmp, [Text.Encoding]::UTF8)   # Japanese file names: decode as UTF-8 (Expand-Archive garbles them)
  if (Test-Path $kit) { Remove-Item -Recurse -Force $kit }
  Move-Item (Join-Path $tmp 'ai-office-kit') $kit
  Remove-Item -Recurse -Force $tmp
  Get-ChildItem -Recurse $kit | Unblock-File -ErrorAction SilentlyContinue
  powershell.exe -NoProfile -ExecutionPolicy Bypass -File (Join-Path $kit 'install_win.ps1') -Kit $kit
}
