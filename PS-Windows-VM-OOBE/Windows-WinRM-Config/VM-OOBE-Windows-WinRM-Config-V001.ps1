#
#   TTTTTT  U    U  TTTTTT  SSSSSS  OOOOOO  FFFFFF  TTTTTT
#     TT    U    U    TT    SS      O    O  FF        TT
#     TT    U    U    TT    SSSSSS  O    O  FFFF      TT
#     TT    U    U    TT        SS  O    O  FF        TT
#     TT    UUUUUU    TT    SSSSSS  OOOOOO  FF        TT
#
<#
.SYNOPSIS
    Configureert WinRM + PowerShell Remoting voor remote verbindingen.

.DESCRIPTION
    - Activeert WinRM service
    - Configureert HTTP listener
    - Activeert firewallregels
    - Activeert PowerShell Remoting
    - (Optioneel) Maakt HTTPS listener als certificaat beschikbaar is
    - Voert controles uit
#>

Write-Host "=== WinRM & PowerShell Remoting Configuratie Start ===" -ForegroundColor Cyan

# -----------------------------------------------------------
# 1. WinRM service inschakelen
# -----------------------------------------------------------

Write-Host "[1/7] WinRM service configureren..." -ForegroundColor Yellow

Set-Service -Name WinRM -StartupType Automatic
Start-Service -Name WinRM

# Controleren of WinRM draait
$winrmStatus = (Get-Service -Name WinRM).Status
Write-Host " WinRM service status: $winrmStatus"

# -----------------------------------------------------------
# 2. HTTP listener configureren
# -----------------------------------------------------------

Write-Host "[2/7] WinRM HTTP listener configureren..." -ForegroundColor Yellow

$existingListener = winrm enumerate winrm/config/listener | Select-String "Transport = HTTP"

if (-not $existingListener) {
    Write-Host " Geen HTTP listener gevonden, aanmaken..." -ForegroundColor DarkYellow
    winrm create winrm/config/Listener?Address=*+Transport=HTTP
} else {
    Write-Host " HTTP listener bestaat al." -ForegroundColor Green
}

# -----------------------------------------------------------
# 3. Firewallregels activeren
# -----------------------------------------------------------

Write-Host "[3/7] Firewallregels activeren..." -ForegroundColor Yellow

Enable-NetFirewallRule -Name "WINRM-HTTP-In-TCP" -ErrorAction SilentlyContinue
Enable-NetFirewallRule -Name "WINRM-HTTPS-In-TCP" -ErrorAction SilentlyContinue

Write-Host " Firewallregels geactiveerd."

# -----------------------------------------------------------
# 4. PowerShell Remoting inschakelen
# -----------------------------------------------------------

Write-Host "[4/7] PowerShell Remoting inschakelen..." -ForegroundColor Yellow

Enable-PSRemoting -Force

# -----------------------------------------------------------
# 5. Optioneel: HTTPS listener
#    - Alleen maken als er een geschikt certificaat is
# -----------------------------------------------------------

Write-Host "[5/7] Controleren op certificaat voor HTTPS listener..." -ForegroundColor Yellow

$cert = Get-ChildItem Cert:\LocalMachine\My |
        Where-Object { $_.Subject -match $env:COMPUTERNAME } |
        Select-Object -First 1

if ($cert) {
    Write-Host " Certificaat gevonden. HTTPS listener wordt geconfigureerd..." -ForegroundColor DarkYellow
    $thumb = $cert.Thumbprint

    winrm create winrm/config/Listener?Address=*+Transport=HTTPS "@{Hostname='$env:COMPUTERNAME'; CertificateThumbprint='$thumb'}" | Out-Null

    Write-Host " HTTPS listener aangemaakt." -ForegroundColor Green
} else {
    Write-Host " Geen passend certificaat gevonden. HTTPS wordt overgeslagen." -ForegroundColor DarkGray
}

# -----------------------------------------------------------
# 6. WinRM configuratie controleren
# -----------------------------------------------------------

Write-Host "[6/7] Controleren van WinRM listener-configuratie..." -ForegroundColor Yellow

winrm enumerate winrm/config/listener

# -----------------------------------------------------------
# 7. Test: Test-WSMan lokaal
# -----------------------------------------------------------

Write-Host "[7/7] Testen van lokale WinRM verbinding..." -ForegroundColor Yellow

try {
    Test-WSMan -ComputerName localhost
    Write-Host " WinRM remote toegang werkt correct!" -ForegroundColor Green
}
catch {
    Write-Host " FOUT: WinRM werkt nog niet correct." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
}

Write-Host "=== Configuratie voltooid ===" -ForegroundColor Cyan

#
#   Thats all folks 
#