function Install-AppWithEvergreen
{
    param
    (
        [string]$EvergreenAppName,
        [scriptblock]$EvergreenArgs,
        [string]$AppInstallerArgs
    )

    # Download Latest version of application via Evergreen
    $App = Get-EvergreenApp -Name $EvergreenAppName | Where-Object { $EvergreenArgs.Invoke() } | Select-Object -First 1
    $AppInstallerFile = $App | Save-EvergreenApp -Path "C:\ProgramData\Evergreen\$EvergreenName"

    # Install application
    if ($AppInstallerFile -like "*.msi") {
        Start-Process "msiexec.exe" -ArgumentList "/i `"$AppInstallerFile`" $AppInstallerArgs" -NoNewWindow -Wait -Verbose
    } else {
        Start-Process "$AppInstallerFile" -ArgumentList $AppInstallerArgs -NoNewWindow -Wait -Verbose
    }

    # Cleanup temp directory
    $AppInstaller | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
} # Install-AppWithEvergreen

# Trust PowerShell Gallery
if (Get-PSRepository | Where-Object { $_.Name -eq "PSGallery" -and $_.InstallationPolicy -ne "Trusted" })
{
    Install-PackageProvider -Name "NuGet" -MinimumVersion 2.8.5.208 -Force
    Set-PSRepository -Name "PSGallery" -InstallationPolicy "Trusted"
}

# Install or update Evergreen module
$Installed = Get-Module -Name "Evergreen" -ListAvailable | `
    Sort-Object -Property @{ Expression = { [System.Version]$_.Version }; Descending = $true } | `
    Select-Object -First 1
$Published = Find-Module -Name "Evergreen"
if ($Null -eq $Installed)
{
    Install-Module -Name "Evergreen"
}
elseif ([System.Version]$Published.Version -gt [System.Version]$Installed.Version)
{
    Update-Module -Name "Evergreen"
}

# App Install
$AppName = "AdobeAcrobatReaderDC"
$SearchArguments = { $_.Architecture -eq "x64" -and $_.Language -eq "MUI" }
$InstallerArgs = '/sALL'

Install-AppWithEvergreen -EvergreenAppName $AppName -EvergreenArgs $SearchArguments -AppInstallerArgs $InstallerArgs