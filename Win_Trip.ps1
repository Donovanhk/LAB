Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

Set-MpPreference -DisableRealtimeMonitoring $true


Stop-Service -Name wscsvc
Set-Service -Name wscsvc -StartupType Disabled

Stop-Service -Name WinDefend
Set-Service -Name WinDefend -StartupType Disabled

Stop-Service -Name wscsvc
Set-Service -Name wscsvc -StartupType Disabled

Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "SmartScreenEnabled" -Value "Off"
