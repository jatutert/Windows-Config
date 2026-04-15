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
#   10 ARPIL 2026
#
#
# Active Directory module laden
Import-Module ActiveDirectory

# Pad naar het CSV-bestand
$CsvPad = ".\ad_gebruikers.csv"

# Target container (standaard Users container)
$TargetOU = "CN=Users,DC=homelab,DC=net"

# CSV inlezen
$Gebruikers = Import-Csv -Path $CsvPad

foreach ($Gebruiker in $Gebruikers) {

    # Controleren of gebruiker al bestaat (op SamAccountName)
    $Bestaat = Get-ADUser -Filter "SamAccountName -eq '$($Gebruiker.Gebruikersnaam)'" -ErrorAction SilentlyContinue

    if ($null -eq $Bestaat) {

        # Wachtwoord veilig omzetten naar SecureString
        $SecurePassword = ConvertTo-SecureString `
            $Gebruiker.Wachtwoord `
            -AsPlainText `
            -Force

        # Nieuwe AD-gebruiker aanmaken
        New-ADUser `
            -Name              $Gebruiker.DisplayName `
            -GivenName         $Gebruiker.Voornaam `
            -Surname           $Gebruiker.Achternaam `
            -SamAccountName    $Gebruiker.Gebruikersnaam `
            -UserPrincipalName $Gebruiker.UserPrincipalName `
            -Department        $Gebruiker.Department `
            -Title             $Gebruiker.Title `
            -Description       $Gebruiker.Description `
            -AccountPassword   $SecurePassword `
            -Enabled           $true `
            -Path              $TargetOU `
            -ChangePasswordAtLogon $true

        Write-Host "Gebruiker aangemaakt:" $Gebruiker.Gebruikersnaam -ForegroundColor Green
    }
    else {
        Write-Host "Gebruiker bestaat al:" $Gebruiker.Gebruikersnaam -ForegroundColor Yellow
    }
}