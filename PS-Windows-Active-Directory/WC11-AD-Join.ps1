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
#   =========================
#   Definitie Parameters
#   =========================
#
#
$DomainName = "homelab.net"
$DomainUser = "HOMELAB\Administrator"
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