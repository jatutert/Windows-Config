#
#   TTTTTT  U    U  TTTTTT  SSSSSS  OOOOOO  FFFFFF  TTTTTT
#     TT    U    U    TT    SS      O    O  FF        TT
#     TT    U    U    TT    SSSSSS  O    O  FFFF      TT
#     TT    U    U    TT        SS  O    O  FF        TT
#     TT    UUUUUU    TT    SSSSSS  OOOOOO  FF        TT
#
#
#   Windows Virtual Machine 
#   Windows Out of the Box Experience (OOBE)
#
#   OpenSSH Client and Server Installation Script
#   Created by John Tutert for TutSOFT
#
#   Versie 3
#   24 april 2025
#
#   Changelog
#   20250424	Universele header Script
#
#   Naslag
#
#   https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse?tabs=powershell
#
#   https://stackoverflow.com/questions/52113738/starting-ssh-agent-on-windows-10-fails-unable-to-start-ssh-agent-service-erro
#
#
Write-Output 'Opschonen'
Remove-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
Remove-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Dism.exe /online /Cleanup-Image /StartComponentCleanup /Quiet
#
Write-Output 'Installeren'
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
#
Write-Output "OpenSSH Service starten"
Start-Service sshd
#
Write-Output "OpenSSH Service aanpassen naar automatisch starten"
Microsoft.Powershell.Management\Set-Service -Name sshd -StartupType 'Automatic'
#
# Confirm the Firewall rule is configured. It should be created automatically by setup. Run the following to verify
if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
    Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
    New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
} else {
    Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
}
#
#   Thats all folks
#