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
#   03 ARPIL 2026
#
#
# Pad naar het CSV-bestand
$csvPath = "$env:USERPROFILE\Desktop\ad_gebruikers.csv"

# Importeren van de CSV
$users = Import-Csv -Path $csvPath

foreach ($user in $users) {
    # Samenstellen van de volledige naam en gebruikersnaam
    $fullName = "$($user.Voornaam) $($user.Achternaam)"
    $samAccountName = $user.Gebruikersnaam
    $ou = $user.OU
    $password = ConvertTo-SecureString $user.Wachtwoord -AsPlainText -Force

    # Controleren of gebruiker al bestaat
    if (-not (Get-ADUser -Filter {SamAccountName -eq $samAccountName} -ErrorAction SilentlyContinue)) {
        # Gebruiker aanmaken
        New-ADUser `
            -Name $fullName `
            -GivenName $user.Voornaam `
            -Surname $user.Achternaam `
            -SamAccountName $samAccountName `
            -UserPrincipalName $UserPrincipalName `
            -AccountPassword $password `
            -Path $ou `
            -Enabled $true `
            -DisplayName $fullName `
            -Description $Description `
            -ChangePasswordAtLogon $false

        Write-Host "Gebruiker $fullName aangemaakt."
    } else {
        Write-Host "Gebruiker $fullName bestaat al. Overgeslagen."
    }
}
