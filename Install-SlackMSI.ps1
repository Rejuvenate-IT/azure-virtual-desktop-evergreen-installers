$download = "https://slack.com/ssb/download-win64-msi"
$destination = "C:\temp\slack-standalone.msi"

# Download the MSI file
Invoke-WebRequest -Uri $download -OutFile $destination

# Install the MSI file
Start-Process "msiexec.exe" -ArgumentList "/i `"$destination`" /qn /norestart" -NoNewWindow -Wait

# Delete the MSI file
Remove-Item -Path $destination -Force