$ErrorActionPreference = "Stop"

## Function to Start Services
function Start-ApplockerServices {
    sc start appidsvc
    sc start appid
}

# Download the Policy
try {
    $ErrorActionPreference = "Stop"
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Rejuvenate-IT/azure-virtual-desktop-evergreen-installers/main/applocker_policy.xml" -OutFile "C:\applocker_policy.xml"
} catch {
    $errorMessage = $_.Exception.Message
    Write-Output "Error downloading the policy: $errorMessage"
}

# Start Services
try {
    $ErrorActionPreference = "Stop"
    Start-AppLockerServices
} catch {
    $errorMessage = $_.Exception.Message
    Write-Output "Failed to start AppLocker Services. Error: $errorMessage"
}


# Import the AppLocker Module
Import-Module -Name AppLocker -SkipEditionCheck

# Set the Policy
Set-AppLockerPolicy -XmlPolicy "c:\applocker_policy.xml"

# Set the AppLocker required services to automatic start
$registryPath = "Registry::HKLM\SYSTEM\CurrentControlSet\Services\AppIDSvc"
$registryPath2 = "Registry::HKLM\SYSTEM\CurrentControlSet\Services\AppIDSvc"
$name = "Start"
$value = "2"
Set-ItemProperty -Path $registryPath -Name $name -value $value
Set-ItemProperty -Path $registryPath2 -Name $name -value $value

# Delete the AppLocker policy file
try {
    $ErrorActionPreference = "Stop"
    Remove-Item -Path "c:\applocker_policy.xml" -Force -ErrorAction Stop
} catch {
    $errorMessage = $_.Exception.Message
    Write-Output "Error deleting the policy file: $errorMessage"
}