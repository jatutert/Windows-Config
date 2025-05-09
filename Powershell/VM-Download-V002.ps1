#
#	Windows Virtual Machine 
#	Windows Out of the Box Experience (OOBE)
#
#	Virtual Machine File Download Script
#	Created by John Tutert for TutSOFT
#
#
#	Version 2
#	18 april 2025
#
#	Changelog
#	20250424	Universele header Script
#


#	#################################################################################################################
#
#	Applicaties
#
#	#################################################################################################################


#
#	#################################################################################################################
#	# RAMMAP
#	#################################################################################################################
#
#	https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/Powershell/VM-OOBE-Config-SSH-V001.ps1
#
# Definieer de URL van het bestand dat je wilt downloaden
$rmsurl = "https://download.sysinternals.com/files/RAMMap.zip"
# Verkrijg de huidige gebruikersnaam
$username = [System.Environment]::UserName
# Definieer het pad waar het bestand moet worden opgeslagen
$rmzipdestinationPath = "C:\Users\$username\Downloads\RAMMap.zip"
$rmdestinationPath = "C:\Users\$username\Desktop"
# Zorg ervoor dat de directory bestaat
$directory = [System.IO.Path]::GetDirectoryName($rmzipdestinationPath)
if (-not (Test-Path -Path $directory)) {
    New-Item -ItemType Directory -Path $directory -Force
}
#
# Download het bestand en sla het op in de gedefinieerde directory
Invoke-WebRequest -Uri $rmsurl -OutFile $rmzipdestinationPath

# Uitpakken ZIP-Bestand naar folder Desktop 
Microsoft.PowerShell.Archive\Expand-Archive -LiteralPath $rmzipdestinationPath -DestinationPath $rmdestinationPath


#
#	#################################################################################################################
#	# Powershell 7.5 
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


#
#	#################################################################################################################
#	# NotePAD++
#	#################################################################################################################
#
# Definieer de URL van het bestand dat je wilt downloaden
$nppurl = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.7.9/npp.8.7.9.Installer.x64.exe"
# Verkrijg de huidige gebruikersnaam
$username = [System.Environment]::UserName
# Definieer het pad waar het bestand moet worden opgeslagen
$nppdestinationPath = "C:\Users\$username\Downloads\npp.8.7.9.Installer.x64.exe"
# Zorg ervoor dat de directory bestaat
$directory = [System.IO.Path]::GetDirectoryName($nppdestinationPath)
if (-not (Test-Path -Path $directory)) {
    New-Item -ItemType Directory -Path $directory -Force
}
#
# Download het bestand en sla het op in de gedefinieerde directory
Invoke-WebRequest -Uri $nppurl -OutFile $nppdestinationPath


#	#################################################################################################################
#
#	Scripts
#
#	#################################################################################################################


#
#	#################################################################################################################
#	# Winget APP Windows Command (CMD) Installer vanaf GitHUB JT
#	#################################################################################################################
#
# Definieer de URL van het bestand dat je wilt downloaden
$wgiurl = "https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/Command/VM-OOBE-Winget-Install-V001.cmd"
# Verkrijg de huidige gebruikersnaam
$username = [System.Environment]::UserName
# Definieer het pad waar het bestand moet worden opgeslagen
$wgidestinationPath = "C:\Users\$username\Downloads\VM-OOBE-Winget-Install-V001.cmd"
# Zorg ervoor dat de directory bestaat
$directory = [System.IO.Path]::GetDirectoryName($wgidestinationPath)
if (-not (Test-Path -Path $directory)) {
    New-Item -ItemType Directory -Path $directory -Force
}
#
# Download het bestand en sla het op in de gedefinieerde directory
Invoke-WebRequest -Uri $wgiurl -OutFile $wgidestinationPath


#
# Thats all folks
#
