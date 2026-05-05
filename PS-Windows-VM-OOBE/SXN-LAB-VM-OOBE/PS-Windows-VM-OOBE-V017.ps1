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
#   VERSION 017
#   04 MEI 2026
#
#
Clear-Host
#
#
Write-Host "Out of Box Experience (OOBE) configurator" -ForegroundColor Green
#
#
#   #######################################################################
#   Bepalen Windows Desktop of Windows Server 
#   #######################################################################
#
#
$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
#
if ($osInfo.ProductType -ne 1) {
    Write-Host "Windows Server" -ForegroundColor Green
}
else {
    Write-Host "Windows Desktop" -ForegroundColor Green
}
#
#
#   #######################################################################
#   TutSOFT OOBE Directory aanmaken 
#   #######################################################################
#
#
mkdir "$env:USERPROFILE\.TutSOFT" -Force | Out-Null
mkdir "$env:USERPROFILE\.TutSOFT\OOBE" -Force | Out-Null
#
#
#   #######################################################################
#   Alle Windows 
#   #######################################################################
#
#
#   ###########################################
#   Windows Services
#   ###########################################
#
#
Write-Host "Windows Services stoppen en uitschakelen om geheugen te besparen ..." -ForegroundColor Gray
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
#   ###########################################
#   WinGET Deel 1 van 2 
#   ###########################################
#
#
Write-Host "WinGET Installeren ..."  -ForegroundColor Gray
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
#   #######################################################################
#   Windows Server
#   #######################################################################
#
#
$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
if ($osInfo.ProductType -ne 1) {
    #
    #
    #   ###########################################
    #   Windows SSH Server
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
    #   Windows WinRM
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
    #   ###########################################
    #   TutSOFT Configuratie scripts en bestanden 
    #   ###########################################
    #
    #
    Write-Host "Configuratie scripts downloaden vanaf GitHub" -ForegroundColor Yellow
    #
    #   ##################
    #   TutSOFT SF ADDS
    #   #################
    #
    #
    Write-Host 'Active Directory Domain Services Scripts en bestanden'  -ForegroundColor White
    #
    mkdir "$env:USERPROFILE\Desktop\ADDS" -Force | Out-Null
    Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/PS-Windows-Active-Directory/WS22-AD-DC-Install.ps1 -OutFile "$env:USERPROFILE\Desktop\ADDS\WS22-AD-DC-Install.ps1"
    Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/PS-Windows-Active-Directory/WS22-AD-DC-Promote.ps1 -OutFile "$env:USERPROFILE\Desktop\ADDS\WS22-AD-DC-Promote.ps1"
    Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/PS-Windows-Active-Directory/WS22-AD-DC-Import-Users.ps1 -OutFile "$env:USERPROFILE\Desktop\ADDS\WS22-AD-DC-Import-Users.ps1"
    Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/PS-Windows-Active-Directory/ad_gebruikers.csv -OutFile "$env:USERPROFILE\Desktop\ADDS\ad_gebruikers.csv"
    #
    #
} 
#
#
#   #######################################################################
#   WinGET Deel 2 van 2 Licentie activeren
#   #######################################################################
#
#
Write-Host "[WinGet] Licentie activeren ..." -ForegroundColor White
#
cmd.exe /c "echo Y | winget list"
#
#
#
#   #######################################################################
#   WinGET Install
#   #######################################################################
#
#
Write-Host "[WinGet] Applicaties installeren ..." -ForegroundColor White
#
#
#   ###########################################
#   cURL
#   ###########################################
#
Write-Host "[WinGet] CURL" -ForegroundColor Gray
#
winget Install cURL.cURL
#
#
#   ###########################################
#   NanaZIP
#   ###########################################
#
Write-Host "[WinGet] M2Team.NanaZip" -ForegroundColor Gray
#
winget install M2Team.NanaZip
#
#
#   ###########################################
#   GNU Nano
#   ###########################################
#
Write-Host "[WinGet] GNU Nano" -ForegroundColor Gray
#
winget install GNU.Nano
#
#
#   ###########################################
#   NotePad++
#   ###########################################
#
Write-Host "[WinGet] NotePad++" -ForegroundColor Gray
#
winget install Notepad++.Notepad++
#
#
#   ###########################################
#   PatchMyPC
#   ###########################################
#
Write-Host "[WinGet] PatchMyPC" -ForegroundColor Gray
#
winget Install PatchMyPC.PatchMyPC
#
#
#   ###########################################
#   Powershell 7
#   ###########################################
#
Write-Host "[WinGET] Powershell 7" -ForegroundColor Gray
#
winget install Microsoft.Powershell
#
#
#   ###########################################
#   Rammap
#   ###########################################
#
Write-Host "[WinGET] Microsoft.Sysinternals.RAMMap" -ForegroundColor Gray
#
winget install Microsoft.Sysinternals.RAMMap
#
#
#   ###########################################
#   Windows Terminal
#   ###########################################
#
Write-Host "[WinGet] Microsoft Windows Terminal" -ForegroundColor Gray
#
winget install Microsoft.WindowsTerminal
#
#
#   ###########################################
#   UniGETUI
#   ###########################################
#
Write-Host "[WinGet] UniGetUI" -ForegroundColor Gray
#
winget Install Devolutions.UniGetUI
#
#
#   ###########################################
#   WinGET alles bijwerken
#   ###########################################
#
Write-Host "[WinGet] Alles bijwerken" -ForegroundColor Gray
#
winget update --all
#
#
#   #######################################################################
#   Powershell 7 Remote
#   #######################################################################
#
#
Write-Host "[Powershell 7] Remote configureren ..." -ForegroundColor White
#
pwsh -c Enable-PSRemoting -Force
pwsh -c Set-NetFirewallRule -Name 'WINRM-HTTP-In-TCP' -RemoteAddress Any
#   pwsh -c Set-NetFirewallRule -Name 'WINRM-HTTPS-In-TCP' -RemoteAddress Any
#
#
#   #######################################################################
#   VMWare Tools
#   #######################################################################
#
#
Write-Host "VMware Tools" -ForegroundColor White
#
#
$registryPath = "HKLM:\SOFTWARE\VMware, Inc.\VMware Tools"
#
if (-not (Test-Path -Path $registryPath)) {
    #
    Write-Host "[VMware Tools] Niet aangetroffen ..." -ForegroundColor Gray
    #
    Start-Process -FilePath "c:\vmware-tools\setup.exe" "/s", "/v/qn", "REBOOT=ReallySuppress", "EULAS_AGREED=1" -Wait
    #
}
else {
        Write-Host "[VMware Tools] Aanwezig ..." -ForegroundColor Gray
}
#
#
#   ###########################################
#   IP Adres en DNS Instellingen 
#   ###########################################
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
Add-Type -AssemblyName System.Windows.Forms

[System.Windows.Forms.MessageBox]::Show(
    "Virtuele machine is klaar voor gebruik !",
    "Scripting met Powershell",
    [System.Windows.Forms.MessageBoxButtons]::OK,
    [System.Windows.Forms.MessageBoxIcon]::Information
)
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
#   #######################################################################
#   EINDE VM OOBE SCRIPT
#   #######################################################################
#
#
Write-Host "Einde Script ..." -ForegroundColor Yellow
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