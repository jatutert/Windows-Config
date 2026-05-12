#
#
#
#
#   TTTTTT  U    U  TTTTTT  SSSSSS  OOOOOO  FFFFFF  TTTTTT
#     TT    U    U    TT    SS      O    O  FF        TT
#     TT    U    U    TT    SSSSSS  O    O  FFFF      TT
#     TT    U    U    TT        SS  O    O  FF        TT
#     TT    UUUUUU    TT    SSSSSS  OOOOOO  FF        TT
#
#
#
#
#   Windows Desktop and Windows Server 
#   Out of Box Experience Configurator
#
#
#   Makes your Windows ready for any use ! 
#
#
#   For Personal and/or Education Use Only ! 
#
#
#   VERSION 028
#   12 MEI 2026
#
#
Clear-Host
#
#
Write-Host "Out of Box Experience (OOBE) configurator" -ForegroundColor Green
Write-Host "Version 28" -ForegroundColor Green
Write-Host "Created by TutSOFT for personal and/or educational use" -ForegroundColor Green
#
#
#   #######################################################################
#   Alle Windows 
#   #######################################################################
#
#
#   ###########################################
#   Bepalen op welke OS het script wordt uitgevoerd
#   ###########################################
#
#
$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
#
if ($osInfo.ProductType -ne 1) {
    Write-Host "This virtual machine runs Windows Server" -ForegroundColor Green
}
else {
    Write-Host "This virtual machine runs Windows Desktop" -ForegroundColor Green
}
#
#
#   ###########################################
#   Hulpdirectories aanmaken
#   ###########################################
#
#
mkdir "$env:USERPROFILE\.TutSOFT" -Force | Out-Null
mkdir "$env:USERPROFILE\.TutSOFT\OOBE" -Force | Out-Null
mkdir "C:\Scripts" -Force | Out-Null
#
#
#   ###########################################
#   ###########################################
#   DEEL 1 VMWare Tools installeren zodat verbinding met de buitenwereld aanwezig is voor de huidige VM
#   ############################################
#   ###########################################
#
#
$registryPath = "HKLM:\SOFTWARE\VMware, Inc.\VMware Tools"
#
if (-not (Test-Path -Path $registryPath)) {
    #
    Write-Host "[VMware Tools] Installeren ..." -ForegroundColor Gray
    #
    Start-Process -FilePath "c:\vmware-tools\setup.exe" "/s", "/v/qn", "REBOOT=ReallySuppress", "EULAS_AGREED=1" -Wait
    #
}
else {
        Write-Host "[VMware Tools] Installatie niet noodzakelijk ..." -ForegroundColor Gray
}
#
#
cmd /c "echo Deel 1 VMWare Tools Afgerond > c:\Scripts\VM-OOBE-LOG.txt"
#
#
#   ###########################################
#   ###########################################
#   DEEL 2 Configuratie 
#   ###########################################
#   ###########################################
#
#
#   ######################
#   Gebruiker Administrator vrijgeven op Windows Server
#   ######################
#
#
$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
if ($osInfo.ProductType -ne 1) {
    #
    #
    Write-Host "Gebruiker Administrator op Windows Server vrijgeven"   -ForegroundColor Gray
    #
    Enable-LocalUser -Name "Administrator"
    $Password = ConvertTo-SecureString "!@WACHTwoord#$" -AsPlainText -Force
    Set-LocalUser -Name "Administrator" -Password $Password
    #
    Write-Host "Automatische inlog aanpassen van labadmin naar administrator"   -ForegroundColor Gray
    #
    $RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
    Set-ItemProperty -Path $RegPath -Name "AutoAdminLogon" -Value "1"
    Set-ItemProperty -Path $RegPath -Name "DefaultUserName" -Value "Administrator"
    Set-ItemProperty -Path $RegPath -Name "DefaultPassword" -Value "!@WACHTwoord#$"
    Set-ItemProperty -Path $RegPath -Name "DefaultDomainName" -Value "."
    #
}
#
#   ######################
#   Windows Services
#   ######################
#
#
Write-Host "Windows Services stoppen en ook uitschakelen om geheugen te besparen ..." -ForegroundColor Gray
#
mkdir "$env:USERPROFILE\.TutSOFT\OOBE\winservices" -Force | Out-Null
$OOBE_Config_Services = "$env:USERPROFILE\.TutSOFT\OOBE\winservices\VM-OOBE-Config-Services-Latest.ps1"
#
Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/PS-Windows-VM-OOBE/Windows-Services-Config/VM-OOBE-Config-Services-Latest.ps1 -OutFile $OOBE_Config_Services
#
$timeout = 0
while (!(Test-Path $OOBE_Config_Services) -and $timeout -lt 10) {
    Start-Sleep -Seconds 1
    $timeout++
}
# 
if ((Get-Item $OOBE_Config_Services ).Length -gt 0) {
    & $OOBE_Config_Services 
}
#
#
#   ######################
#   IP Adres en DNS Instellingen 
#   ######################
#
#
Write-Host "IP-Adres en DNS-instellingen aanpassen"
#
#
# Bepaal hostname
$hostname = $env:COMPUTERNAME
#
#
# Bepaal IP- en DNS-instellingen op basis van hostname
switch ($hostname) {
    'SXN-DB-01' {
        $newIp  = '192.168.40.101'
        $dnsSrv = '192.168.40.100'
    }
    'SXN-DC-01' {
        $newIp  = '192.168.40.100'
        $dnsSrv = $null   # Geen DNS-instelling aanpassen
    }
    'SXN-WS-01' {
        $newIp  = '192.168.40.10'
        $dnsSrv = '192.168.40.100'
    }
    Default {
        Write-Host "Hostname $hostname wordt niet beheerd. Geen wijziging uitgevoerd."
        exit 0
    }
}
#
#
Write-Host "Hostname $hostname herkend. IP-adres: $newIp"
#
#
# Zoek netwerkadapter met APIPA-adres (169.254.x.x)
$apipaAddress = Get-NetIPAddress -AddressFamily IPv4 |
    Where-Object { $_.IPAddress -like '169.254.*' } |
    Select-Object -First 1
#
#
if ($null -eq $apipaAddress) {
    Write-Error "Geen netwerkadapter met een 169.254.x.x adres gevonden."
    exit 1
}
#
#
$ifIndex = $apipaAddress.InterfaceIndex
#
#
# Verwijder bestaande IPv4-adressen op deze interface
Get-NetIPAddress -InterfaceIndex $ifIndex -AddressFamily IPv4 |
    Remove-NetIPAddress -Confirm:$false
#
#
# Stel statisch IP-adres in (255.255.255.0)
New-NetIPAddress `
    -InterfaceIndex $ifIndex `
    -IPAddress $newIp `
    -PrefixLength 24
#
#
# Stel DNS-server in indien van toepassing
if ($dnsSrv) {
    Set-DnsClientServerAddress `
        -InterfaceIndex $ifIndex `
        -ServerAddresses $dnsSrv

    Write-Host "DNS ingesteld op $dnsSrv"
}
#
#
Write-Host "Netwerkconfiguratie succesvol toegepast op $hostname."
#
#   ######################
#   Netwerkkaart 1 van Publiek naar Privaat zetten voor netwerkprofiel 
#   ######################
#
#
Write-Host "Netwerkkaart 1 van Publiek naar Privaat zetten"
#
Get-NetIPAddress -AddressFamily IPv4 |
Where-Object { $_.IPAddress -like '192.168.10.*' } |
ForEach-Object {
    Set-NetConnectionProfile `
        -InterfaceIndex $_.InterfaceIndex `
        -NetworkCategory Private
}
#
#
#   ####################
#   Windows Policies
#   ####################
#
#   Windows Desktop
#
$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
if ($osInfo.ProductType -eq 1) {

    Write-Host "Nieuwsfeed uitzetten Windows Desktop"

    New-Item -Path "HKLM:\Software\Policies\Microsoft\Dsh" -Force | Out-Null

    Set-ItemProperty `
        -Path "HKLM:\Software\Policies\Microsoft\Dsh" `
        -Name "AllowNewsAndInterests" `
        -Type DWord `
        -Value 0

}
#
#
cmd /c "echo Deel 2 Configuratie Afgerond >> c:\Scripts\VM-OOBE-LOG.txt"
#
#
#   ###########################################
#   ###########################################
#   DEEL 3 Installatie
#   ###########################################
#   ###########################################
#
#
#   ####################
#   WinGET Stap 1 van 2 
#   ####################
#
#
Write-Host "[WinGET] Installeren ..."  -ForegroundColor Gray
#
mkdir "$env:USERPROFILE\.TutSOFT\OOBE\winget" -Force | Out-Null
$OOBE_WinGET_Install = "$env:USERPROFILE\.TutSOFT\OOBE\winget\VM-OOBE-winget-install-Latest.ps1"
#
Invoke-WebRequest -URI https://raw.githubusercontent.com/asheroto/winget-install/master/winget-install.ps1 -OutFile $OOBE_WinGET_Install
$timeout = 0
while (!(Test-Path $OOBE_WinGET_Install) -and $timeout -lt 10) {
    Start-Sleep -Seconds 1
    $timeout++
}
# 
if ((Get-Item $OOBE_WinGET_Install ).Length -gt 0) {
    & $OOBE_WinGET_Install -Force
}
#
#
#   ####################
#   WinGET Stap 2 van 2 Licentie Activeren
#   ####################
#
#
Write-Host "[WinGet] Licentie activeren ..." -ForegroundColor White
#
cmd.exe /c "echo Y | winget list"
#
#
#   ####################
#   Winget gebruiken om diverse onderdelen bij te werken of nieuwe installaties te doen
#   ####################
#
#
#   ####################
#   WinGET DotNET DesktopRuntime
#   ####################
#
#
Write-Host "DotNet Runtime installeren"
#
winget install Microsoft.DotNet.DesktopRuntime.8.x86 --scope machine --accept-package-agreements --accept-source-agreements
winget install Microsoft.DotNet.DesktopRuntime.8.x64 --scope machine --accept-package-agreements --accept-source-agreements
#
#
#   ####################
#   WinGET VCRedist
#   ####################
#
#
Write-Host "Visual C Runtime installeren"
#
winget install Microsoft.VCRedist.2005.x64 --scope machine --accept-package-agreements --accept-source-agreements
winget install Microsoft.VCRedist.2008.x64 --scope machine --accept-package-agreements --accept-source-agreements
winget install Microsoft.VCRedist.2010.x64 --scope machine --accept-package-agreements --accept-source-agreements
winget install Microsoft.VCRedist.2012.x64 --scope machine --accept-package-agreements --accept-source-agreements
winget install Microsoft.VCRedist.2013.x64 --scope machine --accept-package-agreements --accept-source-agreements
winget install Microsoft.VCRedist.2015+.x86 --scope machine --accept-package-agreements --accept-source-agreements
winget install Microsoft.VCRedist.2015+.x64 --scope machine --accept-package-agreements --accept-source-agreements
#
#
#   ###########################################
#   WinGET Applicaties 
#   ###########################################
#
#
Write-Host "[WinGet] Applicaties installeren ..." -ForegroundColor White
#
#
#   Windows Desktop
#
#
$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
if ($osInfo.ProductType -eq 1) {
    #
    #
    #   ####################
    #   NanaZIP
    #   ####################
    #
    #
    Write-Host "[WinGet] M2Team.NanaZip" -ForegroundColor Gray
    #
    winget install M2Team.NanaZip
    #
    #
    #   ####################
    #   PatchMyPC
    #   ####################
    #
    #
    Write-Host "[WinGet] PatchMyPC" -ForegroundColor Gray
    #
    winget Install PatchMyPC.PatchMyPC
    #
    #
    #   ####################
    #   PowerToys
    #   ####################
    #
    #
    Write-Host "[WinGET] Microsoft.PowerToys" -ForegroundColor Gray
    #
    winget install Microsoft.PowerToys
    #
    #
    #   ####################
    #   Microsoft.Teams Removal
    #   ####################
    #
    #
    Write-Host "[WinGET] Microsoft.Teams Remove" -ForegroundColor Gray
    #
    winget uninstall Microsoft.Teams
    #
    #
    #   ####################
    #   UniGETUI
    #   ####################
    #
    #
    Write-Host "[WinGet] UniGetUI" -ForegroundColor Gray
    #
    winget Install Devolutions.UniGetUI
    #
    #
    #   ####################
    #   Microsoft Visual Studio Code 
    #   ####################
    #
    #
    Write-Host "[WinGet] Microsoft Visual Studio Code" -ForegroundColor Gray
    #
    winget Install Microsoft.VisualStudioCode
}
#
#
#   Winget Windows Desktop en Windows Server
#
#
#   ####################
#   cURL
#   ####################
#
Write-Host "[WinGet] CURL" -ForegroundColor Gray
#
winget install cURL.cURL --scope machine --accept-package-agreements --accept-source-agreements
#
#
#   ####################
#   Microsoft.Edit
#   ####################
#
Write-Host "[WinGet] Microsoft.Edit" -ForegroundColor Gray
#
winget install Microsoft.Edit --scope machine --accept-package-agreements --accept-source-agreements
#
#
#   ####################
#   Mozilla Firefox
#   ####################
#
Write-Host "[WinGet] Mozilla.Firefox.nl" -ForegroundColor Gray
#
winget install Mozilla.Firefox.nl
#
#
#   ####################
#   GNU Nano
#   ####################
#
#
Write-Host "[WinGet] GNU Nano" -ForegroundColor Gray
#
winget install GNU.Nano --scope machine --accept-package-agreements --accept-source-agreements
#
#
#   ####################
#   NotePad++
#   ####################
#
#
Write-Host "[WinGet] NotePad++" -ForegroundColor Gray
#
winget install Notepad++.Notepad++ --scope machine --accept-package-agreements --accept-source-agreements
#
#
#   ####################
#   Powershell 7
#   ####################
#
#   Windows Desktop
#
$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
if ($osInfo.ProductType -eq 1) {
    Write-Host "[WinGET] Powershell 7" -ForegroundColor Gray
    #
    winget install Microsoft.Powershell --accept-package-agreements --accept-source-agreements
    #
}
#
#   Windows Server
#
$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
if ($osInfo.ProductType -ne 1) {
    Write-Host "[WinGET] Powershell 7" -ForegroundColor Gray
    #
    winget install Microsoft.Powershell --scope machine --accept-package-agreements --accept-source-agreements
    #
}
#
#
#   ####################
#   Microsoft.Sysinternals.RAMMap
#   ####################
#
#
Write-Host "[WinGET] Microsoft.Sysinternals.RAMMap" -ForegroundColor Gray
#
winget install Microsoft.Sysinternals.RAMMap --scope machine --accept-package-agreements --accept-source-agreements
#
#
#   ####################
#   Windows Terminal
#   ####################
#
#
Write-Host "[WinGet] Microsoft Windows Terminal (Huidige Gebruiker)" -ForegroundColor Gray
#
#   Let OP
#
#   Geen installatie met scope machine mogelijk
#   Daarom alleen voor de gebruiker labadmin beschikbaar
#
#
winget install Microsoft.WindowsTerminal
#
#
#   ####################
#   WinGET Update Applicaties
#   ####################
#
#
#
Write-Host "[WinGet] Alles bijwerken" -ForegroundColor Gray
#
winget update --all
#
#
cmd /c "echo Deel 3 Installeren mbv Winget afgerond >> c:\Scripts\VM-OOBE-LOG.txt"
#
#
#   ###########################################
#   ###########################################
#   DEEL 4 Powershell klaarmaken voor gebruik
#   ###########################################
#   ###########################################
#
#
#   ###################
#   Powershell 7 Remote Config 
#   ###################
#
#
Write-Host "[Powershell 7] Remote configureren ..." -ForegroundColor White
#
pwsh -c Enable-PSRemoting -Force
pwsh -c Set-NetFirewallRule -Name 'WINRM-HTTP-In-TCP' -RemoteAddress Any
#   pwsh -c Set-NetFirewallRule -Name 'WINRM-HTTPS-In-TCP' -RemoteAddress Any
#
#
#   ###################
#   Powershell 5 en 7 Active Directory
#   ###################
#
#   https://www.varonis.com/blog/powershell-active-directory-module


Write-Host "[Powershell] Active Directory modules activeren (duurt soms erg lang) ..." -ForegroundColor White


#   Windows Desktop

$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
if ($osInfo.ProductType -eq 1) {
    Add-WindowsCapability -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0 -Online
    pwsh -c Add-WindowsCapability -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0 -Online
}


#   Windows Server

$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
if ($osInfo.ProductType -ne 1) {
    Install-WindowsFeature -Name "RSAT-AD-PowerShell" -IncludeAllSubFeature
}

#
#
#   ###################
#   Powershell Azure
#   ###################
#
#

Write-Host "[Powershell 5] Installeren Azure modules (duurt soms erg lang) ..."

Set-PSRepository -Name PSGallery -InstallationPolicy Trusted 
Install-Module -Name Az -Repository PSGallery -Force

Write-Host "[Powershell 7] Installeren Azure modules (duurt soms erg lang) ..."

pwsh -c Set-PSRepository -Name PSGallery -InstallationPolicy Trusted 
pwsh -c Install-Module -Name Az -Repository PSGallery -Force

#
#
#   ###################
#   Powershell Help
#   ###################
#
#

Write-Host "[Powershell] Help bijwerken ..."

Update-Help -force -ea 0

pwsh -c Update-Help -force -ea 0


#
#
cmd /c "echo Deel 4 Powershell Configuratie is gereed >> c:\Scripts\VM-OOBE-LOG.txt"
#
#
#   ###########################################
#   ###########################################
#   DEEL 5 Scripts Downloaden 
#   ###########################################
#   ###########################################
#
#
#   #################
#   AD DS DOMAIN JOINER Downloaden
#   #################
#
#
mkdir "C:\Scripts" -Force | Out-Null
Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/PS-Windows-Active-Directory/WC11-WS22-AD-Join.ps1 -OutFile "C:\Scripts\WC11-WS22-AD-Join.ps1"
#
#
#
#   #################
#   VM-OOBE-WinGet-User Downloaden
#   ##################
#
#
mkdir "C:\Scripts" -Force | Out-Null
Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/CMD-Windows-WinGET-Install-Apps/VM-OOBE-WinGet-User.ps1 -OutFile "C:\Scripts\VM-OOBE-WinGet-User.ps1"
#
#
#   ##################
#   TutSOFT SF ADDS
#   #################
#
#
mkdir "C:\Scripts" -Force | Out-Null
Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/PS-Windows-Active-Directory/WS22-AD-DC-Install.ps1 -OutFile "C:\Scripts\WS22-AD-DC-Install.ps1" 
Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/PS-Windows-Active-Directory/WS22-AD-DC-Promote.ps1 -OutFile "C:\Scripts\WS22-AD-DC-Promote.ps1" 
#   Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/PS-Windows-Active-Directory/WS22-AD-DC-Import-Users.ps1 -OutFile "C:\Scripts\WS22-AD-DC-Import-Users.ps1" 
Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/PS-Windows-Active-Directory/WS22-AD-DC-Import-Users-OU.ps1 -OutFile "C:\Scripts\WS22-AD-DC-Import-Users-OU.ps1" 
Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/PS-Windows-Active-Directory/ad_gebruikers.csv -OutFile "C:\Scripts\ad_gebruikers.csv" 
#
#
cmd /c "echo Deel 5 Scripts downloaden is gereed >> c:\Scripts\VM-OOBE-LOG.txt"
#
#
#   ###########################################
#   ###########################################
#   DEEL 6 Windows Server SSH en WINRM 
#   ###########################################
#   ###########################################
#
#
$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
if ($osInfo.ProductType -ne 1) {
    #
    #
    #   ###########################################
    #   SSH Server
    #   ###########################################
    #
    #
    Write-Host "SSH Server installeren en configureren..."  -ForegroundColor White
    #
    mkdir "$env:USERPROFILE\.TutSOFT\OOBE\SSH" -Force | Out-Null
    $OOBE_Config_SSH = "$env:USERPROFILE\.TutSOFT\OOBE\SSH\VM-OOBE-Config-SSH-Latest.ps1"
    #
    Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/PS-Windows-VM-OOBE/Windows-Remote-SSH/VM-OOBE-Config-SSH-Latest.ps1 -OutFile $OOBE_Config_SSH
    #
    $timeout = 0
    while (!(Test-Path $OOBE_Config_SSH) -and $timeout -lt 10) {
        Start-Sleep -Seconds 1
        $timeout++
    }
    # 
    if ((Get-Item $OOBE_Config_SSH ).Length -gt 0) {
        & $OOBE_Config_SSH 
    }
    #
    #
    #   ###########################################
    #   WinRM Service
    #   ###########################################
    #
    #
    Write-Host "Windows WinRM service activeren en configureren..." -ForegroundColor White
    #
    mkdir "$env:USERPROFILE\.TutSOFT\OOBE\winrm" -Force | Out-Null
    $OOBE_Config_WinRM = "$env:USERPROFILE\.TutSOFT\OOBE\winrm\VM-OOBE-Windows-WinRM-Config-Latest.ps1"
    #
    Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/PS-Windows-VM-OOBE/Windows-WinRM-Config/VM-OOBE-Windows-WinRM-Config-Latest.ps1 -OutFile $OOBE_Config_WinRM
    #
    $timeout = 0
    while (!(Test-Path $OOBE_Config_WinRM) -and $timeout -lt 10) {
        Start-Sleep -Seconds 1
        $timeout++
    }
    # 
    if ((Get-Item $OOBE_Config_WinRM ).Length -gt 0) {
        & $OOBE_Config_WinRM
    }
    #
    #
    cmd /c "echo Deel 6 Windows Server SSH en WinRM is gereed >> c:\Scripts\VM-OOBE-LOG.txt"
} 
#
#
#   ###########################################
#   ###########################################
#   DEEL 7 Windows Server Firewall Poorten
#   ###########################################
#   ###########################################
#
#
$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
if ($osInfo.ProductType -ne 1) {
    #
    #
    #   ###########################################
    #   SQL Server
    #   ###########################################
    #
    #
    $Hostname = $env:COMPUTERNAME
    if ($Hostname -eq 'SXN-DB-01') {
        New-NetFirewallRule -DisplayName "SQLServer default instance" -Direction Inbound -LocalPort 1433 -Protocol TCP -Action Allow
        New-NetFirewallRule -DisplayName "SQLServer Browser service" -Direction Inbound -LocalPort 1434 -Protocol UDP -Action Allow
    }
    #
    #
}
#
#
#   ###########################################
#   Herstarten Virtuele machine
#   ###########################################
#
#
#   x
#   x
#   x
#
#

Start-Sleep -Seconds 5
Restart-Computer -Force

#
#
#   ###########################################
#   Melding
#   ###########################################
#
#
#   x
#   x
#   x
#
#
#   Add-Type -AssemblyName System.Windows.Forms
#
#   [System.Windows.Forms.MessageBox]::Show(
#       "Virtuele machine is klaar voor gebruik !",
#       "Scripting met Powershell",
#       [System.Windows.Forms.MessageBoxButtons]::OK,
#       [System.Windows.Forms.MessageBoxIcon]::Information
#   )
#
#
#   ###########################################
#   x
#   ###########################################
#
#
#   x
#   x
#   x
#
#
#   ################################################################################
#   ################################################################################
#   THATS ALL FOLKS
#   ################################################################################
#   ################################################################################
#
#
#   This is the end
#   Hold your breath and count to ten
#   Feel the Earth move and then
#   Hear my heart burst again
#   For this is the end
#   I've drowned and dreamt this moment
#   So overdue, I owe them
#   Swept away, I'm stolen
#
#   Adelle
#