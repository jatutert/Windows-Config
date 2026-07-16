#
#   TTTTTT  U    U  TTTTTT  SSSSSS  OOOOOO  FFFFFF  TTTTTT
#     TT    U    U    TT    SS      O    O  FF        TT
#     TT    U    U    TT    SSSSSS  O    O  FFFF      TT
#     TT    U    U    TT        SS  O    O  FF        TT
#     TT    UUUUUU    TT    SSSSSS  OOOOOO  FF        TT
#
#
#   Windows Server 2022 
#   Active Directory Domain Services Domain Controller Installer
#
#
#   For Personal and/or Education Use Only ! 
#
#
#   03 ARPIL 2026
#
#
Write-Host "Installeer AD DS rol"
#
Install-WindowsFeature -Name AD-Domain-Services -IncludeAllSubFeature -IncludeManagementTools
#
Restart-Computer -Force -ComputerName localhost -Confirm:$false
#
#   Thats all Folks
#