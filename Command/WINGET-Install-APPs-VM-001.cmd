::
:: Install Applications Virtual Machine
:: Version 1 
:: 20 juli 2024
::
:: Auteur John Tutert
::
:: For Personal or Educational Use Only ! 
::
:: RUNTIMES
::
@echo Starting installing Runtimes ...  
:: x86
:: @winget install --id Microsoft.VCRedist.2005.x86 -a x86		--force --accept-package-agreements --accept-source-agreements >nul 2>&1
:: @winget install --id Microsoft.VCRedist.2008.x86 -a x86		--force --accept-package-agreements --accept-source-agreements >nul 2>&1
:: @winget install --id Microsoft.VCRedist.2010.x86 -a x86 	--force --accept-package-agreements --accept-source-agreements >nul 2>&1
:: @winget install --id Microsoft.VCRedist.2012.x86 -a x86 	--force --accept-package-agreements --accept-source-agreements >nul 2>&1
:: @winget install --id Microsoft.VCRedist.2013.x86 -a x86 	--force --accept-package-agreements --accept-source-agreements >nul 2>&1
:: @winget install --id Microsoft.VCRedist.2015+.x86 -a x86 	--force --accept-package-agreements --accept-source-agreements >nul 2>&1
:: x64
:: @winget install --id Microsoft.VCRedist.2005.x64 -a x64 	--force --accept-package-agreements --accept-source-agreements >nul 2>&1
:: @winget install --id Microsoft.VCRedist.2008.x64 -a x64 	--force --accept-package-agreements --accept-source-agreements >nul 2>&1
@winget install --id Microsoft.VCRedist.2010.x64 --architecture x64 --force --silent --accept-package-agreements --accept-source -agreements
@winget install --id Microsoft.VCRedist.2012.x64 --architecture x64 --force --silent --accept-package-agreements --accept-source-agreements
@winget install --id Microsoft.VCRedist.2013.x64 --architecture x64 --force --silent --accept-package-agreements --accept-source-agreements
@winget install --id Microsoft.VCRedist.2015+.x64 --architecture x64 --force --silent --accept-package-agreements --accept-source-agreements
:: .NET
:: @winget install --id Microsoft.DotNet.DesktopRuntime.5 		--force --accept-package-agreements --accept-source-agreements >nul 2>&1
@winget install --id Microsoft.DotNet.DesktopRuntime.6 --force --silent --accept-package-agreements --accept-source-agreements
@winget install --id Microsoft.DotNet.DesktopRuntime.7 --force --silent --accept-package-agreements --accept-source-agreements
@winget install --id Microsoft.DotNet.DesktopRuntime.8 --force --silent --accept-package-agreements --accept-source-agreements
:: ASP.NET
:: @winget install --id Microsoft.DotNet.AspNetCore.5 			--force --accept-package-agreements --accept-source-agreements >nul 2>&1
:: @winget install --id Microsoft.DotNet.AspNetCore.6 			--force --accept-package-agreements --accept-source-agreements >nul 2>&1
:: @winget install --id Microsoft.DotNet.AspNetCore.7 			--force --accept-package-agreements --accept-source-agreements >nul 2>&1
:: @winget install --id Microsoft.DotNet.AspNetCore.8 			--force --accept-package-agreements --accept-source-agreements >nul 2>&1
:: APP Runtime 
:: @winget install --id Microsoft.WindowsAppRuntime.1.3 		--force --accept-package-agreements --accept-source-agreements >nul 2>&1
:: @winget install --id Microsoft.WindowsAppRuntime.1.4 		--force --accept-package-agreements --accept-source-agreements >nul 2>&1
:: @winget install --id Microsoft.WindowsAppRuntime.1.5 		--force --accept-package-agreements --accept-source-agreements >nul 2>&1
:: 
::	@winget install --id Microsoft.AppInstaller 					--force --accept-package-agreements --accept-source-agreements >nul 2>&1
:: 
::	@winget install --id Microsoft.EdgeWebView2Runtime 			--force --accept-package-agreements --accept-source-agreements >nul 2>&1
::
:: SYSTEM TOOLS
:: 
@echo #### Updating System Tools gestart ...
::
:: 	Microsoft
@winget install --id Microsoft.WindowsTerminal --force --silent --accept-package-agreements --accept-source-agreements >nul 2>&1
@winget install --id Microsoft.PowerToys --force --silent --accept-package-agreements --accept-source-agreements >nul 2>&1
:: Xbox Game BAR 
::	@winget install --id 9NZKPSTSNW4P --force 
:: 
@winget install --id 7zip.7zip --force --silent --accept-package-agreements --accept-source-agreements >nul 2>&1
::
::	Linux Tools
@winget install --id cURL.cURL --force --silent --accept-package-agreements --accept-source-agreements >nul 2>&1
:: @winget install --id GNU.Wget2 	--silent --accept-package-agreements --accept-source-agreements >nul 2>&1
:: 
::	Container Orchestration 
::	@winget install --id Kubernetes.minikube --silent --accept-package-agreements --accept-source-agreements >nul 2>&1
::	@winget install --id Kubernetes.kubectl --silent --accept-package-agreements --accept-source-agreements >nul 2>&1
:: 
::	Infrastructure as Code 
::	@winget install --id Hashicorp.Terraform --silent --accept-package-agreements --accept-source-agreements >nul 2>&1
::	@winget install --id Hashicorp.Vagrant --silent --accept-package-agreements --accept-source-agreements >nul 2>&1
::	winget install --id Canonical.Multipass --silent --accept-package-agreements --accept-source-agreements --force 
::
::	Development 
::	@winget install --id Microsoft.VisualStudioCode.Insiders --silent --accept-package-agreements --accept-source-agreements
:: winget install --id JetBrains.IntelliJIDEA.Ultimate.EAP --silent --accept-package-agreements --accept-source-agreements
::	@winget install --id GitHub.GitHubDesktop --silent --accept-package-agreements --accept-source-agreements
:: 
::	@winget install --id IObit.DriverBooster --silent --accept-package-agreements --accept-source-agreements --uninstall-previous
::
::	ISO Tooling 
::	@winget install --id Nlitesoft.NTLite --silent --accept-package-agreements --accept-source-agreements
::
:: Wise Registry Cleaner Free 
::	@winget install --id XPDLS1XBTXVPP4 --silent --accept-package-agreements --accept-source-agreements
::	@winget install --id WiseCleaner.WiseDiskCleaner --silent --accept-package-agreements --accept-source-agreements
:: Privacy Eraser Free
::	@winget install --id XPDLMDV4FVRFW0 			--silent --accept-package-agreements --accept-source-agreements
:: 
::	@winget install --id DominikReichl.KeePass	--silent --accept-package-agreements --accept-source-agreements 
::
::	@winget install --id SURF.eduVPNClient 		--silent --accept-package-agreements --accept-source-agreements --force
::
:: WEB BROWSERS
:: 
@echo #### installn WEB browsers ... 
::	Chromium 
::	https://www.chromium.org/Home/
::
@winget install --id Brave.Brave --force --silent --accept-package-agreements --accept-source-agreements
::	@winget install --id Microsoft.Edge 				--silent --accept-package-agreements --accept-source-agreements --force 
::	@winget install --id Google.Chrome 				--silent --accept-package-agreements --accept-source-agreements --force 
::
::	Mozilla
::	@winget install --id Mozilla.Firefox 			--silent --accept-package-agreements --accept-source-agreements --force 
::
@echo #### PDF Tooling ....
::
:: Adobe
::	@winget install --id Adobe.Acrobat.Reader.64-bit	--silent --accept-package-agreements --accept-source-agreements 
:: 
:: MultiMedia
::	@echo #### install Multimedia ... 
::	@winget install --id Daum.PotPlayer 				--silent --accept-package-agreements --accept-source-agreements >nul 2>&1
::	@winget install --id HandBrake.HandBrake			--silent --accept-package-agreements --accept-source-agreements >nul 2>&1
::	@winget install --id Daum.PotPlayer				--silent --accept-package-agreements --accept-source-agreements --force >nul 2>&1
::	@winget install --id AtomixProductions.VirtualDJ --silent --accept-package-agreements --accept-source-agreements >nul 2>&1
::	@winget install --id OBSProject.OBSStudio 		--silent --accept-package-agreements --accept-source-agreements >nul 2>&1
::
:: Grafisch
::	@echo #### install Grafisch ...
::	@winget install --id JGraph.Draw 				--silent --accept-package-agreements --accept-source-agreements >nul 2>&1