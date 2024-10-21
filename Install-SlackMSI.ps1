$download = "https://slack.com/ssb/download-win64-msi"
$destination = "C:\temp\slack-standalone.msi"

# Download the MSI file
write-output "Getting the Slack MSI file"
Invoke-WebRequest -Uri $download -OutFile $destination

# Install the MSI file
Write-Output "Installing the Slack MSI file"
Start-Process "msiexec.exe" -ArgumentList "/i `"$destination`" /qn /norestart" -NoNewWindow -Wait

# Delete the MSI file
Write-Output "Deleting the Slack MSI file"
Remove-Item -Path $destination -Force