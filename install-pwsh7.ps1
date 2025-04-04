Write-host Download latest Powershell 7 release from github
$repo = "PowerShell/PowerShell"
$releasesLatest = "https://api.github.com/repos/$repo/releases/latest"

Write-Host Determining latest release
$tag = (Invoke-WebRequest $releasesLatest -UseBasicParsing| ConvertFrom-Json)[0].tag_name

Write-Host Construct filename
$filename = "Powershell-" + $tag.substring(1) + "-win-x64.msi"

Write-Host Create download url
$downloadurl = "https://github.com/$repo/releases/download/$tag/$filename"
Write-Host $download

Write-host Download the PowerShell 7 MSI package: $filename
Invoke-WebRequest -Uri $downloadurl -OutFile $env:TEMP\$filename

Write-host Install PowerShell 7
$msiPath = $env:TEMP + "\" + $filename

Write-host Start the installation process
$process = Start-Process -Wait -FilePath msiexec -ArgumentList '/i', $msiPath, '/quiet' -PassThru

Write-host Check if the installation was successful
if ($process.ExitCode  -eq 0) {
    Write-Host "PowerShell 7 has been successfully installed."
} else {
    Write-Host "PowerShell 7 installation failed with exit code $process.ExitCode"
}

Write-host Clean up the downloaded MSI file
Remove-Item -Path $env:TEMP\$filename
