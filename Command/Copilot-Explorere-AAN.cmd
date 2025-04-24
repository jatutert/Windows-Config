::
@reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\WindowsCopilot /v AllowCopilotRuntime /t REG_DWORD /d 1 /f
@reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowCopilotButton /t REG_DWORD /d 1 /f
::
@reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\Shell\Copilot /v IsCopilotAvailable /t REG_DWORD /d 1 /f
@reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\Shell\Copilot /v CopilotDisabledReason /t REG_SZ /d "" /f
@reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\Shell\Copilot\BingChat /v IsUserEligible /t REG_DWORD /d 1 /f
::
@reg add HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\WindowsCopilot /v TurnOffWindowsCopilot /t REG_DWORD /d 0 /f
::
:: taskkill /F /IM explorer.exe & start explorer