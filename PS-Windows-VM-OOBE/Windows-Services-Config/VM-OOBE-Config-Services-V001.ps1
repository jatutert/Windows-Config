#	Stop and disable Windows Services Virtual Machine
#	Created by John Tutert for TutSOFT
#
Set-Service -Name "wuauserv" -Status stopped -StartupType disabled
Set-Service -Name "themes" -Status stopped -StartupType disabled
Set-Service -Name "sysmain" -Status stopped -StartupType disabled
Set-Service -Name "spooler" -Status stopped -StartupType disabled
Set-Service -Name "sharedaccess" -Status stopped -StartupType disabled
Set-Service -Name "iphlpsvc" -Status stopped -StartupType disabled
Set-Service -Name "defragsvc" -Status stopped -StartupType disabled
Set-Service -Name "themes" -Status stopped -StartupType disabled
Set-Service -Name "audiosrv" -Status stopped -StartupType disabled
Set-Service -Name "browser" -Status stopped -StartupType disabled
Set-Service -Name "WSearch" -Status stopped -StartupType disabled
