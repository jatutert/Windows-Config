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
#   29 juli 2026
#
#
Clear-Host
Write-Host "Active Directory Domain Services Importeer Gebruikers Script"
Write-Host " "

Import-Module ActiveDirectory

# Vraag studentnummer op
do {
    $StudentNummer = Read-Host "Voer uw 6-cijferige studentnummer in"
    
    if ($StudentNummer -notmatch '^\d{6}$') {
        Write-Host "FOUT: Voer exact 6 cijfers in." -ForegroundColor Red
    }

} until ($StudentNummer -match '^\d{6}$')

# CSV-bestand
$CsvPath = ".\WS22-SXN-DC-01-AD-Users.csv"

# Nieuw UPN domein
$UPNSuffix = "homelab$StudentNummer.net"

# Import CSV
$Users = Import-Csv -Path $CsvPath

foreach ($User in $Users) {

    # OU-pad uit CSV
    $TargetOU = $User.OU.Trim()

    # OU's aanmaken indien nodig
    $SplitOU = $TargetOU -split ','

    if ($SplitOU.Count -ge 3) {

        # Voorbeeld:
        # OU=TVSeries,OU=EastEnders,DC=homelab,DC=net

        $ParentDN = "DC=homelab,DC=net"

        for ($i = $SplitOU.Count - 3; $i -ge 0; $i--) {

            $CurrentOU = $SplitOU[$i]

            if ($CurrentOU -match '^OU=') {

                $OUName = ($CurrentOU -replace '^OU=', '')

                $ExistingOU = Get-ADOrganizationalUnit `
                    -LDAPFilter "(ou=$OUName)" `
                    -SearchBase $ParentDN `
                    -ErrorAction SilentlyContinue

                if (-not $ExistingOU) {

                    Write-Host "OU aanmaken: $OUName"

                    New-ADOrganizationalUnit `
                        -Name $OUName `
                        -Path $ParentDN `
                        -ProtectedFromAccidentalDeletion $false
                }

                $ParentDN = "OU=$OUName,$ParentDN"
            }
        }
    }

    # Nieuwe UPN maken
    $NewUPN = "$($User.Gebruikersnaam)@$UPNSuffix"

    # Wachtwoord converteren
    $SecurePassword = ConvertTo-SecureString `
        $User.Wachtwoord `
        -AsPlainText `
        -Force

    # Bestaat gebruiker al?
    $ExistingUser = Get-ADUser `
        -Filter "SamAccountName -eq '$($User.Gebruikersnaam)'" `
        -ErrorAction SilentlyContinue

    if (-not $ExistingUser) {

        Write-Host "Gebruiker aanmaken: $($User.DisplayName)" -ForegroundColor Gray

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
            -Path $TargetOU `
            -ChangePasswordAtLogon $false
    }
    else {

        Write-Host "Gebruiker bestaat al: $($User.Gebruikersnaam)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Import voltooid voor domein: $UPNSuffix" -ForegroundColor White




