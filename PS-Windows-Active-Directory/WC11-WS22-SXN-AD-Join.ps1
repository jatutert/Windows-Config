#
#   TTTTTT  U    U  TTTTTT  SSSSSS  OOOOOO  FFFFFF  TTTTTT
#     TT    U    U    TT    SS      O    O  FF        TT
#     TT    U    U    TT    SSSSSS  O    O  FFFF      TT
#     TT    U    U    TT        SS  O    O  FF        TT
#     TT    UUUUUU    TT    SSSSSS  OOOOOO  FF        TT
#
#   Windows 11
#   Active Directory Domain Services Domain Join
#
#
#   For Personal and/or Education Use Only ! 
#
#

Clear-Host
Write-Host "Active Directory Domain Services Domain Controller JOIN Script"
Write-Host "Created by TutSOFT for Personal and / or Educational use only !"
Write-Host ""

#   ##################################################################
#   AD JOIN
#   ##################################################################


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

#   =========================
#   Definitie Parameters
#   =========================
#
#
$DomainName = "homelab$StudentNumber.net"
$DomainUser = "HOMELAB\administrator"
$PlainPassword = "!@WACHTwoord#$"
#
#
# SecureString maken van het plaintext wachtwoord
$SecurePassword = ConvertTo-SecureString $PlainPassword -AsPlainText -Force
#
#
# Credential object bouwen
$Credential = New-Object System.Management.Automation.PSCredential `
    ($DomainUser, $SecurePassword)
#
#
# =========================
# Computer toevoegen aan domein
# =========================
#
#
Add-Computer `
    -DomainName $DomainName `
    -Credential $Credential `
    -Force `
    -Restart

#
#   Thats all Folks
#