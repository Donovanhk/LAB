# ===============================
# Minimal Windows 10 Setup Script
# Purpose: Reduce resource usage in a dev/lab VM
# Requirements: Must retain network connectivity to AD
# ===============================

# Run as Administrator

# --- Disable Windows Defender Antivirus ---
Write-Host "Disabling Windows Defender..."
Set-MpPreference -DisableRealtimeMonitoring $true
Stop-Service -Name WinDefend -Force
Set-Service -Name WinDefend -StartupType Disabled

# --- Disable Windows Firewall ---
Write-Host "Disabling Windows Firewall..."
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
Stop-Service -Name MpsSvc -Force
Set-Service -Name MpsSvc -StartupType Disabled

# --- Disable Security Center ---
Write-Host "Disabling Security Center..."
Stop-Service -Name wscsvc -Force
Set-Service -Name wscsvc -StartupType Disabled

# --- Disable Windows Update ---
Write-Host "Disabling Windows Update..."
Stop-Service -Name wuauserv -Force
Set-Service -Name wuauserv -StartupType Disabled

# --- Disable SmartScreen (Explorer) ---
Write-Host "Disabling SmartScreen..."
Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "SmartScreenEnabled" -Value "Off"

# --- Disable Background Services ---
$servicesToDisable = @(
    "DiagTrack",         # Connected User Experiences and Telemetry
    "dmwappushservice",  # WAP Push Message Routing
    "MapsBroker",        # Maps updates
    "WSearch",           # Windows Search
    "Fax",               # Fax service
    "XblGameSave",       # Xbox Live Game Save
    "XboxNetApiSvc",     # Xbox Networking
    "RetailDemo"         # Retail Demo Service
)

foreach ($svc in $servicesToDisable) {
    Write-Host "Disabling service: $svc"
    Stop-Service -Name $svc -ErrorAction SilentlyContinue
    Set-Service -Name $svc -StartupType Disabled
}

# --- Disable Cortana (via registry) ---
Write-Host "Disabling Cortana..."
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Value 0

# --- Disable OneDrive Sync ---
Write-Host "Disabling OneDrive..."
Stop-Process -Name "OneDrive" -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSync" -Value 1

# --- Disable Tips, Ads, and Consumer Features ---
Write-Host "Disabling consumer features..."
Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338388Enabled" -Value 0
Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-310093Enabled" -Value 0
Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-314563Enabled" -Value 0

# --- Final Message ---
Write-Host "`n✅ System trimmed down for lab use. Reboot recommended to apply all changes."
