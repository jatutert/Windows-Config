#
#   TTTTTT  U    U  TTTTTT  SSSSSS  OOOOOO  FFFFFF  TTTTTT
#     TT    U    U    TT    SS      O    O  FF        TT
#     TT    U    U    TT    SSSSSS  O    O  FFFF      TT
#     TT    U    U    TT        SS  O    O  FF        TT
#     TT    UUUUUU    TT    SSSSSS  OOOOOO  FF        TT
#
#
#   Windows Virtual Machine 
#   Out of the Box Experience (OOBE)
#
#   Stop and disable Windows Services Virtual Machine
#   Created by John Tutert for TutSOFT
#
#   Versie 6
#   19 april 2025
#
#   Changelog
#   Version 5   Powershell
#   Version 6   Disable Browser Service 
#
Write-Host 'Stop Windows Services'
Microsoft.Powershell.Management\Stop-Service -Name "wuauserv" -Force
Microsoft.Powershell.Management\Stop-Service -Name "themes" -Force
Microsoft.Powershell.Management\Stop-Service -Name "sysmain" -Force
Microsoft.Powershell.Management\Stop-Service -Name "spooler" -Force
Microsoft.Powershell.Management\Stop-Service -Name "sharedaccess" -Force
Microsoft.Powershell.Management\Stop-Service -Name "iphlpsvc" -Force
Microsoft.Powershell.Management\Stop-Service -Name "defragsvc" -Force
Microsoft.Powershell.Management\Stop-Service -Name "audiosrv" -Force
#   Microsoft.Powershell.Management\Stop-Service -Name "browser" -Force
Microsoft.Powershell.Management\Stop-Service -Name "WSearch" -Force
#
Write-Host 'Disable Windows Services'
Microsoft.Powershell.Management\Set-Service -Name "wuauserv" -StartupType 'Disabled'
Microsoft.Powershell.Management\Set-Service -Name "themes" -StartupType 'Disabled'
Microsoft.Powershell.Management\Set-Service -Name "sysmain" -StartupType 'Disabled'
Microsoft.Powershell.Management\Set-Service -Name "spooler" -StartupType 'Disabled'
Microsoft.Powershell.Management\Set-Service -Name "sharedaccess" -StartupType 'Disabled'
Microsoft.Powershell.Management\Set-Service -Name "iphlpsvc" -StartupType 'Disabled'
Microsoft.Powershell.Management\Set-Service -Name "defragsvc" -StartupType 'Disabled'
Microsoft.Powershell.Management\Set-Service -Name "audiosrv" -StartupType 'Disabled'
#   Microsoft.Powershell.Management\Set-Service -Name "browser" -StartupType 'Disabled'
Microsoft.Powershell.Management\Set-Service -Name "Wsearch" -StartupType 'Disabled'
#
#   Tijdzone aanpassen naar West Europa
#   Microsoft.Powershell.Management\Set-TimeZone -Id "W. Europe Standard Time"
#
#   Thats all Folks 
#