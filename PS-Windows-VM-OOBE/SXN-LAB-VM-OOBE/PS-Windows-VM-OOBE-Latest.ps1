#
#   TTTTTT  U    U  TTTTTT  SSSSSS  OOOOOO  FFFFFF  TTTTTT
#     TT    U    U    TT    SS      O    O  FF        TT
#     TT    U    U    TT    SSSSSS  O    O  FFFF      TT
#     TT    U    U    TT        SS  O    O  FF        TT
#     TT    UUUUUU    TT    SSSSSS  OOOOOO  FF        TT
#
#   Windows Server 
#   Out of Box Experience 
#
#   For Personal and/or Education Use Only ! 
#
#   VERSIE  010
#   DATUM   17 ARPIL 2026
#
#   Channel Canary
#
Clear-Host
#
#
#   #######################################################################
#   Windows Register
#   #######################################################################
#
Write-Host "[1/7] Registersleutels aanmaken..." -ForegroundColor Yellow
#
#
# Maak de registersleutel aan als deze nog niet bestaat
New-Item -Path "HKCU:\Software\TutSOFT" -Force
#
#
#   #######################################################################
#   Windows SSH Server
#   #######################################################################
#
#
Write-Host "[2/7] SSH Server installeren en configureren..." -ForegroundColor Yellow
#
#
$OOBE_Config_SSH = "$env:USERPROFILE\Downloads\VM-OOBE-Config-SSH-V003.ps1"
#
Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/PS-Windows-VM-OOBE/Windows-Remote-SSH/VM-OOBE-Config-SSH-V003.ps1 -OutFile $OOBE_Config_SSH
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
# Maak een nieuwe DWORD waarde aan
New-ItemProperty `
    -Path "HKCU:\Software\TutSOFT" `
    -Name "Windows SSH" `
    -Value 1 `
    -PropertyType DWord `
    -Force
#
#
#   #######################################################################
#   Windows Services
#   #######################################################################
#
#
Write-Host "[3/7] Windows Services stoppen en uitschakelen..." -ForegroundColor Yellow
#
#
$OOBE_Config_Services = "$env:USERPROFILE\Downloads\VM-OOBE-Config-Services-V007.ps1"
#
Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/PS-Windows-VM-OOBE/Windows-Services-Config/VM-OOBE-Config-Services-V007.ps1 -OutFile $OOBE_Config_Services
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
# Maak een nieuwe DWORD waarde aan
New-ItemProperty `
    -Path "HKCU:\Software\TutSOFT" `
    -Name "Windows Services" `
    -Value 1 `
    -PropertyType DWord `
    -Force
#
#
#   #######################################################################
#   Windows WinRM
#   #######################################################################
#
#
Write-Host "[4/7] Windows WinRM service activeren en configureren..." -ForegroundColor Yellow
#
#
$OOBE_Config_WinRM = "$env:USERPROFILE\Downloads\VM-OOBE-Windows-WinRM-Config-V001.ps1"
#
Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/PS-Windows-VM-OOBE/Windows-WinRM-Config/VM-OOBE-Windows-WinRM-Config-V001.ps1 -OutFile $OOBE_Config_WinRM
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
# Maak een nieuwe DWORD waarde aan
New-ItemProperty `
    -Path "HKCU:\Software\TutSOFT" `
    -Name "Windows WinRM" `
    -Value 1 `
    -PropertyType DWord `
    -Force
#
#
#   #######################################################################
#   WinGET Deel 1 van 2 
#   #######################################################################
#
$OOBE_WinGET_Install = "$env:USERPROFILE\Downloads\winget-install.ps1"
#
Invoke-WebRequest -URI https://raw.githubusercontent.com/asheroto/winget-install/master/winget-install.ps1 -OutFile $OOBE_WinGET_Install
$timeout = 0
while (!(Test-Path $OOBE_WinGET_Install) -and $timeout -lt 10) {
    Start-Sleep -Seconds 1
    $timeout++
}
# 
if ((Get-Item $OOBE_WinGET_Install ).Length -gt 0) {
    & $OOBE_WinGET_Install
}
#
#
# Maak een nieuwe DWORD waarde aan
New-ItemProperty `
    -Path "HKCU:\Software\TutSOFT" `
    -Name "Winget Install" `
    -Value 1 `
    -PropertyType DWord `
    -Force
#
#
#   #######################################################################
#   VMWare Tools
#   #######################################################################
#
#
Write-Host 'VMWare Tools'
#
#
$VMWARE_Tools_Installer = "$env:USERPROFILE\Downloads\VMware-tools-13.0.10-25056151-x64.exe"
#
Write-Host 'Downloading'
#
Invoke-WebRequest -URI https://packages.vmware.com/tools/releases/latest/windows/x64/VMware-tools-13.0.10-25056151-x64.exe -OutFile $VMWARE_Tools_Installer
#
Write-Host 'Installing'
# 
Start-Process -FilePath $VMWARE_Tools_Installer -ArgumentList "/s", "/v/qn", "REBOOT=ReallySuppress", "EULAS_AGREED=1" -Wait
#
#
# Maak een nieuwe DWORD waarde aan
New-ItemProperty `
    -Path "HKCU:\Software\TutSOFT" `
    -Name "VMware Tools" `
    -Value 1 `
    -PropertyType DWord `
    -Force
#
#   #######################################################################
#   WinGET Deel 2 van 2 
#   #######################################################################
#
#
Write-Host 'Accept License Terms Winget'
#
#
cmd.exe /c "echo Y | winget list"
#
#
#   #######################################################################
#   WinGET Powershell 7
#   #######################################################################
#
#
Write-Host 'Powershell 7 install'
#
#
winget install Microsoft.Powershell
#
#
# Maak een nieuwe DWORD waarde aan
New-ItemProperty `
    -Path "HKCU:\Software\TutSOFT" `
    -Name "Powershell 7 Install" `
    -Value 1 `
    -PropertyType DWord `
    -Force
#
#   #######################################################################
#   Powershell 7 Remote
#   #######################################################################
#
pwsh -c Enable-PSRemoting -Force
pwsh -c Set-NetFirewallRule -Name 'WINRM-HTTP-In-TCP' -RemoteAddress Any
pwsh -c Set-NetFirewallRule -Name 'WINRM-HTTPS-In-TCP' -RemoteAddress Any
#
#
# Maak een nieuwe DWORD waarde aan
New-ItemProperty `
    -Path "HKCU:\Software\TutSOFT" `
    -Name "Powershell 7 Remote" `
    -Value 1 `
    -PropertyType DWord `
    -Force
#
#
#   #######################################################################
#   WinGET Windows Terminal
#   #######################################################################
#
#
Write-Host 'Windows Terminal install'
#
#
winget install Microsoft.WindowsTerminal
#
#
#   #######################################################################
#   WinGET Nano
#   #######################################################################
#
#
Write-Host 'GNU Nano install'
#
#
winget install GNU.Nano
#
#
#   #######################################################################
#   WinGET PatchMyPC
#   #######################################################################
#
#
Write-Host 'PatchMyPC install'
#
#
winget Install PatchMyPC.PatchMyPC
#
#
#   #######################################################################
#   WinGET Devolutions.UniGetUI
#   #######################################################################
#
Write-Host 'UniGetUI install'
#
#
winget Install Devolutions.UniGetUI
#
#
#   #######################################################################
#   Specifieke Configuratie 
#   #######################################################################
#
#
switch ($env:COMPUTERNAME) {
    'SXN-DB-01' {
        #   Acties voor DB‑01
        #
        #
        Write-Host 'Winget update everything'
        #
        #
        winget update --all
        #
        #
    }
    'SXN-DC-01' {
        # Acties voor DC‑01
        #
        #
        #   #######################################################################
        #   Active Directory 
        #   #######################################################################
        #
        #
        Write-Host 'Active Directory Domain Services Scripts and files'
        #
        #
        Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/PS-Windows-Active-Directory/WS22-AD-DC-Install.ps1 -OutFile "$env:USERPROFILE\Desktop\WS22-AD-DC-Install.ps1"
        Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/PS-Windows-Active-Directory/WS22-AD-DC-Promote.ps1 -OutFile "$env:USERPROFILE\Desktop\WS22-AD-DC-Promote.ps1"
        Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/PS-Windows-Active-Directory/WS22-AD-DC-Import-Users.ps1 -OutFile "$env:USERPROFILE\Desktop\WS22-AD-DC-Import-Users.ps1"
        Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/PS-Windows-Active-Directory/ad_gebruikers.csv -OutFile "$env:USERPROFILE\Desktop\ad_gebruikers.csv"
        #
        #
        winget update --all
    }
    default {
        # Overige servers
        #
        #   #######################################################################
        #   WinGET Update ALL
        #   #######################################################################
        #
        #
        Write-Host 'Winget update everything'
        #
        #
        winget update --all
        #
        #
    }
}
#
#
#   #######################################################################
#   Windows Register
#   #######################################################################
#
# Maak een nieuwe DWORD waarde aan
New-ItemProperty `
    -Path "HKCU:\Software\TutSOFT" `
    -Name "OOBE Finished" `
    -Value 1 `
    -PropertyType DWord `
    -Force
#
#   Thats all folks
#