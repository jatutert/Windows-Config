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
#	Thats all Folks 
#
