Import-Module ActiveDirectory

# Pad naar CSV
$CsvPad = ".\ad_gebruikers.csv"

# Domein root
$DomainDN = "DC=homelab,DC=net"

# CSV inlezen
$Gebruikers = Import-Csv -Path $CsvPad

# ========== STAP 1: Unieke departments bepalen ==========
$Departments = $Gebruikers.Department | Sort-Object -Unique

# ========== STAP 2: OU per department aanmaken ==========
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
    else {
        Write-Host "OU bestaat al:" $Department -ForegroundColor Yellow
    }
}

# ========== STAP 3: Gebruikers aanmaken ==========
foreach ($Gebruiker in $Gebruikers) {

    $TargetOU = "OU=$($Gebruiker.Department),$DomainDN"

    $Bestaat = Get-ADUser `
        -Filter "SamAccountName -eq '$($Gebruiker.Gebruikersnaam)'" `
        -ErrorAction SilentlyContinue

    if ($null -eq $Bestaat) {

        # Wachtwoord → SecureString
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

        Write-Host "Gebruiker aangemaakt:" $Gebruiker.Gebruikersnaam -ForegroundColor Green
    }
    else {
        Write-Host "Gebruiker bestaat al:" $Gebruiker.Gebruikersnaam -ForegroundColor Yellow
    }
}