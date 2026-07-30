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

#Requires -Modules ActiveDirectory

Clear-Host

Write-Host ""
Write-Host "============================================="
Write-Host " Active Directory Bulk Import"
Write-Host "============================================="
Write-Host ""

#region Studentnummer controleren

do {
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

} until ($ValidStudentNummer)

$DomainName = "homelab$StudentNummer.net"

Write-Host ""
Write-Host "Domeinnaam : $DomainName"
Write-Host ""

#endregion

#region CSV bestand bepalen

$CsvBestand = Join-Path `
    -Path $PSScriptRoot `
    -ChildPath "WS22-SXN-DC-01-AD-Users-V7.csv"

if (-not (Test-Path $CsvBestand))
{
    Write-Error "CSV-bestand niet gevonden: $CsvBestand"
    exit
}

Write-Host "CSV-bestand gevonden:"
Write-Host $CsvBestand
Write-Host ""

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

#region Distinguished Name samenstellen

$DomainDN = ($DomainName.Split('.') | ForEach-Object {
    "DC=$_"
}) -join ','

Write-Host "Base DN:"
Write-Host $DomainDN
Write-Host ""

#endregion

#region VerzamelOU's aanmaken

Write-Host ""
Write-Host "VerzamelOU's aanmaken..."
Write-Host ""

$VerzamelOUs = $Users |
    Select-Object -ExpandProperty VerzamelOU |
    Sort-Object -Unique

foreach ($OU in $VerzamelOUs)
{
    try
    {
        $VerzamelOUName = ($OU -split ',')[0] -replace '^VerzamelOU='

        $Bestaat = Get-ADOrganizationalUnit `
            -LDAPFilter "(ou=$VerzamelOUName)" `
            -SearchBase $DomainDN `
            -ErrorAction SilentlyContinue

        if (-not $Bestaat)
        {
            New-ADOrganizationalUnit `
                -Name $VerzamelOUName `
                -Path $DomainDN `
                -ProtectedFromAccidentalDeletion $false `
                -ErrorAction Stop

            Write-Host "[AANGEMAAKT] OU=$VerzamelOUName" -ForegroundColor Green
        }
        else
        {
            Write-Host "[BESTAAT AL] OU=$VerzamelOUName" -ForegroundColor Yellow
        }
    }
    catch
    {
        Write-Warning "Fout bij aanmaken van VerzamelOU: $VerzamelOUName"
    }
}

#endregion

#region GebruikersOU's aanmaken

Write-Host ""
Write-Host "GebruikersOU's aanmaken..."
Write-Host ""

foreach ($User in $Users)
{
    try
    {
        $VerzamelOUName = (
            $User.VerzamelOU -split ','
        )[0] -replace '^VerzamelOU='

        $GebruikersOUName = (
            $User.GebruikersOU -split ','
        )[0] -replace '^GebruikersOU='

        $ParentPath = "OU=$VerzamelOUName,$DomainDN"

        $Bestaat = Get-ADOrganizationalUnit `
            -LDAPFilter "(ou=$GebruikersOUName)" `
            -SearchBase $ParentPath `
            -ErrorAction SilentlyContinue

        if (-not $Bestaat)
        {
            New-ADOrganizationalUnit `
                -Name $GebruikersOUName `
                -Path $ParentPath `
                -ProtectedFromAccidentalDeletion $false `
                -ErrorAction Stop

            Write-Host "[AANGEMAAKT] $VerzamelOUName\$GebruikersOUName" -ForegroundColor Green
        }
    }
    catch
    {
        Write-Warning "Fout bij aanmaken OU $GebruikersOUName"
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
        $VerzamelOUName = (
            $User.VerzamelOU -split ','
        )[0] -replace '^VerzamelOU='

        $GebruikersOUName = (
            $User.GebruikersOU -split ','
        )[0] -replace '^GebruikersOU='

        $UserOU = "OU=$GebruikersOUName,OU=$VerzamelOUName,$DomainDN"

        $SamAccountName = $User.Gebruikersnaam

        $BestaandeGebruiker = Get-ADUser `
            -Filter "SamAccountName -eq '$SamAccountName'" `
            -ErrorAction SilentlyContinue

        if ($BestaandeGebruiker)
        {
            Write-Warning "Gebruiker bestaat al: $SamAccountName"
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
            -Path $UserOU `
            -AccountPassword $SecurePassword `
            -Enabled $true `
            -ChangePasswordAtLogon $false `
            -PasswordNeverExpires $false `
            -ErrorAction Stop

        Write-Host "[AANGEMAAKT] $($User.Gebruikersnaam)" -ForegroundColor Green
    }
    catch
    {
        Write-Warning "Fout bij gebruiker: $($User.Gebruikersnaam)"
        Write-Warning $_.Exception.Message
    }
}

#endregion

Write-Host ""
Write-Host "============================================="
Write-Host " Import voltooid"
Write-Host "============================================="
Write-Host ""
