#
#	WinGET Install APP within Virtual Machine
#	Version 1
#	19 april 2025
#

cmd.exe /c "winget source update"

#	Error
#	0x8a15000f : Data required by the source is missing

#	Microsoft C Runtime
cmd.exe /c "winget install --id Microsoft.VCRedist.2010.x64 --architecture x64 --accept-package-agreements --accept-source-agreements"
cmd.exe /c "winget install --id Microsoft.VCRedist.2012.x64 --architecture x64 --accept-package-agreements --accept-source-agreements"
cmd.exe /c "winget install --id Microsoft.VCRedist.2013.x64 --architecture x64 --accept-package-agreements --accept-source-agreements"
cmd.exe /c "winget install --id Microsoft.VCRedist.2015+.x64 --architecture x64 --accept-package-agreements --accept-source-agreements"

#	Microsoft DotNET Runtime 
cmd.exe /c "winget install --id Microsoft.DotNet.DesktopRuntime.6 --accept-package-agreements --accept-source-agreements"
cmd.exe /c "winget install --id Microsoft.DotNet.DesktopRuntime.7 --accept-package-agreements --accept-source-agreements"
cmd.exe /c "winget install --id Microsoft.DotNet.DesktopRuntime.8 --accept-package-agreements --accept-source-agreements"

#	Microsoft Powershell 7.5
cmd.exe /c "winget install Microsoft.Powershell --accept-package-agreements --accept-source-agreements"

#	Microsoft Windows Terminal 
cmd.exe /c "winget install Microsoft.WindowsTerminal --accept-package-agreements --accept-source-agreements"

#	GNU Nano
cmd.exe /c "winget install GNU.Nano --accept-package-agreements --accept-source-agreements"

#	Wget2
cmd.exe /c "winget install GNU.Wget2 --accept-package-agreements --accept-source-agreements"

#	CURL
cmd.exe /c "winget install cURL.cURL --accept-package-agreements --accept-source-agreements"