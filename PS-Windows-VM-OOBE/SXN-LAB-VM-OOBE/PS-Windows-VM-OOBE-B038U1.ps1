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
#   LET OP
#   Configuratie van Powershell versie 7 wordt NIET meer gedaan vanwege foutmelding No applicable license found bij aanroep pwsh
#
#
#   ###############################################################################
#   Vullen variabelen
#   ###############################################################################
#
$OOBECVersion    = "1"
$OOBECBuild      = "038"
$OOBECUpdate     =  "1"
$OOBECChannel    = "Canary"
$OOBECBuildDate  = "27 juli 2026"
#
[int] $stappenteller=0
#
#   ###############################################################################
#   Changelog
#   ###############################################################################
#
#
#   26juli  37  4   Introductie Write Log functie 
#   27juli  38  0   Stappenteller door middel van variabele en Implementatie delen en nieuwe volgorde 
#   27juli  38  1   Bugfixes na eerste run B38
#
#
#   ###############################################################################
#   Definitie Functies
#   ###############################################################################
#
function Write-Log {
    param(
        [string]$Message,
        [string]$LogFile = "C:\Scripts\VM-OOBE-LOG.txt"
    )

    $TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $LogFile -Value "$TimeStamp - $Message"
}
#
#   ###############################################################################
#   Welkom
#   ###############################################################################
#
Clear-Host
#
#
Write-Host "Out of Box Experience (OOBE) configurator" -ForegroundColor Blue
Write-Log "Out of Box Experience (OOBE) configurator"
Write-Host "Version $OOBECVersion Build $OOBECBuild Update $OOBECUpdate Channel $OOBECChannel" -ForegroundColor Blue
Write-Log "Version $OOBECVersion Build $OOBECBuild Update $OOBECUpdate Channel $OOBECChannel"
Write-Host "Created by TutSOFT for personal and/or educational use" -ForegroundColor Blue
Write-Log "Created by TutSOFT for personal and/or educational use"
#
#   ###############################################################################
#   Initialisatie
#   ###############################################################################
#
#   ###########################################
#   Bepalen Windows Desktop of Windows Server 
#   ###########################################
#
#
Write-Host "STAP $stappenteller A Bepalen Windows Desktop of Windows Server" -ForegroundColor Gray
Write-Log "STAP $stappenteller A Bepalen Windows Desktop of Windows Server"
#
$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
#
if ($osInfo.ProductType -ne 1) {
    Write-Host "This virtual machine runs Windows Server" -ForegroundColor Gray
    Write-Log "This virtual machine runs Windows Server"
}
else {
    Write-Host "This virtual machine runs Windows Desktop" -ForegroundColor Gray
    Write-Log "This virtual machine runs Windows Desktop"
}
#
#
#   ###########################################
#   Hulpdirectories aanmaken
#   ###########################################
#
#
Write-Host "STAP $stappenteller B Hulpdirectories maken" -ForegroundColor Gray
Write-Log "STAP $stappenteller B Hulpdirectories maken"
#
Try { 
    mkdir "$env:USERPROFILE\.TutSOFT" -Force | Out-Null
    mkdir "$env:USERPROFILE\.TutSOFT\OOBE" -Force | Out-Null
    mkdir "C:\Scripts" -Force | Out-Null
}
Catch {
    Write-Host "Directories konden niet worden gemaakt!" -ForegroundColor Red
    Write-Log "Directories konden niet worden gemaakt!"
}
#
#
#   ###########################################
#   Downloaden Script
#   ###########################################
#
#
Write-Host "STAP $stappenteller C Downloaden Script naar directory Scripts" -ForegroundColor Gray
Write-Log "STAP $stappenteller C Downloaden Script naar directory Scripts"
#
Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/PS-Windows-VM-OOBE/SXN-LAB-VM-OOBE/PS-Windows-VM-OOBE-Latest.ps1 -OutFile C:\Scripts\PS-Windows-VM-OOBE-Latest.ps1
#
#
#   ###############################################################################
#   DEEL 1 Virtuele Machine 
#   ###############################################################################
#
#
Write-Host "Deel 1 Virtuele Machine" -ForegroundColor White
Write-Log "Deel 1 Virtuele Machine"
#
#
$stappenteller++
#
#
#   ###########################################
#   VMWare Tools installeren zodat verbinding met de buitenwereld aanwezig is voor de huidige VM
#   ###########################################
#
#
$registryPath = "HKLM:\SOFTWARE\VMware, Inc.\VMware Tools"
#
if (-not (Test-Path -Path $registryPath)) {
    #
    Write-Host "STAP $stappenteller [VMware Tools] Installeren ..." -ForegroundColor Gray
    Write-Log "STAP $stappenteller [VMware Tools] Installeren ..."
    #
    Try { 
        Start-Process -FilePath "c:\vmware-tools\setup.exe" "/s", "/v/qn", "REBOOT=ReallySuppress", "EULAS_AGREED=1" -Wait
    }
    Catch {
        Write-Host "STAP $stappenteller [VMware Tools] gaf een fout" -ForegroundColor Red
        Write-Log "STAP $stappenteller [VMware Tools] gaf een fout"
    } 
    #
}
else {
        Write-Host "STAP $stappenteller [VMware Tools] Installatie is niet noodzakelijk ..." -ForegroundColor Gray
        Write-Log "STAP $stappenteller [VMware Tools] Installatie is niet noodzakelijk"
}
#
#
#   ###############################################################################
#   DEEL 2 Windows
#   ###############################################################################
#
#
Write-Host "Deel 2 Windows" -ForegroundColor White
Write-Log "Deel 2 Windows"
#
#
$stappenteller++
#
#
#   ######################
#   DEEL 2 Windows Gebruiker Administrator vrijgeven en instellen als default gebruiker
#   ######################
#
#
$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
if ($osInfo.ProductType -ne 1) {
    #
    #
    Write-Host "Stap $stappelteller A Gebruiker Administrator op Windows Server vrijgeven"   -ForegroundColor Gray
    Write-Log "Stap $stappenteller A Gebruiker Administrator op Windows Server vrijgeven"
    #
    Try {
        Enable-LocalUser -Name "Administrator"
        $Password = ConvertTo-SecureString "!@WACHTwoord#$" -AsPlainText -Force
        Set-LocalUser -Name "Administrator" -Password $Password
    }
    Catch {
        Write-Host "Gebruiker Administrator vrijgeven gaf een fout" -ForegroundColor Red
        Write-Log "Gebruiker Administrator vrijgeven gaf een fout"
    } 
    #
    Write-Host "Stap $stappenteller B Automatische inlog aanpassen van labadmin naar administrator"   -ForegroundColor Gray
    Write-Log "Stap $stappelteller B Automatische inlog aanpassen van labadmin naar administrator"
    #
    Try {
        $RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
        Set-ItemProperty -Path $RegPath -Name "AutoAdminLogon" -Value "1"
        Set-ItemProperty -Path $RegPath -Name "DefaultUserName" -Value "Administrator"
        Set-ItemProperty -Path $RegPath -Name "DefaultPassword" -Value "!@WACHTwoord#$"
        Set-ItemProperty -Path $RegPath -Name "DefaultDomainName" -Value "."
    }
    Catch {
        Write-Host "Automatische inlog aanpassen van labadmin naar administrator gaf een fout" -ForegroundColor Red
        Write-Log "Automatische inlog aanpassen van labadmin naar administrator gaf een fout"
    } 
    #
}
#
#
$stappenteller++
#
#
#   ######################
#   DEEL 2 Windows Services Uitschakelen 
#   ######################
#
#
Write-Host "Stap $stappelteller Windows Services stoppen en ook uitschakelen om geheugen te besparen ..." -ForegroundColor Gray
Write-Log "Stap $stappelteller Windows Services stoppen en ook uitschakelen om geheugen te besparen ..."
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
$stappenteller++
#
#
#   ####################
#   DEEL 2 Windows Desktop Policies instellen 
#   ####################
#
#   Windows Desktop
#
$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
if ($osInfo.ProductType -eq 1) {

    Write-Host "Nieuwsfeed uitzetten Windows Desktop" -ForegroundColor Gray
    Write-Log "Nieuwsfeed uitzetten Windows Desktop gestart"

    New-Item -Path "HKLM:\Software\Policies\Microsoft\Dsh" -Force | Out-Null

    Set-ItemProperty `
        -Path "HKLM:\Software\Policies\Microsoft\Dsh" `
        -Name "AllowNewsAndInterests" `
        -Type DWord `
        -Value 0

}
#
#
#   ###############################################################################
#   DEEL 3 Netwerk 
#   ###############################################################################
#
#
#
Write-Host "Deel 3 Netwerk" -ForegroundColor White
Write-Log "Deel 3 Netwerk"
#
#
$stappenteller++
#
#
#   ######################
#   DEEL 3 Netwerk IP Adres en DNS Instellingen 
#   ######################
#
#
Write-Host "STAP $stappenteller IP-Adres en DNS-instellingen aanpassen" -ForegroundColor Gray
Write-Log "STAP $stappenteller IP-Adres en DNS-instellingen aanpassen gestart"
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

    Write-Host "Gevonden netwerkkaart:" -ForegroundColor Gray
    Write-Host "InterfaceIndex : $InterfaceIndex" -ForegroundColor Gray
    Write-Host "Huidig IP      : $CurrentIP" -ForegroundColor Gray
    Write-Log "Huidig IP      : $CurrentIP" -ForegroundColor Gray

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

        Write-Host "Nieuw IP-adres wordt: $NewIP" -ForegroundColor Gray

        #
        #   Bepalen huidige Gateway instelling
        #

        $Route = Get-NetRoute -InterfaceIndex $InterfaceIndex `
                            -DestinationPrefix "0.0.0.0/0" |
                Sort-Object RouteMetric |
                Select-Object -First 1
        if ($null -ne $Route) {
            $Gateway = $Route.NextHop
        }
        else {
            $Gateway = $null
        }

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

        Write-Host "STAP $stappenteller Netwerkconfiguratie voltooid."
    }
}
else {

    Write-Warning "Geen netwerkkaart gevonden met een IPv4-adres dat begint met 10." -ForegroundColor Red
    Write-Log "Geen netwerkkaart gevonden met een IPv4-adres dat begint met 10."
    Write-Warning "Netwerkinstellingen zijn niet gewijzigd." -ForegroundColor Red
    Write-Log "Netwerkinstellingen zijn niet gewijzigd."
    Write-Warning "Configureer de netwerkkaart handmatig indien nodig." -ForegroundColor Red
    Write-Log "Configureer de netwerkkaart handmatig indien nodig."

}
#
#
$stappenteller++
#
#   ######################
#   DEEL 3 Netwerk NIC 1 van Publiek naar Privaat zetten voor netwerkprofiel 
#   ######################
#
#
Write-Host "STAP $stappenteller Netwerkkaart 1 van Publiek naar Privaat zetten" -ForegroundColor Gray
Write-Log "STAP $stappenteller Netwerkkaart 1 van Publiek naar Privaat zetten gestart"
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
    Write-Host "STAP $stappenteller Netwerkkaart 1 van Publiek naar Privaat zetten gaf een fout" -ForegroundColor Red
    Write-Log "STAP $stappenteller Netwerkkaart 1 van Publiek naar Privaat zetten gaf een fout"
} 
#
#
$stappenteller++
#
#
#   ##############
#   DEEL 3 Windows Server SSH
#   ##############
#
#
$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
if ($osInfo.ProductType -ne 1) {
    #
    Write-Host "STAP $stappenteller [Windows Server] SSH Server installeren en configureren..."  -ForegroundColor Gray
    Write-Log "STAP $stappenteller [Windows Server] SSH Server installeren en configureren..."
    #
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
} 
#
#
$stappenteller++
#
#
#   ##############
#   DEEL 3 Windows Server WinRM
#   ##############
#
$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
if ($osInfo.ProductType -ne 1) {
    #
    Write-Host "STAP $stappenteller [Windows Server] WinRM Server installeren en configureren..."  -ForegroundColor Gray
    Write-Log "STAP $stappenteller [Windows Server] WinRM Server installeren en configureren..."
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
}
#
#
$stappenteller++
#
#
#   ##############
#   DEEL 3 Firewall SQL Server
#   ##############
#
#
$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
if ($osInfo.ProductType -ne 1) {
    #
    Write-Host "STAP $stappenteller Windows Firewall SQL Server poorten vrijgeven" -ForegroundColor Gray
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
$stappenteller++
#
#
#   ##############
#   DEEL 3 Firewall WinRM HTTP
#   ##############
#
#
Try { 
    Write-Host "STAP $stappenteller [Windows Firewall] WinRM HTTP configureren ..." -ForegroundColor Gray
    Write-Log "STAP $stappenteller [Windows Firewall] WinRM HTTP configureren ..."
    Set-NetFirewallRule -Name 'WINRM-HTTP-In-TCP' -RemoteAddress Any
}
Catch {
    Write-Host "STAP $stappenteller [Windows Firewall] WinRM HTTP Configuratie is niet gelukt" -ForegroundColor Red
    Write-Log "STAP $stappenteller [Windows Firewall] WinRM HTTP Configuratie is niet gelukt"
}
#
#
$stappenteller++
#
#
#   ##############
#   DEEL 3 Firewall WinRM HTTPS
#   ##############
#
#
Try {
    Write-Host "STAP $stappenteller [Windows Firewall] WinRM HTTP configureren ..." -ForegroundColor Gray
    Write-Log "STAP $stappenteller [Windows Firewall] WinRM HTTP configureren ..."
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
    Write-Host "STAP $stappenteller [Windows Firewall] WinRM HTTPS Configuratie is niet gelukt" -ForegroundColor Red
    Write-Log "STAP $stappenteller [Windows Firewall] WinRM HTTPS Configuratie is niet gelukt"
} 
#
#
#   ###############################################################################
#   DEEL 4 Applicaties installeren 
#   ###############################################################################
#
#
Write-Host "Deel 4 Applicaties installeren" -ForegroundColor White
Write-Log "Deel 4 Applicaties installeren"
#
#
$stappenteller++
#
#
#   ####################
#   DEEL 4 WinGET Installeren
#   ####################
#
#
Write-Host "STAP $stappenteller A [WinGET] Installeren ..."  -ForegroundColor Gray
Write-Log "STAP $stappenteller A [WinGET] Installeren gestart"
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
#   DEEL 4 WinGET Licentie Activeren
#   ####################
#
#
Write-Host "STAP $stappenteller B [WinGet] Licentie activeren ..." -ForegroundColor Gray
Write-Log "STAP $stappenteller B [WinGet] Licentie activeren gestart"
#
cmd.exe /c "echo Y | winget list"
#
#
#
$stappenteller++
#
#
#   ####################
#   DEEL 4 Installaties Runtimes
#   ####################
#
#
Write-Host "STAP $stappenteller Installatie Runtimes met behulp van WinGet gestart" -ForegroundColor Gray
Write-Log "STAP $stappenteller Installatie Runtimes met behulp van WinGet gestart"
#
#
#   ####################
#   DEEL 4 WinGET DotNET DesktopRuntime
#   ####################
#
#
Write-Host "STAP $stappenteller A DotNet Runtime installeren" -ForegroundColor Gray
Write-Log "STAP $stappenteller A DotNet Runtime installeren"
#
winget install Microsoft.DotNet.DesktopRuntime.8.x86 --scope machine --accept-package-agreements --accept-source-agreements
winget install Microsoft.DotNet.DesktopRuntime.8.x64 --scope machine --accept-package-agreements --accept-source-agreements
#
#
#   ####################
#   DEEL 4 WinGET VCRedist
#   ####################
#
#
Write-Host "STAP $stappenteller B Visual C Runtime installeren" -ForegroundColor Gray
Write-Log "STAP $stappenteller B Visual C Runtime installeren"
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
#
$stappenteller++
#
#
#   ###########################################
#   DEEL 4 WinGET Verwijderen Applicaties 
#   ###########################################
#
#
Write-Host "STAP $stappenteller Applicaties verwijderen Windows Desktop mbv Winget gestart" -ForegroundColor Gray
Write-Log "STAP $stappenteller Applicaties verwijderen Windows Desktop mbv WinGet gestart"
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
    Write-Host "STAP $stappenteller [WinGet] MS OneDrive verwijderen" -ForegroundColor Gray
    #
    winget uninstall Microsoft.OneDrive
    #
    #
    #   ####################
    #   Microsoft Outlook 
    #   ####################
    #
    #
    Write-Host "STAP $stappenteller [WinGet] MS Outlook verwijderen" -ForegroundColor Gray
    #
    winget uninstall 9NRX63209R7B
    #
    #
    #   ####################
    #   Microsoft Teams 
    #   ####################
    #
    #
    Write-Host "STAP $stappenteller [WinGet] MS Teams verwijderen" -ForegroundColor Gray
    #
    winget uninstall XP8BT8DW290MPQ
    winget uninstall Microsoft.Teams
    #
    #
} 
#
#
$stappenteller++
#
#
#   ###########################################
#   DEEL 4 WinGET Installeren Applicaties Windows Desktop
#   ###########################################
#
#
Write-Host "STAP $stappenteller Applicaties installeren mbv Winget op Windows Desktop gestart" -ForegroundColor Gray
Write-Log "STAP $stappenteller Applicaties installeren mbv Winget op Windows Desktop gestart"
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
    Write-Host "STAP $stappenteller A M2Team.NanaZip" -ForegroundColor Gray
    #
    winget install M2Team.NanaZip
    #   ####################
    #   PatchMyPC
    #   ####################
    #
    #
    Write-Host "STAP $stappenteller B PatchMyPC" -ForegroundColor Gray
    #
    winget Install PatchMyPC.PatchMyPC
    #
    #
    #   ####################
    #   PowerToys
    #   ####################
    #
    #
    Write-Host "STAP $stappenteller C Microsoft.PowerToys" -ForegroundColor Gray
    #
    winget install Microsoft.PowerToys
    #
    #
    #   ####################
    #   UniGETUI
    #   ####################
    #
    #
    Write-Host "STAP $stappenteller D UniGetUI" -ForegroundColor Gray
    #
    winget Install Devolutions.UniGetUI
    #
    #
    #   ####################
    #   Microsoft Visual Studio Code 
    #   ####################
    #
    #
    Write-Host "STAP $stappenteller E Microsoft Visual Studio Code" -ForegroundColor Gray
    #
    winget Install Microsoft.VisualStudioCode
}
#
#
#   ###########################################
#   DEEL 4 WinGET Installeren Applicaties Windows Desktop en Windows Server
#   ###########################################
#
#
Write-Host "STAP $stappenteller Applicaties installeren Windows Desktop en Windows Server gestart" -ForegroundColor Gray
Write-Log "STAP $stappenteller Applicaties installeren Windows Desktop en Windows Server gestart"
#
#
#   ####################
#   cURL
#   ####################
#
Write-Host "STAP $stappenteller F CURL" -ForegroundColor Gray
#
winget install cURL.cURL --scope machine --accept-package-agreements --accept-source-agreements
#
#
#   ####################
#   Microsoft.Edit
#   ####################
#
Write-Host "STAP $stappenteller G Microsoft.Edit" -ForegroundColor Gray
#
winget install Microsoft.Edit --scope machine --accept-package-agreements --accept-source-agreements
#
#
#   ####################
#   Mozilla Firefox
#   ####################
#
Write-Host "STAP $stappenteller H Mozilla.Firefox.nl" -ForegroundColor Gray
#
winget install Mozilla.Firefox.nl
#
#
#   ####################
#   GNU Nano
#   ####################
#
#
Write-Host "STAP $stappenteller I GNU Nano" -ForegroundColor Gray
#
winget install GNU.Nano --scope machine --accept-package-agreements --accept-source-agreements
#
#
#   ####################
#   NotePad++
#   ####################
#
#
Write-Host "STAP $stappenteller J NotePad++" -ForegroundColor Gray
#
winget install Notepad++.Notepad++ --scope machine --accept-package-agreements --accept-source-agreements
#
#
#   ####################
#   Microsoft.Sysinternals.RAMMap
#   ####################
#
#
Write-Host "STAP $stappenteller K Microsoft.Sysinternals.RAMMap" -ForegroundColor Gray
#
winget install Microsoft.Sysinternals.RAMMap --scope machine --accept-package-agreements --accept-source-agreements
#
#
#   ####################
#   Windows Terminal
#   ####################
#
#
Write-Host "STAP $stappenteller L Microsoft Windows Terminal (Huidige Gebruiker)" -ForegroundColor Gray
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
$stappenteller++
#
#
#   ####################
#   DEEL 4 WinGET Update Applicaties
#   ####################
#
#
#
Write-Host "STAP $stappenteller Winget update software" -ForegroundColor Gray
Write-Log "STAP $stappenteller Winget update software"
#
winget update --all
#
#
Write-Host "STAP $stappenteller Winget update software voltooid" -ForegroundColor Gray
Write-Log "STAP $stappenteller Winget update software voltooid"
#
#
#   ###############################################################################
#   DEEL 5 Powershell 
#   ###############################################################################
#
#
Write-Host "Deel 5 Powershell" -ForegroundColor White
Write-Log "Deel 5 Powershell"
#
#
$stappenteller++
#
#
#   ####################
#   DEEL 5 Powershell 7 installeren 
#   ####################
#
#
#   Windows Desktop
#
$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
if ($osInfo.ProductType -eq 1) {
    Write-Host "STAP stappenteller++ Powershell 7 installeren Windows Desktop" -ForegroundColor Gray
    #
    winget install Microsoft.Powershell --accept-package-agreements --accept-source-agreements
    #
}
#
#   Windows Server
#
$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
if ($osInfo.ProductType -ne 1) {
    Write-Host "STAP stappenteller++ Powershell 7 installeren Windows Server" -ForegroundColor Gray
    #
    winget install Microsoft.Powershell --scope machine --accept-package-agreements --accept-source-agreements
    #
}
#
#
$stappenteller++
#
#
#   ###########################################
#   DEEL 5 Powershell 5 en 7 klaarmaken voor gebruik
#   ###########################################
#
Write-Host "STAP $stappenteller Powershell klaarmaken voor gebruik gestart" -ForegroundColor Gray
Write-Log "STAP $stappenteller Powershell klaarmaken voor gebruik gestart"
#
#
#   ###################
#   DEEL 5 Powershell 5 en 7 Powershell Gallery vertrouwen
#   ###################
#
#
#   Powershell 5 Powershell Gallery vetrouwen 
Write-Host "STAP $stappenteller Powershell 5 Powershell Gallery vertrouwen" -ForegroundColor Gray
Write-Log "STAP $stappenteller Powershell 5 Powershell Gallery vertrouwen"
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
#
#   Powershell 7 Powershell Gallery vertrouwen
#   Write-Host "STAP $stappenteller Powershell 7 Powershell Gallery vertrouwen" -ForegroundColor Gray
#   Write-Log "STAP $stappenteller Powershell 7 Powershell Gallery vertrouwen"
#   pwsh -c Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
#
#
$stappenteller++
#
#
#   ###################
#   DEEL 5 Powershell 5 en 7 TLS versie 1.2  
#   ###################
#
#
#   TLS protocol versie 1.2 
Try {
    Write-Host "STAP $stappenteller [Powershell 5] TLS Protocol versie 1.2 instellen" -ForegroundColor Gray
    Write-Log "STAP $stappenteller [Powershell 5} TLS Protocol versie 1.2 instellen"
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
}
Catch {
    Write-Host "STAP $stappenteller [Powershell 5] TLS Protocol versie 1.2 instellen zorgde voor een error" -ForegroundColor Red
    Write-Log "STAP $stappenteller [Powershell 5] TLS Protocol versie 1.2 instellen zorgde voor een error"
} 
#
#   Try {
#       pwsh -c [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
#   }
#   Catch {
#       Write-Host "[Powershell 7] TLS Protocol versie 1.2 instellen zorgde voor een error" -ForegroundColor Red
#   } 
#
#
$stappenteller++
#
#
#   ###################
#   DEEL 5 Powershell NuGet provider en PowerShellGet bijwerken
#   ###################
#
#
#   https://oneuptime.com/blog/post/2026-02-16-how-to-troubleshoot-azure-powershell-module-installation-and-authentication-errors/view
#
#
Try { 
    Write-Host "STAP $stappenteller [Powershell 5] NuGet provider en PowerShellGet bijwerken" -ForegroundColor Gray
    Write-Log "STAP $stappenteller [Powershell 5] NuGet provider en PowerShellGet bijwerken" 
    #
    Install-Module -Name PowerShellGet -AllowClobber -Force
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force 
}
Catch {
    Write-Host "STAP $stappenteller [Powershell 5] NuGet Provider en Powershell Get bijwerken is niet gelukt" -ForegroundColor Red
    Write-Log "STAP $stappenteller [Powershell 5] NuGet Provider en Powershell Get bijwerken is niet gelukt"
} 
#
#
#   Try { 
#       Write-Host "[Powershell 7] NuGet provider en PowerShellGet bijwerken" -ForegroundColor Gray
#       pwsh -c Install-Module -Name PowerShellGet -Force -AllowClobber -AcceptLicense -Confirm:$false
#       pwsh -c Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Confirm:$false
#   }
#   Catch {
#      Write-Host "[Powershell 7] NuGet Provider en Powershell Get bijwerken is niet gelukt" -ForegroundColor Red
#   } 
#
#
$stappenteller++
#
#
#   ###################
#   DEEL 5 Powershell Windows Updates modules installeren
#   ###################
#
#
Try { 
    Write-Host "STAP $stappenteller [Powershell 5] Windows Update modules installeren" -ForegroundColor Gray
    Write-Log "STAP $stappenteller [Powershell 5] Windows Update modules installeren"
    Install-Module -Name PSWindowsUpdate -Force
    Import-Module PSWindowsUpdate
} 
Catch {
    Write-Host "STAP $stappenteller [Powershell 5] Windows Update modules installeren is niet gelukt" -ForegroundColor Red
    Write-Log "STAP $stappenteller [Powershell 5] Windows Update modules installeren is niet gelukt"
} 
#
#
#   Try { 
#       pwsh -c Install-Module -Name PSWindowsUpdate -Force
#       pwsh -c Import-Module PSWindowsUpdate
#   } 
#   Catch {
#       Write-Host "[Powershell 7] Powershell Module Windows Update installatie is niet gelukt"
#   } 
#
#
$stappenteller++
#
#
#   ###################
#   DEEL 5 Powershell Remote Config 
#   ###################
#
#
Try { 
    Write-Host "STAP $stappenteller++ [Powershell 5] Remote configureren ..." -ForegroundColor Gray
    Enable-PSRemoting -Force
} 
Catch {
    Write-Host "STAP $stappenteller++ [Powershell 5] Remote configureren is niet gelukt" -ForegroundColor Red
    Write-Log "STAP $stappenteller++ [Powershell 5] Remote configureren is niet gelukt"
} 
#
#
#   Try { 
#       Write-Host "[Powershell 7] Remote configureren ..." -ForegroundColor White
#       pwsh -c Enable-PSRemoting -Force
#   } 
#   Catch {
#       Write-Host "Powershell 7 Remote Config is niet gelukt"
#   } 
#
#
$stappenteller++
#
#
#   ###################
#   DEEL 5 Powershell 5 en 7 Active Directory
#   ###################
#
#   https://www.varonis.com/blog/powershell-active-directory-module
#
#   ################
#   Windows Desktop
#   ################
#
#   https://learn.microsoft.com/en-us/windows-server/administration/install-remote-server-administration-tools?tabs=windows-powershell%2Cpowershell&pivots=windows-client-11
#
$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
if ($osInfo.ProductType -eq 1) {
    #
    Write-Host "STAP $stappenteller [Powershell 5] Windows Desktop Active Directory modules activeren (duurt soms erg lang) ..." -ForegroundColor Gray
    Write-Log "STAP $stappenteller [Powershell 5] Windows Desktop Active Directory modules activeren (duurt soms erg lang) ..."
    #
    Add-WindowsCapability -Online -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0
    #
    #   Write-Host "STAP $stappenteller [Powershell 7] Active Directory modules activeren (duurt soms erg lang) ..." -ForegroundColor White
    #   Write-Log "STAP $stappenteller [Powershell 7] Active Directory modules activeren (duurt soms erg lang) ..."
    #
    #   pwsh -c Add-WindowsCapability -Online -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0
    #
}
#
#   ################
#   Windows Server
#   ################
#
#   https://learn.microsoft.com/en-us/windows-server/administration/install-remote-server-administration-tools?tabs=windows-powershell%2Cpowershell&pivots=windows-server-2022
#
$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
if ($osInfo.ProductType -ne 1) {
    #
    Write-Host "STAP $stappenteller [Powershell 5] Windows Server Active Directory modules activeren (duurt soms erg lang) ..." -ForegroundColor Gray
    Write-Log "STAP $stappenteller [Powershell 5] Windows Server Active Directory modules activeren (duurt soms erg lang) ..."
    #
    Install-WindowsFeature -Name "RSAT-AD-PowerShell" -IncludeAllSubFeature
    #
}
#
#
$stappenteller++
#
#
#
#   ###################
#   DEEL 5 Powershell Azure
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
    Write-Host "STAP $stappenteller [Powershell 5] Installeren Azure modules (duurt soms erg lang) ..." -ForegroundColor Gray
    Write-Log "STAP $stappenteller [Powershell 5] Installeren Azure modules (duurt soms erg lang) ..."
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted 
    Install-Module -Name Az -Repository PSGallery -Force
    #
    #   Write-Host "STAP $stappenteller [Powershell 7] Installeren Azure modules (duurt soms erg lang) ..."
    #   Write-Log "STAP $stappenteller [Powershell 7] Installeren Azure modules (duurt soms erg lang) ..."
    #   pwsh -c Set-PSRepository -Name PSGallery -InstallationPolicy Trusted 
    #   pwsh -c Install-Module -Name Az -Repository PSGallery -Force
} 
#
#
$stappenteller++
#
#
#   ###################
#   DEEL 5 Powershell Help
#   ###################
#
#
Write-Host "STAP $stappenteller [Powershell 5] Help bijwerken ..." -ForegroundColor Gray
Write-Log "STAP $stappenteller [Powershell 5] Help bijwerken ..."
Update-Help -force -ea 0
#
#
#   Write-Host "STAP $stappenteller [Powershell 5] Help bijwerken ..."
#   Write-Log "STAP $stappenteller [Powershell 5] Help bijwerken ..."
#   pwsh -c Update-Help -force -ea 0
#
#
#   ###########################################
#   DEEL 6 TutSOFT Scripts Downloaden 
#   ###########################################
#
#
Write-Host "Deel 6 Script Downloaden" -ForegroundColor White
Write-Log "Deel 6 Script Downloaden"
#
#
$stappenteller++
#
#
#   #################
#   AD DS DOMAIN JOINER Downloaden
#   #################
#
#
Write-Host "STAP $stappenteller A AD DS Domain Joiner downloaden" -ForegroundColor Gray
Write-Log "STAP $stappenteller A AD DS Domain Joiner downloaden"
mkdir "C:\Scripts" -Force | Out-Null
Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/PS-Windows-Active-Directory/WC11-WS22-SXN-AD-Join.ps1 -OutFile "C:\Scripts\WC11-WS22-SXN-AD-Join.ps1"
#
#
$stappenteller++
#
#
#   #################
#   VM-OOBE-WinGet-User Downloaden
#   ##################
#
#
Write-Host "STAP $stappenteller B VM OOBE WinGet User downloaden" -ForegroundColor Gray
Write-Log "STAP $stappenteller B VM OOBE WinGet User downloaden"
mkdir "C:\Scripts" -Force | Out-Null
Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/CMD-Windows-WinGET-Install-Apps/VM-OOBE-WinGet-User.ps1 -OutFile "C:\Scripts\VM-OOBE-WinGet-User.ps1"
#
#
$stappenteller++
#
#
#   ##################
#   AD DS DC Configuratie
#   #################
#
#
Write-Host "STAP $stappenteller C AD DS DC Configuratie scripts downloaden" -ForegroundColor Gray
Write-Log "STAP $stappenteller C AD DS DC Configuratie scripts downloaden"
mkdir "C:\Scripts" -Force | Out-Null
Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/PS-Windows-Active-Directory/WS22-SXN-AD-DC-01-Install.ps1.ps1 -OutFile "C:\Scripts\WS22-SXN-AD-DC-01-Install.ps1.ps1" 
Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/PS-Windows-Active-Directory/WS22-SXN-AD-DC-01-Promote.ps1.ps1 -OutFile "C:\Scripts\WS22-SXN-AD-DC-01-Promote.ps1.ps1" 
#   Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/PS-Windows-Active-Directory/WS22-SXN-AD-DC-Import-Users.ps1 -OutFile "C:\Scripts\WS22-SXN-AD-DC-Import-Users.ps1" 
Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/PS-Windows-Active-Directory/WS22-SXN-AD-DC-Import-Users-OU.ps1 -OutFile "C:\Scripts\WS22-SXN-AD-DC-Import-Users-OU.ps1" 
Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/PS-Windows-Active-Directory/ad_gebruikers.csv -OutFile "C:\Scripts\ad_gebruikers.csv" 
#
#
#   ###########################################
#   DEEL 7 Windows Updaten 
#   ###########################################
#
#
Write-Host "Windows Updaten" -ForegroundColor White
Write-Log "Windows Updaten"
#
#
$stappenteller++
#
#
Write-Host "STAP $stappenteller Windows Updates installeren" -ForegroundColor Gray
Write-Log "STAP $stappenteller Windows Updates installeren"
Get-WindowsUpdate -Install -AcceptAll -IgnoreReboot | Tee-Object -FilePath "C:\Scripts\WindowsUpdate.log" -Append
#
#
#   ###########################################
#   DEEL 8 VOOR TOEKOMSTIG GEBRUIK
#   ###########################################
#
#
#   ###########################################
#   DEEL 9 VOOR TOEKOMSTIG GEBRUIK
#   ###########################################
#
#
#   ###########################################
#   DEEL 10 VOOR TOEKOMSTIG GEBRUIK
#   ###########################################
#
#
#   ###########################################
#   DEEL 99 Herstarten Virtuele machine
#   ###########################################
#
#
Write-Host "Deel 99 Herstarten Virtuele Machine"
Write-Log "Deel 99 Herstarten Virtuele Machine"
#
#
$stappenteller++
#
#
Write-Host "99 All phases and steps have been completed. All that remains is a reboot ..." -ForegroundColor Blue
Write-Log "99 All phases and steps have been completed. All that remains is a reboot ..."
Write-Host "Found a bug ? Let me know by emailing me at j.a.tutert@saxion.nl" -ForegroundColor Blue
Write-Log "Found a bug ? Let me know by emailing me at j.a.tutert@saxion.nl"
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