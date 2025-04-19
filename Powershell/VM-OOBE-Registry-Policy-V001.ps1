#	Change Windows Policy
#	Change Windows Registy
#
#	Created by John Tutert for TutSOFT
#
#	Versie 1
#	19 april 2025

#
#	Windows News Feed uitzetten
#	https://thesysadminchannel.com/how-to-remove-news-and-interests-windows-10/
#
#	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds" -Name "ShellFeedsTaskbarViewMode" -Value 2
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Feeds" /v ShellFeedsTaskbarViewMode /t REG_DWORD /d 2
#

#	Thats all Folks 
#
