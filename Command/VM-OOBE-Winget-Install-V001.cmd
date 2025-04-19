:: 
@winget install --id Microsoft.VCRedist.2010.x64 --architecture x64 --force --silent --accept-package-agreements --accept-source -agreements
@winget install --id Microsoft.VCRedist.2012.x64 --architecture x64 --force --silent --accept-package-agreements --accept-source-agreements
@winget install --id Microsoft.VCRedist.2013.x64 --architecture x64 --force --silent --accept-package-agreements --accept-source-agreements
@winget install --id Microsoft.VCRedist.2015+.x64 --architecture x64 --force --silent --accept-package-agreements --accept-source-agreements
::
@winget install --id Microsoft.DotNet.DesktopRuntime.6 --force --silent --accept-package-agreements --accept-source-agreements
@winget install --id Microsoft.DotNet.DesktopRuntime.7 --force --silent --accept-package-agreements --accept-source-agreements
@winget install --id Microsoft.DotNet.DesktopRuntime.8 --force --silent --accept-package-agreements --accept-source-agreements
::
@winget install --id Microsoft.WindowsTerminal --force --silent --accept-package-agreements --accept-source-agreements