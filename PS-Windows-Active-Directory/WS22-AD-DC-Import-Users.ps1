
# Pad naar het CSV-bestand
$csvPath = "C:\Pad\Naar\f1_drivers_2025.csv"

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
            -UserPrincipalName "$samAccountName@yourdomain.com" `
            -AccountPassword $password `
            -Path $ou `
            -Enabled $true `
            -DisplayName $fullName `
            -Description $user.Team `
            -ChangePasswordAtLogon $true

        Write-Host "Gebruiker $fullName aangemaakt."
    } else {
        Write-Host "Gebruiker $fullName bestaat al. Overgeslagen."
    }
}
