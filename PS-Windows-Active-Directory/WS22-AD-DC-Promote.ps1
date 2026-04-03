#
#   Windows Server 2022 Active Directory Domain Services Domain Controller Promotor
#   Created by John Tutert for TutSOFT
#
#   For personal or educational use 
#

#   Dit script kan pas uitgevoerd worden NA de installatie van feature en vervolgens een herstart
#   Pas dan is het mogelijk om onderstaande stappen uit te voeren. 

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