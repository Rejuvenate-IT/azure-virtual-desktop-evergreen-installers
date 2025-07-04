# Download and Install Microsoft Access Runtime
$url = "https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=AccessRuntimeRetail&language=en-us&platform=x64"
$outputPath = "$env:TEMP\OfficeSetup.exe"

Write-Host "Downloading Microsoft Access Runtime..."
try {
    Invoke-WebRequest -Uri $url -OutFile $outputPath
    
    if (Test-Path $outputPath) {
        Write-Host "Download completed. Starting installation..."
        Start-Process -FilePath $outputPath -Wait -NoNewWindow
        Write-Host "Installation process completed."
        
        # Clean up the downloaded file
        Remove-Item -Path $outputPath -Force
    } else {
        Write-Error "Failed to download the installer."
        exit 1
    }
} catch {
    Write-Error "An error occurred: $_"
    exit 1
}
