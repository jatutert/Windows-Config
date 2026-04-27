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
#   Out of Box Experience 
#
#
#   For Personal and/or Education Use Only ! 
#
#
#   VERSION 014
#   DATUM   22 ARPIL 2026
#
#
#   Channel Canary
#
#
Clear-Host
#
#
#   #######################################################################
#   Bepalen Windows Desktop of Windows Server 
#   #######################################################################
#
$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
#
#   #######################################################################
#   TutSOFT Windows Register Sleutel aanmaken
#   #######################################################################
#
Write-Host "[1/15] Registersleutel aanmaken ..." -ForegroundColor Yellow
#
New-Item -Path "HKCU:\Software\TutSOFT" -Force | Out-Null
#
#
#   #######################################################################
#   TutSOFT OOBE Directory aanmaken 
#   #######################################################################
#
Write-Host "[2/15] Script directories aanmaken ..." -ForegroundColor Yellow
#
mkdir "$env:USERPROFILE\.TutSOFT" -Force | Out-Null
mkdir "$env:USERPROFILE\.TutSOFT\OOBE" -Force | Out-Null
#
New-ItemProperty -Path "HKCU:\Software\TutSOFT" -Name "OOBE Directories" -Value 1 -PropertyType DWord -Force | Out-Null
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
Write-Host "Windows Services stoppen en uitschakelen..." -ForegroundColor Yellow
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
New-ItemProperty -Path "HKCU:\Software\TutSOFT" -Name "Windows Services" -Value 1 -PropertyType DWord -Force | Out-Null
#
#
#   ###########################################
#   WinGET Deel 1 van 2 
#   ###########################################
#
#
Write-Host "WinGET Installeren ..." -ForegroundColor Yellow
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
New-ItemProperty -Path "HKCU:\Software\TutSOFT" -Name "Winget Install" -Value 1 -PropertyType DWord -Force | Out-Null
#
#
#   #######################################################################
#   Windows Server
#   #######################################################################
#
if ($osInfo.ProductType -ne 1) {
    #
    #
    #   ###########################################
    #   Windows SSH Server
    #   ###########################################
    #
    #
    Write-Host "SSH Server installeren en configureren..." -ForegroundColor Yellow
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
    New-ItemProperty -Path "HKCU:\Software\TutSOFT" -Name "Windows SSH" -Value 1 -PropertyType DWord -Force | Out-Null
    #
    #
    #   ###########################################
    #   Windows WinRM
    #   ###########################################
    #
    #
    Write-Host "Windows WinRM service activeren en configureren..." -ForegroundColor Yellow
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
    New-ItemProperty -Path "HKCU:\Software\TutSOFT" -Name "Windows WinRM" -Value 1 -PropertyType DWord -Force | Out-Null
    #
    #
    #   ###########################################
    #   TutSOFT Configuratie scripts en bestanden 
    #   ###########################################
    #
    #
    Write-Host "[14/15] Configuratie scripts downloaden ..." -ForegroundColor Yellow
    #
    #   ##################
    #   TutSOFT SF ADDS
    #   #################
    #
    #
    Write-Host 'Active Directory Domain Services Scripts en bestanden'
    #
    mkdir "$env:USERPROFILE\Desktop\ADDS" -Force | Out-Null
    Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/PS-Windows-Active-Directory/WS22-AD-DC-Install.ps1 -OutFile "$env:USERPROFILE\Desktop\ADDS\WS22-AD-DC-Install.ps1"
    Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/PS-Windows-Active-Directory/WS22-AD-DC-Promote.ps1 -OutFile "$env:USERPROFILE\Desktop\ADDS\WS22-AD-DC-Promote.ps1"
    Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/PS-Windows-Active-Directory/WS22-AD-DC-Import-Users.ps1 -OutFile "$env:USERPROFILE\Desktop\ADDS\WS22-AD-DC-Import-Users.ps1"
    Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/PS-Windows-Active-Directory/ad_gebruikers.csv -OutFile "$env:USERPROFILE\Desktop\ADDS\ad_gebruikers.csv"
    #
    New-ItemProperty -Path "HKCU:\Software\TutSOFT" -Name "ADDS Scripts" -Value 1 -PropertyType DWord -Force | Out-Null
    #
    #
} 
#
#
#   #######################################################################
#   VMWare Tools
#   #######################################################################
#
#
$registryPath = "HKLM:\SOFTWARE\VMware, Inc.\VMware Tools"
#
if (-not (Test-Path -Path $registryPath)) {
    #
    Write-Host "[6/15] VMware Tools installeren ..." -ForegroundColor Yellow
    #
    mkdir "$env:USERPROFILE\Downloads\vmware" -Force | Out-Null
    $VMWARE_Tools_Installer = "$env:USERPROFILE\Downloads\vmware\VMware-tools-13.0.10-25056151-x64.exe"
    #
    Write-Host 'Downloading VMware Tools'
    #
    Invoke-WebRequest -URI https://packages.vmware.com/tools/releases/13.0.10/x64/VMware-tools-13.0.10-25056151-x64.exe -OutFile $VMWARE_Tools_Installer
    #
    $timeout = 0
    while (!(Test-Path $$VMWARE_Tools_Installer) -and $timeout -lt 10) {
        Start-Sleep -Seconds 1
        $timeout++
    }
    #
    if ((Get-Item $VMWARE_Tools_Installer ).Length -gt 0) {
        Write-Host 'Installing VMware Tools'
        Start-Process -FilePath $VMWARE_Tools_Installer -ArgumentList "/s", "/v/qn", "REBOOT=ReallySuppress", "EULAS_AGREED=1" -Wait
    }
    #
    New-ItemProperty -Path "HKCU:\Software\TutSOFT" -Name "VMware Tools" -Value 1 -PropertyType DWord -Force | Out-Null
    #
}
else {
        Write-Host "VMware Tools zijn al aanwezig. Geen actie nodig." -ForegroundColor Gray
}
#
#
#   #######################################################################
#   WinGET Deel 2 van 2 
#   #######################################################################
#
#
Write-Host "[7/15] WinGet Licensie activieren ..." -ForegroundColor Yellow
#
cmd.exe /c "echo Y | winget list"
#
New-ItemProperty -Path "HKCU:\Software\TutSOFT" -Name "Winget License" -Value 1 -PropertyType DWord -Force | Out-Null
#
#
#   #######################################################################
#   WinGET Powershell 7
#   #######################################################################
#
#
Write-Host "[8/15] Powershell 7 installeren ..." -ForegroundColor Yellow
#
winget install Microsoft.Powershell
#
New-ItemProperty -Path "HKCU:\Software\TutSOFT" -Name "Powershell 7 Install" -Value 1 -PropertyType DWord -Force | Out-Null
#
#   #######################################################################
#   Powershell 7 Remote
#   #######################################################################
#
#
Write-Host "[9/15] Powershell 7 configureren ..." -ForegroundColor Yellow
#
pwsh -c Enable-PSRemoting -Force
pwsh -c Set-NetFirewallRule -Name 'WINRM-HTTP-In-TCP' -RemoteAddress Any
pwsh -c Set-NetFirewallRule -Name 'WINRM-HTTPS-In-TCP' -RemoteAddress Any
#
New-ItemProperty -Path "HKCU:\Software\TutSOFT" -Name "Powershell 7 Remote" -Value 1 -PropertyType DWord -Force | Out-Null
#
#
#   #######################################################################
#   WinGET Windows Terminal
#   #######################################################################
#
#
Write-Host "[10/15] [WinGet] Microsoft Windows Terminal installeren ..." -ForegroundColor Yellow
#
winget install Microsoft.WindowsTerminal
#
New-ItemProperty -Path "HKCU:\Software\TutSOFT" -Name "Windows Terminal Install" -Value 1 -PropertyType DWord -Force | Out-Null
#
#   #######################################################################
#   WinGET Nano
#   #######################################################################
#
#
Write-Host "[11/15] [WinGet] Nano installeren ..." -ForegroundColor Yellow
#
winget install GNU.Nano
#
New-ItemProperty -Path "HKCU:\Software\TutSOFT" -Name "Nano Install" -Value 1 -PropertyType DWord -Force | Out-Null
#
#
#   #######################################################################
#   WinGET PatchMyPC
#   #######################################################################
#
#
Write-Host "[12/15] [WinGet] PatchMyPC installeren ..." -ForegroundColor Yellow
#
winget Install PatchMyPC.PatchMyPC
#
New-ItemProperty -Path "HKCU:\Software\TutSOFT" -Name "PatchMyPC Install" -Value 1 -PropertyType DWord -Force | Out-Null
#
#
#   #######################################################################
#   WinGET Devolutions.UniGetUI
#   #######################################################################
#
#
Write-Host "[13/15] [WinGet] UniGetUI installeren ..." -ForegroundColor Yellow
#
winget Install Devolutions.UniGetUI
#
New-ItemProperty -Path "HKCU:\Software\TutSOFT" -Name "UniGetUI Install" -Value 1 -PropertyType DWord -Force | Out-Null

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
#   ###########################################
#   TutSOFT SF Einde 
#   ###########################################
#
#
#   #######################################################################
#   EINDE VM OOBE SCRIPT
#   #######################################################################
#
#
Write-Host "[15/15] Einde Script ..." -ForegroundColor Yellow
#
New-ItemProperty -Path "HKCU:\Software\TutSOFT" -Name "OOBE Finish" -Value 1 -PropertyType DWord -Force | Out-Null
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