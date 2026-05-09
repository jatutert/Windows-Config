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
#   VERSION 024
#   09 MEI 2026
#
#
Clear-Host
#
#
Write-Host "Out of Box Experience (OOBE) configurator" -ForegroundColor Green
Write-Host "Current User Edition" -ForegroundColor Green
Write-Host "Created by TutSOFT for personal and/or educational use" -ForegroundColor Green
#
#
#   #######################################################################
#   Alle Windows 
#   #######################################################################
#
#
#   ###########################################
#   Bepalen Windows Desktop of Windows Server 
#   ###########################################
#
#
$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
#
if ($osInfo.ProductType -ne 1) {
    Write-Host "This virtual machine runs Windows Server" -ForegroundColor Green
}
else {
    Write-Host "This virtual machine runs Windows Desktop" -ForegroundColor Green
}
#
#
Write-Host "[WinGet] Licentie activeren ..." -ForegroundColor White
#
cmd.exe /c "echo Y | winget list"
#
#
#   ####################
#   Windows Terminal
#   ####################
#
#
Write-Host "[WinGet] Microsoft Windows Terminal (Huidige Gebruiker)" -ForegroundColor Gray
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