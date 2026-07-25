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
#     The Netherlands/Nederland/Niederlande/Pays Bas/Paisos Bajos
#     NL EU
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
#   Version 1
#   Build   037
#   Channel Canary
#   Date    25 juli 2026
#
#
Clear-Host
#
#
Write-Host "Out of Box Experience (OOBE) configurator" -ForegroundColor Green
Write-Host "Version 1 Build 37" -ForegroundColor Green
Write-Host "Created by TutSOFT for personal and/or educational use" -ForegroundColor Green
#
#
#   #######################################################################
#   Alle Windows 
#   #######################################################################
#
#
#   ###########################################
#   STAP 1 Bepalen Windows Desktop of Windows Server 
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
echo "STAP 1 Bepalen Windows Desktop of Windows Server voltooid" | Add-Content c:\Scripts\VM-OOBE-LOG.txt
#
#
#   ###########################################
#   STAP 2 Hulpdirectories aanmaken
#   ###########################################
#
#
Try { 
    mkdir "$env:USERPROFILE\.TutSOFT" -Force | Out-Null
    mkdir "$env:USERPROFILE\.TutSOFT\OOBE" -Force | Out-Null
    mkdir "C:\Scripts" -Force | Out-Null
}
Catch {
Write-Host "Directories konden niet worden gemaakt!"
}
#
#
echo "STAP 2 Hulpdiretories maken voltooid" | Add-Content c:\Scripts\VM-OOBE-LOG.txt
#
#
#   ###########################################
#   STAP 3 Downloaden Script
#   ###########################################
#
#
Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/PS-Windows-VM-OOBE/SXN-LAB-VM-OOBE/PS-Windows-VM-OOBE-Latest.ps1 -OutFile C:\Scripts\PS-Windows-VM-OOBE-Latest.ps1
#
#
echo "STAP 3 Downloaden Script naar directory Scripts voltooid" | Add-Content c:\Scripts\VM-OOBE-LOG.txt
#
#
#   ###########################################
#   STAP 4 VMWare Tools installeren zodat verbinding met de buitenwereld aanwezig is voor de huidige VM
#   ###########################################
#
#
$registryPath = "HKLM:\SOFTWARE\VMware, Inc.\VMware Tools"
#
if (-not (Test-Path -Path $registryPath)) {
    #
    Write-Host "[VMware Tools] Installeren ..." -ForegroundColor Gray
    #
    Try { 
        Start-Process -FilePath "c:\vmware-tools\setup.exe" "/s", "/v/qn", "REBOOT=ReallySuppress", "EULAS_AGREED=1" -Wait
    }
    Catch {
        Write-Host "Installatie VMware Tools gaf een fout"
        echo "Installatie VMware Tools gaf een fout" | Add-Content c:\Scripts\VM-OOBE-LOG.txt
    } 
    #
}
else {
        Write-Host "[VMware Tools] Installatie niet noodzakelijk ..." -ForegroundColor Gray
        echo "Installatie VMware Tools is niet noodzakelijk" | Add-Content c:\Scripts\VM-OOBE-LOG.txt
}
#
#
echo "STAP 4 VMWare Tools installeren voltooid" | Add-Content c:\Scripts\VM-OOBE-LOG.txt
#
#
#   ######################
#   STAP 5 Gebruiker Administrator vrijgeven en instellen als default gebruiker
#   ######################
#
#
$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
if ($osInfo.ProductType -ne 1) {
    #
    #
    Write-Host "Stap 5A Gebruiker Administrator op Windows Server vrijgeven"   -ForegroundColor Gray
    #
    Try {
        Enable-LocalUser -Name "Administrator"
        $Password = ConvertTo-SecureString "!@WACHTwoord#$" -AsPlainText -Force
        Set-LocalUser -Name "Administrator" -Password $Password
    }
    Catch {
        Write-Host "Gebruiker Administrator vrijgeven gaf een fout"
        echo "Gebruiker Administrator vrijgeven gaf een fout" | Add-Content c:\Scripts\VM-OOBE-LOG.txt
    } 
    #
    Write-Host "Stap 5B Automatische inlog aanpassen van labadmin naar administrator"   -ForegroundColor Gray
    #
    Try {
        $RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
        Set-ItemProperty -Path $RegPath -Name "AutoAdminLogon" -Value "1"
        Set-ItemProperty -Path $RegPath -Name "DefaultUserName" -Value "Administrator"
        Set-ItemProperty -Path $RegPath -Name "DefaultPassword" -Value "!@WACHTwoord#$"
        Set-ItemProperty -Path $RegPath -Name "DefaultDomainName" -Value "."
    }
    Catch {
        Write-Host "Automatische inlog aanpassen van labadmin naar administrator gaf een fout"
        echo "Automatische inlog aanpassen van labadmin naar administrator gaf een fout" | Add-Content c:\Scripts\VM-OOBE-LOG.txt
    } 
    #
}
#
#
echo "STAP 5 Gebruiker Administrator vrijgeven en instellen als default gebruiker is voltooid" | Add-Content c:\Scripts\VM-OOBE-LOG.txt 
#
#
#   ######################
#   STAP 6 Windows Services Uitschakelen 
#   ######################
#
#
Write-Host "Stap 6 Windows Services stoppen en ook uitschakelen om geheugen te besparen ..." -ForegroundColor Gray
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
#   Windows Desktop Instellingen 
#
$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
if ($osInfo.ProductType -eq 1) {

    #   Windows Maintenance Uitschakelen
    cmd.exe /c "reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance /v MaintenanceDisabled /t REG_DWORD /d 1 /f"

    #   Windows Update uitschakelen
    cmd.exe /c "reg add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU /v AUOptions /t REG_DWORD /d 2 /f"

    #   Windows Telemetry uitschakelen
    cmd.exe /c "reg add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection /v AllowTelemetry  /t REG_DWORD /d 0 /f"

}
#
#
echo "STAP 6 Windows Services uitschakelen voltooid" | Add-Content c:\Scripts\VM-OOBE-LOG.txt 
#
#
#   ######################
#   Stap 7 IP Adres en DNS Instellingen 
#   ######################
#
#
Write-Host "Stap 7 IP-Adres en DNS-instellingen aanpassen"
#
#

# Zoek de netwerkadapter met een IPv4-adres dat begint met 10.
$AdapterConfig = Get-NetIPAddress -AddressFamily IPv4 |
    Where-Object { $_.IPAddress -like '10.*' } |
    Select-Object -First 1

if ($AdapterConfig) {

    $InterfaceIndex = $AdapterConfig.InterfaceIndex
    $CurrentIP      = $AdapterConfig.IPAddress
    $PrefixLength   = $AdapterConfig.PrefixLength

    Write-Host "Gevonden netwerkkaart:"
    Write-Host "InterfaceIndex : $InterfaceIndex"
    Write-Host "Huidig IP      : $CurrentIP"

    # Bepaal netwerkdeel (eerste drie octetten)
    $Octets = $CurrentIP.Split('.')
    $NetworkBase = "$($Octets[0]).$($Octets[1]).$($Octets[2])"

    # DNS-server krijgt altijd .200 als laatste octet
    $DnsServer = "$NetworkBase.200"

    # Bepaal nieuw IP-adres op basis van hostname
    $ComputerName = $env:COMPUTERNAME.ToUpper()

    switch ($ComputerName) {
        'SXN-DB-01' {
            $NewIP = "$NetworkBase.111"
        }
        'SXN-DC-01' {
            $NewIP = "$NetworkBase.101"
        }
        'SXN-RD-01' {
            $NewIP = "$NetworkBase.121"
        }
        default {
            Write-Warning "Hostname '$ComputerName' is niet bekend."
            Write-Warning "Netwerkconfiguratie wordt overgeslagen."
            $NewIP = $null
        }
    }

    if ($NewIP) {

        Write-Host "Nieuw IP-adres wordt: $NewIP"

        # Bepaal huidige default gateway (indien aanwezig)
        $Gateway = (
            Get-NetRoute -InterfaceIndex $InterfaceIndex `
                         -DestinationPrefix "0.0.0.0/0" |
            Sort-Object RouteMetric |
            Select-Object -First 1
        ).NextHop

        #
        #   Verwijder bestaande statische IPv4-adressen
        #

        Get-NetIPAddress -InterfaceIndex $InterfaceIndex -AddressFamily IPv4 |
            Where-Object { $_.PrefixOrigin -eq 'Manual' } |
            Remove-NetIPAddress -Confirm:$false

        # Wacht kort zodat Windows de wijzigingen verwerkt
        Start-Sleep -Seconds 2


        #
        #   Stel nieuw statisch IP-adres in
        #

        if ($Gateway) {
            New-NetIPAddress `
                -InterfaceIndex $InterfaceIndex `
                -IPAddress $NewIP `
                -PrefixLength $PrefixLength `
                -DefaultGateway $Gateway
        }
        else {
            New-NetIPAddress `
                -InterfaceIndex $InterfaceIndex `
                -IPAddress $NewIP `
                -PrefixLength $PrefixLength
        }

        # Configureer DNS indien hostname NIET SXN-DC-01 is
        if ($ComputerName -ne 'SXN-DC-01') {

            Set-DnsClientServerAddress `
                -InterfaceIndex $InterfaceIndex `
                -ServerAddresses $DnsServer

            Write-Host "DNS-server ingesteld op $DnsServer"
        }

        Write-Host "Netwerkconfiguratie voltooid."
    }
}
else {

    Write-Warning "Geen netwerkkaart gevonden met een IPv4-adres dat begint met 10."
    Write-Warning "Netwerkinstellingen zijn niet gewijzigd."
    Write-Warning "Configureer de netwerkkaart handmatig indien nodig."

}
#
#
echo "STAP 7 IP Adres instellingen aanpassen voltooid" | Add-Content c:\Scripts\VM-OOBE-LOG.txt 
#
#
#   ######################
#   Stap 8 Netwerkkaart 1 van Publiek naar Privaat zetten voor netwerkprofiel 
#   ######################
#
#
Write-Host "Netwerkkaart 1 van Publiek naar Privaat zetten"
#

Try { 
    Get-NetIPAddress -AddressFamily IPv4 |
    Where-Object { $_.IPAddress -like '192.168.10.*' } |
    ForEach-Object {
        Set-NetConnectionProfile `
            -InterfaceIndex $_.InterfaceIndex `
            -NetworkCategory Private
    }
}
Catch {
    Write-Host "Netwerkkaart 1 van Publiek naar Privaat zetten gaf een fout"
    echo "Netwerkkaart 1 van Publiek naar Privaat zetten gaf een fout" | Add-Content c:\Scripts\VM-OOBE-LOG.txt 
} 
#
#
echo "STAP 8 Netwerkkaart 1 van Publiek naar Privaat zetten voltooid" | Add-Content c:\Scripts\VM-OOBE-LOG.txt 
#
#
#   ####################
#   Stap 9 Windows Desktop Policies instellen 
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
echo "STAP 9 Windows Desktop Policies instellen voltooid" | Add-Content c:\Scripts\VM-OOBE-LOG.txt 
#
#
#   ####################
#   Stap 10A WinGET Stap 1 van 2 
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
echo "STAP 10A WinGet Stap 1 van 2 voltooid" | Add-Content c:\Scripts\VM-OOBE-LOG.txt 
#
#
#   ####################
#   Stap 10B WinGET Stap 2 van 2 Licentie Activeren
#   ####################
#
#
Write-Host "[WinGet] Licentie activeren ..." -ForegroundColor White
#
cmd.exe /c "echo Y | winget list"
#
#
echo "STAP 10B WinGet Stap B van 2 voltooid" | Add-Content c:\Scripts\VM-OOBE-LOG.txt 
#
#
#   ####################
#   STAP 11 Installaties Runtimes
#   ####################
#
#
echo "STAP 11 Installatie Runtimes met behulp van WinGet gestart" | Add-Content c:\Scripts\VM-OOBE-LOG.txt 
#
#
#   ####################
#   Stap 11A WinGET DotNET DesktopRuntime
#   ####################
#
#
Write-Host "Stap 11A DotNet Runtime installeren"
#
winget install Microsoft.DotNet.DesktopRuntime.8.x86 --scope machine --accept-package-agreements --accept-source-agreements
winget install Microsoft.DotNet.DesktopRuntime.8.x64 --scope machine --accept-package-agreements --accept-source-agreements
#
#
#   ####################
#   Stap 11B WinGET VCRedist
#   ####################
#
#
Write-Host "Stap 11B Visual C Runtime installeren"
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
echo "STAP 11 Installatie Runtimes met behulp van WinGet voltooid" | Add-Content c:\Scripts\VM-OOBE-LOG.txt 
#
#
#   ###########################################
#   STAP 12 WinGET Verwijderen Applicaties 
#   ###########################################
#
#
echo "STAP 12 Applicaties verwijderen Windows Desktop mbv WinGet gestart" | Add-Content c:\Scripts\VM-OOBE-LOG.txt 
#
#
Write-Host "STAP 12 Applicaties verwijderen Windows Desktop mbv Winget gestart" -ForegroundColor White
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
    #   Microsoft OneDrive
    #   ####################
    #
    #
    Write-Host "[WinGet] MS OneDrive verwijderen" -ForegroundColor Gray
    #
    winget uninstall Microsoft.OneDrive
    #
    #
    #   ####################
    #   Microsoft Outlook 
    #   ####################
    #
    #
    Write-Host "[WinGet] MS Outlook verwijderen" -ForegroundColor Gray
    #
    winget uninstall 9NRX63209R7B
    #
    #
    #   ####################
    #   Microsoft Teams 
    #   ####################
    #
    #
    Write-Host "[WinGet] MS Teams verwijderen" -ForegroundColor Gray
    #
    winget uninstall XP8BT8DW290MPQ
    winget uninstall Microsoft.Teams
    #
    #
} 
#
#
echo "STAP 12 Applicaties verwijderen Windows Desktop mbv WinGet voltooid" | Add-Content c:\Scripts\VM-OOBE-LOG.txt 
#
#
#   ###########################################
#   STAP 13 WinGET Installeren Applicaties Windows Desktop
#   ###########################################
#
#
echo "STAP 13 Applicaties installeren mbv Winget op Windows Desktop gestart" | Add-Content c:\Scripts\VM-OOBE-LOG.txt 
#
#
Write-Host "STAP 13 Applicaties installeren mbv Winget op Windows Desktop gestart" -ForegroundColor White
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
    Write-Host "[STAP 13A] M2Team.NanaZip" -ForegroundColor Gray
    #
    winget install M2Team.NanaZip
    #   ####################
    #   PatchMyPC
    #   ####################
    #
    #
    Write-Host "[Stap 13B] PatchMyPC" -ForegroundColor Gray
    #
    winget Install PatchMyPC.PatchMyPC
    #
    #
    #   ####################
    #   PowerToys
    #   ####################
    #
    #
    Write-Host "[Stap 13C] Microsoft.PowerToys" -ForegroundColor Gray
    #
    winget install Microsoft.PowerToys
    #
    #
    #   ####################
    #   UniGETUI
    #   ####################
    #
    #
    Write-Host "[Stap 13D] UniGetUI" -ForegroundColor Gray
    #
    winget Install Devolutions.UniGetUI
    #
    #
    #   ####################
    #   Microsoft Visual Studio Code 
    #   ####################
    #
    #
    Write-Host "[Stap 13E] Microsoft Visual Studio Code" -ForegroundColor Gray
    #
    winget Install Microsoft.VisualStudioCode
}
#
#
echo "STAP 13 Applicaties installeren mbv Winget op Windows Desktop voltooid" | Add-Content c:\Scripts\VM-OOBE-LOG.txt 
#
#
#   ###########################################
#   STAP 14 WinGET Installeren Applicaties Windows Desktop en Windows Server
#   ###########################################
#
#
echo "STAP 14 Applicaties installeren mbv Winget gestart" | Add-Content c:\Scripts\VM-OOBE-LOG.txt 
#
#
Write-Host "STAP 14 Applicaties installeren mbv Winget gestart" -ForegroundColor White
#
#
#   ####################
#   cURL
#   ####################
#
Write-Host "[Stap 14A] CURL" -ForegroundColor Gray
#
winget install cURL.cURL --scope machine --accept-package-agreements --accept-source-agreements
#
#
#   ####################
#   Microsoft.Edit
#   ####################
#
Write-Host "[Stap 14B] Microsoft.Edit" -ForegroundColor Gray
#
winget install Microsoft.Edit --scope machine --accept-package-agreements --accept-source-agreements
#
#
#   ####################
#   Mozilla Firefox
#   ####################
#
Write-Host "[Stap 14C] Mozilla.Firefox.nl" -ForegroundColor Gray
#
winget install Mozilla.Firefox.nl
#
#
#   ####################
#   GNU Nano
#   ####################
#
#
Write-Host "[Stap 14D] GNU Nano" -ForegroundColor Gray
#
winget install GNU.Nano --scope machine --accept-package-agreements --accept-source-agreements
#
#
#   ####################
#   NotePad++
#   ####################
#
#
Write-Host "[Stap 14E] NotePad++" -ForegroundColor Gray
#
winget install Notepad++.Notepad++ --scope machine --accept-package-agreements --accept-source-agreements
#
#
#   ####################
#   Powershell 7 installeren 
#   ####################
#
#
#   Windows Desktop
#
$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
if ($osInfo.ProductType -eq 1) {
    Write-Host "[Stap14F] Powershell 7 Windows Desktop" -ForegroundColor Gray
    #
    winget install Microsoft.Powershell --accept-package-agreements --accept-source-agreements
    #
}
#
#   Windows Server
#
$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
if ($osInfo.ProductType -ne 1) {
    Write-Host "[Stap14F] Powershell 7 Windows Server" -ForegroundColor Gray
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
Write-Host "[STap14G] Microsoft.Sysinternals.RAMMap" -ForegroundColor Gray
#
winget install Microsoft.Sysinternals.RAMMap --scope machine --accept-package-agreements --accept-source-agreements
#
#
#   ####################
#   Windows Terminal
#   ####################
#
#
Write-Host "[Stap14H] Microsoft Windows Terminal (Huidige Gebruiker)" -ForegroundColor Gray
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
echo "STAP 14 Applicaties installeren mbv Winget voltooid" | Add-Content c:\Scripts\VM-OOBE-LOG.txt 
#
#
#   ####################
#   Stap 15 WinGET Update Applicaties
#   ####################
#
#
#
Write-Host "[Stap 15] Winget update software" -ForegroundColor Gray
#
winget update --all
#
#
echo "STAP 15 Winget update software" | Add-Content c:\Scripts\VM-OOBE-LOG.txt 
#
#
#   ###########################################
#   Stap 16 Powershell klaarmaken voor gebruik
#   ###########################################
#
echo "STAP 16 Powershell klaarmaken voor gebruik gestart" | Add-Content c:\Scripts\VM-OOBE-LOG.txt 
#
#
#   ###################
#   Stap 16A Powershell Basisinstellingen aanpassen 
#   ###################
#
#

#   Powershell Gallery vetrouwen 
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
pwsh -c Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

#   Voorkeuren instellen voor gedrag van dit script Powershell 5
$ConfirmPreference = 'None'
$ErrorActionPreference = 'Stop'
#   Voorkeuren instellen voor gedrag van dit script Powershell 7
pwsh -c $ConfirmPreference = 'None'
pwsh -c $ErrorActionPreference = 'Stop'

#   TLS protocol versie 1.2 
Try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
}
Catch {
    Write-Host "[Powershell 5] TLS Protocol versie 1.2 instellen zorgde voor een error"
} 
#
#
Try {
    pwsh -c [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
}
Catch {
    Write-Host "[Powershell 7] TLS Protocol versie 1.2 instellen zorgde voor een error"
} 
#
#
#   ###################
#   Stap 16B Powershell NuGet provider en PowerShellGet bijwerken
#   ###################
#
#

#
#   https://oneuptime.com/blog/post/2026-02-16-how-to-troubleshoot-azure-powershell-module-installation-and-authentication-errors/view
#

Try { 
    Write-Host "[Powershell 5] NuGet provider en PowerShellGet bijwerken" -ForegroundColor White
    Install-Module -Name PowerShellGet -Force -AllowClobber -AcceptLicense -Confirm:$false
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Confirm:$false
}
Catch {
    Write-Host "[Powershell 5] NuGet Provider en Powershell Get bijwerken is niet gelukt"
} 
#
#
Try { 
    Write-Host "[Powershell 7] NuGet provider en PowerShellGet bijwerken" -ForegroundColor White
    pwsh -c Install-Module -Name PowerShellGet -Force -AllowClobber -AcceptLicense -Confirm:$false
    pwsh -c Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Confirm:$false
}
Catch {
    Write-Host "[Powershell 7] NuGet Provider en Powershell Get bijwerken is niet gelukt"
} 
#
#
#   ###################
#   Stap 16C Powershell Windows Updates installeren
#   ###################
#
#
Try { 
    Install-Module -Name PSWindowsUpdate -Force
    Import-Module PSWindowsUpdate
} 
Catch {
    Write-Host "[Powershell 5] Powershell Module Windows Update installatie is niet gelukt"
} 
#
#
Try { 
    pwsh -c Install-Module -Name PSWindowsUpdate -Force
    pwsh -c Import-Module PSWindowsUpdate
} 
Catch {
    Write-Host "[Powershell 7] Powershell Module Windows Update installatie is niet gelukt"
} 

#
#
#   ###################
#   Stap 16D Powershell Remote Config 
#   ###################
#
#
Try { 
    Write-Host "[Powershell 5] Remote configureren ..." -ForegroundColor White
    Enable-PSRemoting -Force
} 
Catch {
    Write-Host "Powershell 5 Remote Config is niet gelukt"
} 


Try { 
    Write-Host "[Powershell 7] Remote configureren ..." -ForegroundColor White
    pwsh -c Enable-PSRemoting -Force
} 
Catch {
    Write-Host "Powershell 7 Remote Config is niet gelukt"
} 
#
#   ###################
#   Stap 16E Powershell 5 en 7 Active Directory
#   ###################
#
#   https://www.varonis.com/blog/powershell-active-directory-module


Write-Host "[Powershell] Active Directory modules activeren (duurt soms erg lang) ..." -ForegroundColor White


#   Windows Desktop

#   https://learn.microsoft.com/en-us/windows-server/administration/install-remote-server-administration-tools?tabs=windows-powershell%2Cpowershell&pivots=windows-client-11

$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
if ($osInfo.ProductType -eq 1) {
    #
    Add-WindowsCapability -Online -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0
    #
    pwsh -c Add-WindowsCapability -Online -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0
    #
}


#   Windows Server

#   https://learn.microsoft.com/en-us/windows-server/administration/install-remote-server-administration-tools?tabs=windows-powershell%2Cpowershell&pivots=windows-server-2022

$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
if ($osInfo.ProductType -ne 1) {
    Install-WindowsFeature -Name "RSAT-AD-PowerShell" -IncludeAllSubFeature
}

#
#
#   ###################
#   Stap 16F Powershell Azure
#   Wordt alleen uitgevoerd indien IP versie 4 adres voldoet aan voorwaarden 
#   ###################
#
#

# Alle IPv4-adressen van actieve netwerkinterfaces ophalen
$IPv4Addresses = Get-NetIPAddress -AddressFamily IPv4 |
    Where-Object {
        $_.IPAddress -ne '127.0.0.1' -and
        $_.PrefixOrigin -ne 'WellKnown'
    }

$MatchingIP = $IPv4Addresses | Where-Object {
    $Octets = $_.IPAddress.Split('.')

    $Octets[0] -eq '10' -and (
        $Octets[1] -eq '14' -or
        $Octets[1] -eq '23' -or
        $Octets[1] -eq '41'
    )
}

if ($MatchingIP) {
    #
    Write-Host "[Powershell 5] Installeren Azure modules (duurt soms erg lang) ..."
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted 
    Install-Module -Name Az -Repository PSGallery -Force
    #
    Write-Host "[Powershell 7] Installeren Azure modules (duurt soms erg lang) ..."
    pwsh -c Set-PSRepository -Name PSGallery -InstallationPolicy Trusted 
    pwsh -c Install-Module -Name Az -Repository PSGallery -Force
} 
#
#
#   ###################
#   Stap 16G Powershell Help
#   ###################
#
#

Write-Host "[Powershell] Help bijwerken ..."

Update-Help -force -ea 0

pwsh -c Update-Help -force -ea 0


#
#
cmd /c "echo Deel 4 Powershell Configuratie is gereed >> c:\Scripts\VM-OOBE-LOG.txt
#
#
#   ###########################################
#   Stap 17 Powershell Scripts Downloaden 
#   ###########################################
#
#
#   #################
#   Stap 17A AD DS DOMAIN JOINER Downloaden
#   #################
#
#
mkdir "C:\Scripts" -Force | Out-Null
Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/PS-Windows-Active-Directory/WC11-WS22-SXN-AD-Join.ps1 -OutFile "C:\Scripts\WC11-WS22-SXN-AD-Join.ps1"
#
#
#
#   #################
#   Stap 17B VM-OOBE-WinGet-User Downloaden
#   ##################
#
#
mkdir "C:\Scripts" -Force | Out-Null
Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/CMD-Windows-WinGET-Install-Apps/VM-OOBE-WinGet-User.ps1 -OutFile "C:\Scripts\VM-OOBE-WinGet-User.ps1"
#
#
#   ##################
#   Stap 17C TutSOFT SF ADDS
#   #################
#
#
mkdir "C:\Scripts" -Force | Out-Null
Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/PS-Windows-Active-Directory/WS22-SXN-AD-DC-Install.ps1 -OutFile "C:\Scripts\WS22-SXN-AD-DC-Install.ps1" 
Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/PS-Windows-Active-Directory/WS22-SXN-AD-DC-Promote.ps1 -OutFile "C:\Scripts\WS22-SXN-AD-DC-Promote.ps1" 
#   Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/PS-Windows-Active-Directory/WS22-SXN-AD-DC-Import-Users.ps1 -OutFile "C:\Scripts\WS22-SXN-AD-DC-Import-Users.ps1" 
Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/PS-Windows-Active-Directory/WS22-SXN-AD-DC-Import-Users-OU.ps1 -OutFile "C:\Scripts\WS22-SXN-AD-DC-Import-Users-OU.ps1" 
Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/PS-Windows-Active-Directory/ad_gebruikers.csv -OutFile "C:\Scripts\ad_gebruikers.csv" 
#
#
cmd /c "echo Deel 5 Scripts downloaden is gereed >> c:\Scripts\VM-OOBE-LOG.txt
#
#
#   ###########################################
#   Stap 18 Windows Server SSH en WINRM 
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
    cmd /c "echo Deel 6 Windows Server SSH en WinRM is gereed >> c:\Scripts\VM-OOBE-LOG.txt
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
#   ###################
#   Windows Firewall WinRM Config 
#   ###################
#
#
Try { 
    Write-Host "[Windows Firewall] WinRM HTTP configureren ..." -ForegroundColor White
    Set-NetFirewallRule -Name 'WINRM-HTTP-In-TCP' -RemoteAddress Any
}
Catch {
    Write-Host "[Windows Firewall] WinRM HTTP Configuratie is niet gelukt"
} 
#
#
Try {
    Write-Host "[Windows Firewall] WinRM HTTP configureren ..." -ForegroundColor White
    New-NetFirewallRule `
    -Name "WinRM HTTPS" `
    -DisplayName "WinRM HTTPS" `
    -Direction Inbound `
    -Protocol TCP `
    -LocalPort 5986 `
    -Action Allow `
    -Profile Domain,Private `
    -Service WinRM
} 
Catch {
    Write-Host "[Windows Firewall] WinRM HTTPS Configuratie is niet gelukt"
} 
#

#
#
#   ###########################################
#   Installeren Windows Updates
#   ###########################################
#
#
#   x
#   x
#   x
#
#

Get-WindowsUpdate -Install -AcceptAll -IgnoreReboot

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
#       "Out of Box Experience Configurator",
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