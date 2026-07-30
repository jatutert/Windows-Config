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
#   Version 11
#   Date    31 juli 2026
#
#
Clear-Host
Write-Host "Active Directory Domain Services Importeer Gebruikers Script"
Write-Host " "

#Requires -Modules ActiveDirectory

Clear-Host

Write-Host ""
Write-Host "====================================="
Write-Host " Active Directory Bulk Import"
Write-Host "====================================="
Write-Host ""

#region Studentnummer

do
{
    $StudentNummer = Read-Host "Voer je 6-cijferige studentnummer in"

    if ($StudentNummer -match '^\d{6}$')
    {
        $ValidStudentNummer = $true
    }
    else
    {
        Write-Warning "Ongeldig studentnummer. Voer exact 6 cijfers in."
        $ValidStudentNummer = $false
    }

}
until ($ValidStudentNummer)

$DomainName = "homelab$StudentNummer.net"

$DomainDN = (
    $DomainName.Split('.') |
    ForEach-Object {
        "DC=$_"
    }
) -join ','

Write-Host ""
Write-Host "Domein : $DomainName"
Write-Host "BaseDN : $DomainDN"
Write-Host ""

#endregion

#region CSV Import

$CsvBestand = Join-Path `
    -Path $PSScriptRoot `
    -ChildPath "WS22-SXN-DC-01-AD-Users-Latest.csv"

if (-not (Test-Path $CsvBestand))
{
    Write-Error "CSV-bestand niet gevonden: $CsvBestand"
    exit
}

try
{
    $Users = Import-Csv $CsvBestand -ErrorAction Stop
}
catch
{
    Write-Error "CSV-bestand kon niet worden ingelezen."
    Write-Error $_.Exception.Message
    exit
}

#endregion

#region VerzamelOU's aanmaken

Write-Host ""
Write-Host "VerzamelOU's aanmaken..."
Write-Host ""

$VerzamelOUs = $Users |
    Select-Object -ExpandProperty VerzamelOU |
    Sort-Object -Unique

foreach ($VerzamelOU in $VerzamelOUs)
{
    try
    {
        if (!$VerzamelOU)
        {
            continue
        }

        $Bestaat = Get-ADOrganizationalUnit `
            -LDAPFilter "(ou=$VerzamelOU)" `
            -SearchBase $DomainDN `
            -ErrorAction SilentlyContinue

        if (-not $Bestaat)
        {
            New-ADOrganizationalUnit `
                -Name $VerzamelOU `
                -Path $DomainDN `
                -ProtectedFromAccidentalDeletion $false `
                -ErrorAction Stop

            Write-Host "[AANGEMAAKT] $VerzamelOU" `
                -ForegroundColor Green
        }
        else
        {
            Write-Host "[BESTAAT AL] $VerzamelOU" `
                -ForegroundColor Yellow
        }
    }
    catch
    {
        Write-Warning "Fout bij VerzamelOU: $VerzamelOU"
        Write-Warning $_.Exception.Message
    }
}

#endregion

#region GebruikersOU's aanmaken

Write-Host ""
Write-Host "GebruikersOU's aanmaken..."
Write-Host ""

$OUCombinaties = $Users |
    Select-Object VerzamelOU,GebruikersOU -Unique

foreach ($OU in $OUCombinaties)
{
    try
    {
        $VerzamelOU = $OU.VerzamelOU
        $GebruikersOU = $OU.GebruikersOU

        if (!$VerzamelOU)
        {
            continue
        }

        if (!$GebruikersOU)
        {
            continue
        }

        $ParentPath = "OU=$VerzamelOU,$DomainDN"

        $Bestaat = Get-ADOrganizationalUnit `
            -LDAPFilter "(ou=$GebruikersOU)" `
            -SearchBase $ParentPath `
            -ErrorAction SilentlyContinue

        if (-not $Bestaat)
        {
            New-ADOrganizationalUnit `
                -Name $GebruikersOU `
                -Path $ParentPath `
                -ProtectedFromAccidentalDeletion $false `
                -ErrorAction Stop

            Write-Host "[AANGEMAAKT] $VerzamelOU\$GebruikersOU" `
                -ForegroundColor Green
        }
        else
        {
            Write-Host "[BESTAAT AL] $VerzamelOU\$GebruikersOU" `
                -ForegroundColor Yellow
        }
    }
    catch
    {
        Write-Warning "Fout bij OU: $($OU.VerzamelOU)\$($OU.GebruikersOU)"
        Write-Warning $_.Exception.Message
    }
}

#endregion

#region Gebruikers aanmaken

Write-Host ""
Write-Host "Gebruikers importeren..."
Write-Host ""

foreach ($User in $Users)
{
    try
    {
        $TargetOU = "OU=$($User.GebruikersOU),OU=$($User.VerzamelOU),$DomainDN"

        $OUBestaat = Get-ADOrganizationalUnit `
            -Identity $TargetOU `
            -ErrorAction SilentlyContinue

        if (-not $OUBestaat)
        {
            Write-Warning "OU bestaat niet: $TargetOU"
            continue
        }

        $Bestaat = Get-ADUser `
            -Filter "SamAccountName -eq '$($User.Gebruikersnaam)'" `
            -ErrorAction SilentlyContinue

        if ($Bestaat)
        {
            Write-Warning "Gebruiker bestaat al: $($User.Gebruikersnaam)"
            continue
        }

        $SecurePassword = ConvertTo-SecureString `
            $User.Wachtwoord `
            -AsPlainText `
            -Force

        $NieuweUPN = $User.UserPrincipalName.Replace(
            "homelab.net",
            $DomainName
        )

        New-ADUser `
            -Name $User.DisplayName `
            -DisplayName $User.DisplayName `
            -GivenName $User.Voornaam `
            -Surname $User.Achternaam `
            -SamAccountName $User.Gebruikersnaam `
            -UserPrincipalName $NieuweUPN `
            -Department $User.Department `
            -Title $User.Title `
            -Description $User.Description `
            -Company "Hogeschool Saxion" `
            -City "Enschede" `
            -Country "NL" `
            -Street "M.H. Tromplaan 28" `
            -POBox "70000" `
            -PostalCode "7513 AB" `
            -State "Overijssel" `
            -HomePhone "+31880198888" `
            -HomePage "https://www.saxion.nl" `
            -MobilePhone "+316123456789" `
            -OfficePhone "+316123456789" `
            -Office "Bachelor ICT" `
            -EmailAddress "info@saxion.nl" `
            -Path $TargetOU `
            -AccountPassword $SecurePassword `
            -Enabled $true `
            -ChangePasswordAtLogon $false `
            -PasswordNeverExpires $true `
            -ErrorAction Stop

        Write-Host "[AANGEMAAKT] $($User.Gebruikersnaam)" `
            -ForegroundColor Green
    }
    catch
    {
        Write-Warning "Fout bij gebruiker: $($User.Gebruikersnaam)"
        Write-Warning $_.Exception.Message
    }
}

#endregion

Write-Host ""
Write-Host "====================================="
Write-Host " IMPORT VOLTOOID"
Write-Host "====================================="
Write-Host ""