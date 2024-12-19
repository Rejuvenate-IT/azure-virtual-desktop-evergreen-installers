$download = "https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RE4AQBt"
$destination = "C:\temp\teams-rtc-client.msi"

# Download the MSI file
write-output "Getting the Teams RTC Client MSI file"
Invoke-WebRequest -Uri $download -OutFile $destination

# Install the MSI file
Write-Output "Installing the Teams RTC Client MSI file"
Start-Process "msiexec.exe" -ArgumentList "/i `"$destination`" /passive /norestart" -NoNewWindow -Wait

# Delete the MSI file
Write-Output "Deleting the Teams RTC Client MSI file"
Remove-Item -Path $destination -Force