#
#
#	Virtual Machine File Download Script
#	Version 1
#
#	18 april 2025
#	John Tutert
#
#
#	#################################################################################################################
#	# SSH Server Configuration Script
#	#################################################################################################################
#
#	https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/Powershell/VM-OOBE-Config-SSH-V001.ps1
#
# Definieer de URL van het bestand dat je wilt downloaden
$sshsurl = "https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/Powershell/VM-OOBE-Config-SSH-V001.ps1"
# Verkrijg de huidige gebruikersnaam
$username = [System.Environment]::UserName
# Definieer het pad waar het bestand moet worden opgeslagen
$sshsdestinationPath = "C:\Users\$username\Downloads\VM-OOBE-Config-SSH-V001.ps1"
# Zorg ervoor dat de directory bestaat
$directory = [System.IO.Path]::GetDirectoryName($sshsdestinationPath)
if (-not (Test-Path -Path $directory)) {
    New-Item -ItemType Directory -Path $directory -Force
}
#
# Download het bestand en sla het op in de gedefinieerde directory
Invoke-WebRequest -Uri $sshsurl -OutFile $sshsdestinationPath
#
#	#################################################################################################################
#	# SSH Server Configuration Script
#	#################################################################################################################
#
#	x64
#	https://github.com/PowerShell/PowerShell/releases/download/v7.5.0/PowerShell-7.5.0-win-x64.exe
#	https://github.com/PowerShell/PowerShell/releases/download/v7.5.0/PowerShell-7.5.0-win-x64.msi
#
# Definieer de URL van het bestand dat je wilt downloaden
$ps75url = "https://github.com/PowerShell/PowerShell/releases/download/v7.5.0/PowerShell-7.5.0-win-x64.msi"
# Verkrijg de huidige gebruikersnaam
$username = [System.Environment]::UserName
# Definieer het pad waar het bestand moet worden opgeslagen
$ps75destinationPath = "C:\Users\$username\Downloads\PowerShell-7.5.0-win-x64.msi"
# Zorg ervoor dat de directory bestaat
$directory = [System.IO.Path]::GetDirectoryName($ps75destinationPath)
if (-not (Test-Path -Path $directory)) {
    New-Item -ItemType Directory -Path $directory -Force
}
#
# Download het bestand en sla het op in de gedefinieerde directory
Invoke-WebRequest -Uri $ps75url -OutFile $ps75destinationPath