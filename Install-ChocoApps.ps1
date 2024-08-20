Set-ExecutionPolicy Bypass -Scope Process -Force

# Check Permissions
if ( -Not( (New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) ){
    Write-Error -Message "Script needs Administrator permissions"
    exit 1
}

if (-Not (Get-Command "choco" -errorAction SilentlyContinue)) {
   [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
   iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

choco feature enable -n=allowGlobalConfirmation
choco install 7zip
choco install vlc
choco install paint.net
#choco install inkscape
#choco install notepadplusplus
#choco install notepadreplacer --params "'/NOTEPAD:C:\Program Files\Notepad++\notepad++.exe'"
choco install cutepdf
choco install sumatrapdf.install
#choco install greenshot # Greenshot runs at startup and is not needed
choco install powerbi
# choco install keeper