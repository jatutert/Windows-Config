#	Stop and disable Windows Services Virtual Machine
#	Created by John Tutert for TutSOFT
#
cmd.exe /c "sc stop wuauserv"
cmd.exe /c "sc stop themes"
cmd.exe /c "sc stop sysmain"
cmd.exe /c "sc stop spooler"
cmd.exe /c "sc stop sharedaccess"
cmd.exe /c "sc stop iphlpsvc"
cmd.exe /c "sc stop defragsvc"
cmd.exe /c "sc stop audiosrv"
cmd.exe /c "sc stop browser"
cmd.exe /c "sc stop WSearch"
#
cmd.exe /c "sc config wuauserv start=disabled"
cmd.exe /c "sc config themes start=disabled"
cmd.exe /c "sc config sysmain start=disabled"
cmd.exe /c "sc config spooler start=disabled"
cmd.exe /c "sc config sharedaccess start=disabled"
cmd.exe /c "sc config iphlpsvc start=disabled"
cmd.exe /c "sc config defragsvc start=disabled"
cmd.exe /c "sc config audiosrv start=disabled"
cmd.exe /c "sc config browser start=disabled"
cmd.exe /c "sc config Wsearch start=disabled"
#
#	Windows News Feed uitzetten
#	https://thesysadminchannel.com/how-to-remove-news-and-interests-windows-10/
#
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds" -Name "ShellFeedsTaskbarViewMode" -Value 2
#	reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Feeds" /v ShellFeedsTaskbarViewMode /t REG_DWORD /d 2
#

#	Powershell 7.5 
winget upgrade --all --source msstore --accept-source-agreements --accept-package-agreements
winget install 9MZ1SNWT0N5D --source msstore --accept-source-agreements --accept-package-agreements

#	Windows Terminal
winget install 9N0DX20HK701 --source msstore --accept-source-agreements --accept-package-agreements

#	Thats all Folks 
#
