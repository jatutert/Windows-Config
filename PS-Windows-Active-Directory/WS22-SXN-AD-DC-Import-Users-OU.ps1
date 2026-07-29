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
#   28 juli 2026
#
#
Clear-Host
Write-Host "Active Directory Domain Services Importeer Gebruikers Script"
Write-Host " "

# Active Directory module laden
Import-Module ActiveDirectory

# Pad naar CSV
$CsvPad = ".\ad_gebruikers.csv"

# Standaard waarde Domain Name
$DomainDN = "DC=ccshomelab,DC=net"

# Studentnummer toevoegen aan Domain Name
do {
    $StudentNumber = Read-Host "Voer jouw 6-cijferige studentnummer in om toe te voegen aan Domain Name"

    if ($StudentNumber -match '^\d{6}$') {
        $ValidInput = $true
    }
    else {
        Write-Host "Fout: voer exact 6 cijfers in." -ForegroundColor Red
        $ValidInput = $false
    }
}
while (-not $ValidInput)

# Domain Name voor de rest van het script

$DomainDN = "DC=homelab$StudentNumber,DC=net"

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
            -UserPrincipalName     $Gebruiker.Gebruikersnaam + "@" + DomainDN `
            -Department            $Gebruiker.Department `
            -Title                 $Gebruiker.Title `
            -Description           $Gebruiker.Title + " " + Department `
            -AccountPassword       $SecurePassword `
            -Enabled               $true `
            -Path                  $TargetOU `
            -ChangePasswordAtLogon $false

        Write-Host "Gebruiker aangemaakt:" $Gebruiker.Gebruikersnaam -ForegroundColor Green
    }
    else {
        Write-Host "Gebruiker bestaat al:" $Gebruiker.Gebruikersnaam -ForegroundColor Yellow
    }
}