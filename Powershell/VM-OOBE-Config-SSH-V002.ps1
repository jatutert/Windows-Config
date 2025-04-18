#
#
#	Windows OpenSSH Installatie Script
#	Versie 2
#
#	18 april 2025
#	John Tutert
#
#
#	Naslag
#
#	https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse?tabs=powershell
#
#	https://stackoverflow.com/questions/52113738/starting-ssh-agent-on-windows-10-fails-unable-to-start-ssh-agent-service-erro
#

Write-Output "Verwijderen OpenSSH Client"
Remove-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
Write-Output "Verwijderen OpenSSH Server"
Remove-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

Write-Output "DISM Clean Up the WinSxS Folder"
Dism.exe /online /Cleanup-Image /StartComponentCleanup

Write-Output "Installatie SSH Client"
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
Write-Output "Installatie SSH Client"
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

Write-Output "OpenSSH Service starten"
Start-Service sshd

Write-Output "OpenSSH Service aanpassen naar automatisch starten"
Set-Service -Name sshd -StartupType 'Automatic'


# Confirm the Firewall rule is configured. It should be created automatically by setup. Run the following to verify
if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
    Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
    New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
} else {
    Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
}
#
#	Thats all folks
#
