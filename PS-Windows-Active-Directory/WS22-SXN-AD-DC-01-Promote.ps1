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
#   22 juli 2026
#
#
#   #### LET OP
#   Dit script kan pas uitgevoerd worden NA de installatie van feature en vervolgens een herstart
#   Pas dan is het mogelijk om onderstaande stappen uit te voeren. 
#   #### LET OP

Clear-Host
Write-Host "Active Directory Domain Services Domain Controller Promotor Script"
Write-Host "Created by TutSOFT for Personal and / or Educational use only !"
Write-Host ""
Write-Host "Importeer de ADDSDeployment module"
Import-Module ADDSDeployment
Write-Host ""

# Standaard waarde Domain Name
$DomainName = "ccshomelab.net"

# Studentnummer toevoegen aan Domain Name
do {
    $StudentNumber = Read-Host "Voer je 6-cijferige studentnummer in om toe te voegen aan Domain Name"

    if ($StudentNumber -match '^\d{6}$') {
        $ValidInput = $true
    }
    else {
        Write-Host "Fout: voer exact 6 cijfers in." -ForegroundColor Red
        $ValidInput = $false
    }
}
while (-not $ValidInput)


# Parameters

$DomainName = "homelab$StudentNumber.net"
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