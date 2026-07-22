# =====================================================================
# Windows Server 2022
# SXN-DC-01
#
# Installatie Remote Desktop Licensing Server
#
# Te gebruiken in combinatie met:
# - SXN-RD-01 = Connection Broker
# - SXN-RD-01 = Web Access
# - SXN-RD-01 = Gateway
# - SXN-RD-01 = Session Host
#
# Licensing Mode wordt op SXN-RD-01 ingesteld.
# Dit script installeert uitsluitend de License Server rol.
# =====================================================================

# ---------------------------------------------------
# Controle Administrator
# ---------------------------------------------------

if (-not (
    [Security.Principal.WindowsPrincipal]
    [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator))
{
    Write-Error "Start PowerShell als Administrator."
    exit 1
}

Write-Host ""
Write-Host "Installatie Remote Desktop Licensing..." -ForegroundColor Green

# ---------------------------------------------------
# Installatie RD Licensing
# ---------------------------------------------------

Install-WindowsFeature `
    -Name RDS-Licensing `
    -IncludeManagementTools

# ---------------------------------------------------
# AD-groep configureren
# ---------------------------------------------------
# Vereist voor correcte uitgifte van Per User CAL's

try
{
    Import-Module ActiveDirectory -ErrorAction Stop

    Add-ADGroupMember `
        -Identity "Terminal Server License Servers" `
        -Members $env:COMPUTERNAME `
        -ErrorAction SilentlyContinue

    Write-Host "Server toegevoegd aan 'Terminal Server License Servers'." `
        -ForegroundColor Green
}
catch
{
    Write-Warning "Controleer handmatig of de server lid is van de groep 'Terminal Server License Servers'."
}

# ---------------------------------------------------
# Controle installatie
# ---------------------------------------------------

Write-Host ""
Write-Host "Geinstalleerde RDS Features:" -ForegroundColor Cyan

Get-WindowsFeature RDS* |
    Where-Object Installed

Write-Host ""
Write-Host "Servernaam : $env:COMPUTERNAME" -ForegroundColor Cyan
Write-Host "Rol         : Remote Desktop Licensing" -ForegroundColor Cyan

Write-Host ""
Write-Host "Installatie voltooid." -ForegroundColor Green

Write-Host ""
Write-Host "VOLGENDE STAP:" -ForegroundColor Yellow
Write-Host "1. Open licmgr.exe" -ForegroundColor Yellow
Write-Host "2. Activeer de License Server" -ForegroundColor Yellow
Write-Host "3. Installeer de aangeschafte RDS CAL's" -ForegroundColor Yellow