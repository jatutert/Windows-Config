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
#   VERSION 015
#   DATUM   27 ARPIL 2026
#
#
#   Channel Canary
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
    mkdir "$env:USERPROFILE\Downloads\vmware" -Force | Out-Null
    $VMWARE_Tools_Installer = "$env:USERPROFILE\Downloads\vmware\VMware-tools-Windows-x64.exe"
    #
    Write-Host "[VMware Tools] Downloaden mbv Curl..."
    #
    curl.exe --parallel --parallel-max 4 -o "$VMWARE_Tools_Installer" "https://packages.vmware.com/tools/releases/13.0.10/x64/VMware-tools-13.0.10-25056151-x64.exe" 
    #
    $timeout = 0
    #
    while (!(Test-Path $$VMWARE_Tools_Installer) -and $timeout -lt 10) {
        Start-Sleep -Seconds 1
        $timeout++
    }
    #
    if ((Get-Item $VMWARE_Tools_Installer ).Length -gt 0) {
        Write-Host "[VMware Tools] Installeren ..."
        Start-Process -FilePath $VMWARE_Tools_Installer -ArgumentList "/s", "/v/qn", "REBOOT=ReallySuppress", "EULAS_AGREED=1" -Wait
    }
    #
}
else {
        Write-Host "[VMware Tools] Aanwezig ..." -ForegroundColor Gray
}
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