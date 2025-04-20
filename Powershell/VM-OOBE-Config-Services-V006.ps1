#	Windows Virtual Machine 
#	Out of the Box Expierence (OOBE)
#
#	Stop and disable Windows Services Virtual Machine
#	Created by John Tutert for TutSOFT
#
#	Versie 6
#	19 april 2025
#
#
#	Changelog
#	Version 5	Powershell
#	Version 6	Disable Browser Service 
#
#	Stoppen Windows Services
Microsoft.Powershell.Management\Stop-Service -Name "wuauserv" -Force
Microsoft.Powershell.Management\Stop-Service -Name "themes" -Force
Microsoft.Powershell.Management\Stop-Service -Name "sysmain" -Force
Microsoft.Powershell.Management\Stop-Service -Name "spooler" -Force
Microsoft.Powershell.Management\Stop-Service -Name "sharedaccess" -Force
Microsoft.Powershell.Management\Stop-Service -Name "iphlpsvc" -Force
Microsoft.Powershell.Management\Stop-Service -Name "defragsvc" -Force
Microsoft.Powershell.Management\Stop-Service -Name "audiosrv" -Force
#	Microsoft.Powershell.Management\Stop-Service -Name "browser" -Force
Microsoft.Powershell.Management\Stop-Service -Name "WSearch" -Force

#	cmd.exe /c "sc stop wuauserv"
#	cmd.exe /c "sc stop themes"
#	cmd.exe /c "sc stop sysmain"
#	cmd.exe /c "sc stop spooler"
#	cmd.exe /c "sc stop sharedaccess"
#	cmd.exe /c "sc stop iphlpsvc"
#	cmd.exe /c "sc stop defragsvc"
#	cmd.exe /c "sc stop audiosrv"
#	cmd.exe /c "sc stop browser"
#	cmd.exe /c "sc stop WSearch"

#	Disable Windows Services
Microsoft.Powershell.Management\Set-Service -Name "wuauserv" -StartupType 'Disabled'
Microsoft.Powershell.Management\Set-Service -Name "themes" -StartupType 'Disabled'
Microsoft.Powershell.Management\Set-Service -Name "sysmain" -StartupType 'Disabled'
Microsoft.Powershell.Management\Set-Service -Name "spooler" -StartupType 'Disabled'
Microsoft.Powershell.Management\Set-Service -Name "sharedaccess" -StartupType 'Disabled'
Microsoft.Powershell.Management\Set-Service -Name "iphlpsvc" -StartupType 'Disabled'
Microsoft.Powershell.Management\Set-Service -Name "defragsvc" -StartupType 'Disabled'
Microsoft.Powershell.Management\Set-Service -Name "audiosrv" -StartupType 'Disabled'
#	Microsoft.Powershell.Management\Set-Service -Name "browser" -StartupType 'Disabled'
Microsoft.Powershell.Management\Set-Service -Name "Wsearch" -StartupType 'Disabled'

#	cmd.exe /c "sc config wuauserv start=disabled"
#	cmd.exe /c "sc config themes start=disabled"
#	cmd.exe /c "sc config sysmain start=disabled"
#	cmd.exe /c "sc config spooler start=disabled"
#	cmd.exe /c "sc config sharedaccess start=disabled"
#	cmd.exe /c "sc config iphlpsvc start=disabled"
#	cmd.exe /c "sc config defragsvc start=disabled"
#	cmd.exe /c "sc config audiosrv start=disabled"
#	cmd.exe /c "sc config browser start=disabled"
#	cmd.exe /c "sc config Wsearch start=disabled"

#
#	Thats all Folks 
#