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
#   03 ARPIL 2026
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
#   #######################################################################
#   Active Directory 
#   #######################################################################
#
Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/PS-Windows-Active-Directory/WS22-AD-DC-Install.ps1 -OutFile "$env:USERPROFILE\Desktop\WS22-AD-DC-Install.ps1"
Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/PS-Windows-Active-Directory/WS22-AD-DC-Promote.ps1 -OutFile "$env:USERPROFILE\Desktop\WS22-AD-DC-Promote.ps1"
Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/PS-Windows-Active-Directory/WS22-AD-DC-Import-Users.ps1 -OutFile "$env:USERPROFILE\Desktop\WS22-AD-DC-Import-Users.ps1
Invoke-WebRequest -URI https://raw.githubusercontent.com/jatutert/Windows-Config/refs/heads/main/PS-Windows-Active-Directory/ad_gebruikers.csv -OutFile "$env:USERPROFILE\Desktop\ad_gebruikers.csv"
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
#   WinGET Deel 2 van 2 
#   #######################################################################
#
cmd.exe /c "echo Y | winget list"
#
#   #######################################################################
#   WinGET Powershell 7
#   #######################################################################
#
winget install Microsoft.Powershell
#
#   #######################################################################
#   WinGET Windows Terminal
#   #######################################################################
#
winget install Microsoft.WindowsTerminal
#
#   #######################################################################
#   WinGET Nano
#   #######################################################################
#
winget install GNU.Nano
#
#   #######################################################################
#   WinGET PatchMyPC
#   #######################################################################
#
winget Install PatchMyPC.PatchMyPC
#
#   Thats all folks
#