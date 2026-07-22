# =====================================================================
# Remote Desktop Services Standard Deployment
# Windows Server 2022
#
# Rollen op SXN-RD-01:
#   - RD Connection Broker
#   - RD Web Access
#   - RD Gateway
#   - RD Session Host
#
# RD Licensing:
#   - SXN-DC-01
#
# Deployment Type:
#   - Standard Deployment
#   - Session-Based Desktop Deployment
# =====================================================================

# -----------------------------
# Variabelen
# -----------------------------

$ConnectionBroker = "SXN-RD-01"
$WebAccessServer  = "SXN-RD-01"
$SessionHost      = "SXN-RD-01"
$GatewayServer    = "SXN-RD-01"
$LicenseServer    = "SXN-DC-01"

$CollectionName   = "DesktopSessions"

# -----------------------------
# Controle Administrator
# -----------------------------

if (-not ([Security.Principal.WindowsPrincipal]
    [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator))
{
    Write-Error "Start PowerShell als Administrator."
    exit 1
}

# -----------------------------
# Remote Desktop module laden
# -----------------------------

Import-Module RemoteDesktop -ErrorAction Stop

Write-Host ""
Write-Host "Start RDS Standard Deployment..." -ForegroundColor Green

# -----------------------------
# Standard Session Deployment
# -----------------------------

if (-not (Get-RDServer -ErrorAction SilentlyContinue))
{
    Write-Host "Aanmaken Session-Based Deployment..." -ForegroundColor Cyan

    New-RDSessionDeployment `
        -ConnectionBroker $ConnectionBroker `
        -WebAccessServer $WebAccessServer `
        -SessionHost $SessionHost
}
else
{
    Write-Host "Deployment bestaat al. Stap wordt overgeslagen." -ForegroundColor Yellow
}

# -----------------------------
# RD Gateway toevoegen
# -----------------------------

$GatewayExists = Get-RDServer `
    -ConnectionBroker $ConnectionBroker |
    Where-Object Role -eq "RDS-GATEWAY"

if (-not $GatewayExists)
{
    Write-Host "Toevoegen RD Gateway..." -ForegroundColor Cyan

    Add-RDServer `
        -Server $GatewayServer `
        -Role RDS-GATEWAY `
        -ConnectionBroker $ConnectionBroker
}
else
{
    Write-Host "RD Gateway bestaat reeds." -ForegroundColor Yellow
}

# -----------------------------
# Licensing configureren
# -----------------------------

Write-Host "Configureren Licensing..." -ForegroundColor Cyan

Set-RDLicenseConfiguration `
    -ConnectionBroker $ConnectionBroker `
    -LicenseServer $LicenseServer `
    -Mode PerUser `
    -Force

# -----------------------------
# Session Collection aanmaken
# -----------------------------

$CollectionExists = Get-RDSessionCollection `
    -ConnectionBroker $ConnectionBroker `
    -ErrorAction SilentlyContinue |
    Where-Object CollectionName -eq $CollectionName

if (-not $CollectionExists)
{
    Write-Host "Aanmaken Session Collection..." -ForegroundColor Cyan

    New-RDSessionCollection `
        -CollectionName $CollectionName `
        -SessionHost $SessionHost `
        -ConnectionBroker $ConnectionBroker
}
else
{
    Write-Host "Session Collection bestaat reeds." -ForegroundColor Yellow
}

# -----------------------------
# Overzicht
# -----------------------------

Write-Host ""
Write-Host "==============================="
Write-Host "RDS Deployment Overzicht"
Write-Host "==============================="

Get-RDServer `
    -ConnectionBroker $ConnectionBroker

Write-Host ""

Get-RDLicenseConfiguration `
    -ConnectionBroker $ConnectionBroker

Write-Host ""

Get-RDSessionCollection `
    -ConnectionBroker $ConnectionBroker

Write-Host ""
Write-Host "Deployment voltooid." -ForegroundColor Green
