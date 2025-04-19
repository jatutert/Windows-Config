#
#	WinGET Install APP within Virtual Machine
#	Version 1
#	19 april 2025
#

#	Microsoft C Runtime
winget install --id Microsoft.VCRedist.2010.x64 --architecture x64 --accept-package-agreements --accept-source-agreements
winget install --id Microsoft.VCRedist.2012.x64 --architecture x64 --accept-package-agreements --accept-source-agreements
winget install --id Microsoft.VCRedist.2013.x64 --architecture x64 --accept-package-agreements --accept-source-agreements
winget install --id Microsoft.VCRedist.2015+.x64 --architecture x64 --accept-package-agreements --accept-source-agreements

#	Microsoft DotNET Runtime 
winget install --id Microsoft.DotNet.DesktopRuntime.6 --accept-package-agreements --accept-source-agreements
winget install --id Microsoft.DotNet.DesktopRuntime.7 --accept-package-agreements --accept-source-agreements
winget install --id Microsoft.DotNet.DesktopRuntime.8 --accept-package-agreements --accept-source-agreements

#	Microsoft Powershell 7.5
winget install Microsoft.Powershell --accept-package-agreements --accept-source-agreements

#	Microsoft Windows Terminal 
winget install Microsoft.WindowsTerminal --accept-package-agreements --accept-source-agreements

#	GNU Nano
winget install GNU.Nano --accept-package-agreements --accept-source-agreements

#	Wget2
winget install GNU.Wget2 --accept-package-agreements --accept-source-agreements

#	CURL
winget install cURL.cURL --accept-package-agreements --accept-source-agreements