#
#   TTTTTT  U    U  TTTTTT  SSSSSS  OOOOOO  FFFFFF  TTTTTT
#     TT    U    U    TT    SS      O    O  FF        TT
#     TT    U    U    TT    SSSSSS  O    O  FFFF      TT
#     TT    U    U    TT        SS  O    O  FF        TT
#     TT    UUUUUU    TT    SSSSSS  OOOOOO  FF        TT
#
#   Windows Server 
#   Importeren Gebruikers
#
#   For Personal and/or Education Use Only ! 
#
#
#   Version 3
#   Date    29 juli 2026
#
#
Clear-Host
Write-Host "Active Directory Domain Services Importeer Gebruikers Script"
Write-Host " "


Import-Module ActiveDirectory

# =================================================================
# Studentnummer opvragen
# =================================================================

do {
    $StudentNummer = Read-Host "Voer uw 6-cijferige studentnummer in"

    if ($StudentNummer -notmatch '^\d{6}$') {
        Write-Host "FOUT: Voer exact 6 cijfers in." -ForegroundColor Red
    }

} until ($StudentNummer -match '^\d{6}$')

$UPNSuffix = "homelab$StudentNummer.net"

Write-Host ""
Write-Host "Studentnummer : $StudentNummer" -ForegroundColor Cyan
Write-Host "UPN Suffix    : $UPNSuffix" -ForegroundColor Cyan
Write-Host ""

# =================================================================
# CSV bestand
# =================================================================

$CsvPath = ".\WS22-SXN-DC-01-AD-Users.csv"

$Users = Import-Csv $CsvPath

# =================================================================
# Verzamel alle unieke OU-structuren uit het CSV bestand
# =================================================================

$UniqueOUs = $Users |
    Select-Object -ExpandProperty VerzamelOU -Unique |
    Sort-Object

# =================================================================
# Bestaande OU's verwijderen
# =================================================================

foreach ($OUPath in $UniqueOUs) {

    $OUElements = $OUPath -split ','

    $TopLevelOU = $OUElements[0]

    $SearchDN = "DC=homelab,DC=net"

    $TopLevelDN = "$TopLevelOU,$SearchDN"

    $ExistingOU = Get-ADOrganizationalUnit `
        -Identity $TopLevelDN `
        -ErrorAction SilentlyContinue

    if ($ExistingOU) {

        Write-Host "Verwijderen bestaande OU-structuur: $TopLevelDN" `
            -ForegroundColor Yellow

        Set-ADObject `
            -Identity $ExistingOU.DistinguishedName `
            -ProtectedFromAccidentalDeletion $false

        Get-ADObject `
            -Filter * `
            -SearchBase $ExistingOU.DistinguishedName `
            -Properties ProtectedFromAccidentalDeletion |
            ForEach-Object {

                if ($_.ProtectedFromAccidentalDeletion) {
                    Set-ADObject `
                        -Identity $_ `
                        -ProtectedFromAccidentalDeletion $false `
                        -ErrorAction SilentlyContinue
                }
            }

        Remove-ADOrganizationalUnit `
            -Identity $ExistingOU.DistinguishedName `
            -Recursive `
            -Confirm:$false
    }
}

# =================================================================
# OU-structuur opnieuw opbouwen
# =================================================================

foreach ($OUPath in $UniqueOUs) {

    $Parts = $OUPath -split ','

    $ParentDN = "DC=homelab,DC=net"

    for ($i = ($Parts.Count - 1); $i -ge 0; $i--) {

        $CurrentPart = $Parts[$i].Trim()

        if ($CurrentPart -match '^OU=') {

            $OUName = $CurrentPart.Replace("OU=","")

            $CurrentDN = "OU=$OUName,$ParentDN"

            $Exists = Get-ADOrganizationalUnit `
                -Identity $CurrentDN `
                -ErrorAction SilentlyContinue

            if (-not $Exists) {

                Write-Host "OU aanmaken: $CurrentDN" `
                    -ForegroundColor Green

                New-ADOrganizationalUnit `
                    -Name $OUName `
                    -Path $ParentDN `
                    -ProtectedFromAccidentalDeletion $false
            }

            $ParentDN = $CurrentDN
        }
    }
}

# =================================================================
# Gebruikers aanmaken
# =================================================================

foreach ($User in $Users) {

    $TargetOU = $User.VerzamelOU

    $NewUPN = "$($User.Gebruikersnaam)@$UPNSuffix"

    $SecurePassword = ConvertTo-SecureString `
        $User.Wachtwoord `
        -AsPlainText `
        -Force

    Write-Host "Gebruiker aanmaken: $($User.DisplayName)"

    New-ADUser `
        -Name $User.DisplayName `
        -GivenName $User.Voornaam `
        -Surname $User.Achternaam `
        -SamAccountName $User.Gebruikersnaam `
        -UserPrincipalName $NewUPN `
        -DisplayName $User.DisplayName `
        -Department $User.Department `
        -Title $User.Title `
        -Description $User.Description `
        -AccountPassword $SecurePassword `
        -Enabled $true `
        -ChangePasswordAtLogon $false `
        -Path $TargetOU
}

# =================================================================
# Einde
# =================================================================

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "Import succesvol voltooid." -ForegroundColor Green
Write-Host "UPN Domein: $UPNSuffix" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green