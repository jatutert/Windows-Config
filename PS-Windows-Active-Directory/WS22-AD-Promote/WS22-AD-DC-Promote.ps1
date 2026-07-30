#
#   TTTTTT  U    U  TTTTTT  SSSSSS  OOOOOO  FFFFFF  TTTTTT
#     TT    U    U    TT    SS      O    O  FF        TT
#     TT    U    U    TT    SSSSSS  O    O  FFFF      TT
#     TT    U    U    TT        SS  O    O  FF        TT
#     TT    UUUUUU    TT    SSSSSS  OOOOOO  FF        TT
#
#   Windows Server 2022 
#   Active Directory Domain Services Domain Controller Promotor
#
#   For Personal and/or Education Use Only ! 
#
#
#   03 ARPIL 2026
#
#
#   #### LET OP
#   Dit script kan pas uitgevoerd worden NA de installatie van feature en vervolgens een herstart
#   Pas dan is het mogelijk om onderstaande stappen uit te voeren. 
#   #### LET OP

Write-Host "Importeer de ADDSDeployment module"
Import-Module ADDSDeployment

# Parameters
$DomainName = "homelab.net"
$PlainPassword = "!@WACHTwoord#$"
$SecurePassword = ConvertTo-SecureString $PlainPassword -AsPlainText -Force

# 1. Installeer de AD DS rol
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# https://learn.microsoft.com/en-us/powershell/module/addsdeployment/install-addsforest?view=windowsserver2022-ps

# 2. Promoveer de server tot Domain Controller
Install-ADDSForest `
    -DomainName $DomainName `
    -CreateDnsDelegation:$false `
    -DatabasePath "C:\Windows\NTDS" `
    -DomainMode "WinThreshold" `
    -ForestMode "WinThreshold" `
    -InstallDns:$true `
    -LogPath "C:\Windows\NTDS" `
    -NoRebootOnCompletion:$false `
    -SysvolPath "C:\Windows\SYSVOL" `
    -Force:$true `
    -SafeModeAdministratorPassword $SecurePassword


#   Herstart de server om de promotie te voltooien
#   Restart-Computer -Force -ComputerName localhost -Confirm:$false

#
#   Thats all Folks
#