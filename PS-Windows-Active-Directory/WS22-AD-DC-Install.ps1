#
#   Windows Server 2022 Active Directory Domain Services Domain Controller Installer
#   Created by John Tutert for TutSOFT
#
#   For personal or educational use 
#

Write-Host "Installeer AD DS rol"
Install-WindowsFeature -Name AD-Domain-Services -IncludeAllSubFeature -IncludeManagementTools

Restart-Computer -Force -ComputerName localhost -Confirm:$false

#
#   Thats all Folks
#