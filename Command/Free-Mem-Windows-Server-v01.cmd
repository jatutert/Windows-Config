::
::	Saxion University of Applied Sciences | HBO-ICT
::	Virtual Machine services stopper and disabler version 1.0 
:: 
::	Services stop 
::
@ECHO OFF
@CLS
@ECHO "Services stop"
:: Windows Update
@ECHO "Windows update"
@sc stop "wuauserv"
:: Themes
@ECHO "Windows Themes"
@sc stop "themes"
:: Prefetch
@ECHO "Windows Prefetch"
@sc stop "sysmain"
:: printspooler
@sc stop "spooler"
@sc stop "sharedaccess"
:: IP Helper
@sc stop "iphlpsvc"
:: Disk optimizer / defrag
@sc stop "defragsvc"
:: audio
@sc stop "audiosrv"
@sc stop "browser"
:: Windows Search
@EcHO "Windows Search"
@sc stop "WSearch"
::
@ECHO "Services Disabler"
::	Services disable
::
sc config "wuauserv" start=disabled
sc config "themes" start=disabled
sc config "sysmain" start=disabled
sc config "spooler" start=disabled
sc config "sharedaccess" start=disabled
sc config "iphlpsvc" start=disabled
sc config "defragsvc" start=disabled
sc config "audiosrv" start=disabled
sc config "browser" start=disabled
sc config "Wsearch" start=disabled
::
::
::	shutdown /r /c "services disabled"
::
::


