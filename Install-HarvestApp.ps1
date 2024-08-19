function Download-AppxPackage {
    [CmdletBinding()]
    param (
      [string]$Uri,
      [string]$Path = "."
    )
       
      process {
        $Path = (Resolve-Path $Path).Path
        #Get Urls to download
        $WebResponse = Invoke-WebRequest -UseBasicParsing -Method 'POST' -Uri 'https://store.rg-adguard.net/api/GetFiles' -Body "type=url&url=$Uri&ring=Retail" -ContentType 'application/x-www-form-urlencoded' -UserAgent 'ps'
        $LinksMatch = $WebResponse.Links | where {$_ -like '*.appx*' -or $_ -like '*.appxbundle*' -or $_ -like '*.msix*' -or $_ -like '*.msixbundle*'} | where {$_ -like '*_neutral_*' -or $_ -like "*_"+$env:PROCESSOR_ARCHITECTURE.Replace("AMD","X").Replace("IA","X")+"_*"} | Select-String -Pattern '(?<=a href=").+(?=" r)'
        $DownloadLinks = $LinksMatch.matches.value 
    
        function Resolve-NameConflict{
        #Accepts Path to a FILE and changes it so there are no name conflicts
        param(
        [string]$Path
        )
            $newPath = $Path
            if(Test-Path $Path){
                $i = 0;
                $item = (Get-Item $Path)
                while(Test-Path $newPath){
                    $i += 1;
                    $newPath = Join-Path $item.DirectoryName ($item.BaseName+"($i)"+$item.Extension)
                }
            }
            return $newPath
        }
        #Download Urls
        foreach($url in $DownloadLinks){
            $FileRequest = Invoke-WebRequest -Uri $url -UseBasicParsing #-Method Head
            $FileName = ($FileRequest.Headers["Content-Disposition"] | Select-String -Pattern  '(?<=filename=).+').matches.value
            $FilePath = Join-Path $Path $FileName; $FilePath = Resolve-NameConflict($FilePath)
            [System.IO.File]::WriteAllBytes($FilePath, $FileRequest.content)
            echo $FilePath
        }
      }
    }



# Make a path to store the download

$folderPath = "C:\Temp\HarvestApp"
if (-not (Test-Path $folderPath)) {
    New-Item -ItemType Directory -Path $folderPath | Out-Null
}

# Download Harvest App
Download-AppxPackage -Uri "https://apps.microsoft.com/detail/9pblbm45rjqj" -Path "c:\Temp\HarvestApp"

# Get all .appx files in the specified directory
$appxFiles = Get-ChildItem -Path $folderPath -Filter "*.appx"

# Loop through each .appx file and run the desired command
foreach ($appxFile in $appxFiles) {
    # Run the desired command for each file
    # Replace "x" with the desired command
    write-host $appxFile
}

# Provision the Appx package
DISM.EXE /Online /Add-ProvisionedAppxPackage /PackagePath:c:\Temp\HarvestApp\$appxFile /SkipLicense
