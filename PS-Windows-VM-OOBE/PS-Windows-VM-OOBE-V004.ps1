#
#   TTTTTT  U    U  TTTTTT  SSSSSS  OOOOOO  FFFFFF  TTTTTT
#     TT    U    U    TT    SS      O    O  FF        TT
#     TT    U    U    TT    SSSSSS  O    O  FFFF      TT
#     TT    U    U    TT        SS  O    O  FF        TT
#     TT    UUUUUU    TT    SSSSSS  OOOOOO  FF        TT
#
#   Windows Server 
#   OOBE
#
#   For Personal and/or Education Use Only ! 
#
#
#   31 maart 2026
#
#
Clear-Host
#
#   #######################################################################
#   Windows SSH Server
#   #######################################################################
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
#   #######################################################################
#   Windows Services
#   #######################################################################
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
#   #######################################################################
#   Windows WinRM
#   #######################################################################
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
#   #######################################################################
#   WinGET
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
#   #######################################################################
#   Active Directory 
#   #######################################################################
#
Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Vagrant/refs/heads/main/Scripts/Powershell/Vagrant-VM-AD-DC-Install.ps1 -OutFile "$env:USERPROFILE\Desktop\Vagrant-VM-AD-DC-Install.ps1"
Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Vagrant/refs/heads/main/Scripts/Powershell/Vagrant-VM-AD-DC-Promote.ps1 -OutFile "$env:USERPROFILE\Desktop\Vagrant-VM-AD-DC-Promote.ps1"
#
#   #######################################################################
#   VMWare Tools
#   #######################################################################
#
$VMWARE_Tools_Installer = "$env:USERPROFILE\Downloads\VMware-tools-13.0.10-25056151-x64.exe"
#
Write-Host 'Downloading VMWare Tools'
#
Invoke-WebRequest -URI https://packages.vmware.com/tools/releases/latest/windows/x64/VMware-tools-13.0.10-25056151-x64.exe -OutFile $VMWARE_Tools_Installer
#
Write-Host 'Installing VMWare Tools'
# 
Start-Process -FilePath $VMWARE_Tools_Installer -ArgumentList "/s", "/v/qn", "REBOOT=ReallySuppress", "EULAS_AGREED=1" -Wait
#
#   #######################################################################
#   Powershell 7
#   #######################################################################
#
$Powershell_7_Installerer = "$env:USERPROFILE\Downloads\PowerShell-7.6.0-win-x64.msi"
#
Invoke-WebRequest -URI https://github.com/PowerShell/PowerShell/releases/download/v7.6.0/PowerShell-7.6.0-win-x64.msi -OutFile $Powershell_7_Installerer
#
Write-Host 'Installing Powershell 7'
#
Start-Process -FilePath $Powershell_7_Installerer -ArgumentList "/quiet", "/norestart" -Wait
#
#   #######################################################################
#   Windows Terminal
#   #######################################################################
#
$Windows_Terminal_Installerer = "$env:USERPROFILE\Downloads\Microsoft.WindowsTerminal_1.24.10621.0_8wekyb3d8bbwe.msixbundle"
#
Invoke-WebRequest -URI https://github.com/microsoft/terminal/releases/download/v1.24.10621.0/Microsoft.WindowsTerminal_1.24.10621.0_8wekyb3d8bbwe.msixbundle -OutFile $Windows_Terminal_Installerer
#
Write-Host 'Installing Windows Terminal'
#
Add-AppxPackage -Path $Windows_Terminal_Installerer
#
#   Thats all folks
#