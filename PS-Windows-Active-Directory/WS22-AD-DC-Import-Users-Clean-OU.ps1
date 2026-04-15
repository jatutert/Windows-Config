Import-Module ActiveDirectory

# CSV-bestand
$CsvPad = ".\ad_gebruikers.csv"

# Distinguished Names
$DomainDN   = "DC=homelab,DC=net"
$UsersDN    = "CN=Users,$DomainDN"

# CSV inlezen
$Gebruikers = Import-Csv -Path $CsvPad

# ========== STAP 1: gebruikers uit CN=Users verwijderen ==========
foreach ($Gebruiker in $Gebruikers) {

    $UserInUsers = Get-ADUser `
        -Filter "SamAccountName -eq '$($Gebruiker.Gebruikersnaam)'" `
        -SearchBase $UsersDN `
        -ErrorAction SilentlyContinue

    if ($UserInUsers) {

        Remove-ADUser `
            -Identity $UserInUsers.DistinguishedName `
            -Confirm:$false

        Write-Host "Verwijderd uit Users:" `
            $Gebruiker.Gebruikersnaam `
            -ForegroundColor Red
    }
}

# ========== STAP 2: unieke departments bepalen ==========
$Departments = $Gebruikers.Department | Sort-Object -Unique

# ========== STAP 3: OU per department aanmaken ==========
foreach ($Department in $Departments) {

    $DepartmentOU = "OU=$Department,$DomainDN"

    if (-not (Get-ADOrganizationalUnit `
        -Filter "DistinguishedName -eq '$DepartmentOU'" `
        -ErrorAction SilentlyContinue)) {

        New-ADOrganizationalUnit `
            -Name $Department `
            -Path $DomainDN

        Write-Host "OU aangemaakt:" $Department -ForegroundColor Green
    }
}

# ========== STAP 4: gebruikers aanmaken onder department ==========
foreach ($Gebruiker in $Gebruikers) {

    $TargetOU = "OU=$($Gebruiker.Department),$DomainDN"

    $Bestaat = Get-ADUser `
        -Filter "SamAccountName -eq '$($Gebruiker.Gebruikersnaam)'" `
        -ErrorAction SilentlyContinue

    if (-not $Bestaat) {

        $SecurePassword = ConvertTo-SecureString `
            $Gebruiker.Wachtwoord `
            -AsPlainText `
            -Force

        New-ADUser `
            -Name                  $Gebruiker.DisplayName `
            -GivenName             $Gebruiker.Voornaam `
            -Surname               $Gebruiker.Achternaam `
            -SamAccountName        $Gebruiker.Gebruikersnaam `
            -UserPrincipalName     $Gebruiker.UserPrincipalName `
            -Department            $Gebruiker.Department `
            -Title                 $Gebruiker.Title `
            -Description           $Gebruiker.Description `
            -AccountPassword       $SecurePassword `
            -Enabled               $true `
            -Path                  $TargetOU `
            -ChangePasswordAtLogon $true

        Write-Host "Gebruiker aangemaakt:" `
            $Gebruiker.Gebruikersnaam `
            -ForegroundColor Green
    }
}