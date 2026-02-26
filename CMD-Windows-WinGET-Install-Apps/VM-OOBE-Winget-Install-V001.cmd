::
::	Microsoft Windows Out of the Box Expierence (OOBE) Script
::	Created by John Tutert for TutSOFT
::
::	Versie 1
::	23 april 2025
::
::	:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
::	RUNTIMES
::
::	:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
::	Microsoft C++ Runtime
::
@winget install --id Microsoft.VCRedist.2010.x64 --architecture x64 --accept-package-agreements --accept-source -agreements
@winget install --id Microsoft.VCRedist.2012.x64 --architecture x64 --accept-package-agreements --accept-source-agreements
@winget install --id Microsoft.VCRedist.2013.x64 --architecture x64 --accept-package-agreements --accept-source-agreements
@winget install --id Microsoft.VCRedist.2015+.x64 --architecture x64 --accept-package-agreements --accept-source-agreements
::
::	Microsoft DotNET Runtime
::
@winget install --id Microsoft.DotNet.DesktopRuntime.6 --accept-package-agreements --accept-source-agreements
@winget install --id Microsoft.DotNet.DesktopRuntime.7 --accept-package-agreements --accept-source-agreements
@winget install --id Microsoft.DotNet.DesktopRuntime.8 --accept-package-agreements --accept-source-agreements
::
::	:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
::	Windows Components
::
::	:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
::	Microsoft Windows Terminal
@winget install --id Microsoft.WindowsTerminal --accept-package-agreements --accept-source-agreements
::
::	:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
::	Windows Utilities
::
::	:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
::	SysInternals RAMMap
::
@winget install --id Microsoft.Sysinternals.RAMMap --accept-package-agreements --accept-source-agreements
::
::	:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
::	Applications
::
::	:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
::	NotePAD++
::
@winget install --id Notepad++.Notepad++ --accept-package-agreements --accept-source-agreements
::
::
::	Thats all folks
::