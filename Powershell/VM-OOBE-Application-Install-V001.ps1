#
#	Windows Virtual Machine
#	Out of the Box Expierence (OOBE)
#
#	Appication Install Script
#	Version 1
#
#	20 april 2025
#	Created by John Tutert for TutSOFT
#

#	Microsoft PowerSHELL 7.5 Installation
#	
#	Test 21 april 2025
#	WERKT NIET
#	NO PASS
#
#	cmd.exe /s "c:\Users\Vagrant\Downloads\PowerShell-7.5.0-win-x64.MSI /quiet"

#	###########################################################33
#	Nieuwe poging
#	21 april
#	NOT TESTED 

# Verkrijg de huidige gebruikersnaam
$username = [System.Environment]::UserName

# Define the path where the installer will be downloaded
$installerPath = "C:\Users\$username\Downloads\\PowerShell-7.5.0-win-x64.msi"

# Define the arguments for the MSI installer
$msiArguments = "/i `"$installerPath`" /quiet"

# Install PowerShell 7
Start-Process msiexec.exe -ArgumentList $msiArguments -Wait

#
#	That is all Folks
#