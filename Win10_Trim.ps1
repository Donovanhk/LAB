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



# Set for best performance (disables animations, shadows, etc.)
$performanceKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
Set-ItemProperty -Path $performanceKey -Name "VisualFXSetting" -Value 2

# Example: Disable telemetry tasks
Get-ScheduledTask | Where-Object {$_.TaskName -like "*Telemetry*"} | Disable-ScheduledTask

New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Value 


# ===============================
# Minimal Windows 10 Lab Optimization Script
# Purpose: Disable non-essential services to reduce resource usage
# Note: Run as Administrator
# ===============================

$servicesToDisable = @(
    # --- Virtualization & Demo ---
    "AppVService",                  # Microsoft App-V Client
    "RetailDemo",                   # Retail Demo Service

    # --- Telemetry & Feedback ---
    "DiagTrack",                    # Connected User Experiences and Telemetry
    "MapsBroker",                   # Maps updates
    "DownloadedMapsManager",        # Map downloads

    # --- Gaming & Consumer Features ---
    "XblGameSave",                  # Xbox Live Game Save
    "XboxNetApiSvc",                # Xbox Networking
    "XboxGipSvc",                   # Xbox Accessory Management
    "XboxLiveAuthManager",          # Xbox Live Auth
    "XboxLiveNetworkingService",    # Xbox Live Networking

    # --- Printing ---
    "Fax",                          # Fax Service
    "Spooler",                      # Print Spooler
    "PrintWorkflow_15e6c7ff",       # Print Workflow

    # --- Smart Card & Biometrics ---
    "SCardSvr",                     # Smart Card
    "SmartCardDeviceEnumerationService", # Smart Card Device Enumeration
    "SmartCardRemovalPolicy",       # Smart Card Removal Policy
    "WindowsBiometricService",      # Biometric (Fingerprint/Face)

    # --- Sync & Contacts ---
    "OneSyncSvc",                   # Syncs mail/calendar/contacts
    "MessagingService_15e6c7ff",    # Messaging Service
    "ContactData_15e6c7ff",         # Contact Data

    # --- Search & Indexing ---
    "WSearch",                      # Windows Search
    "SysMain",                      # Superfetch

    # --- Mobile & Bluetooth ---
    "PhoneSvc",                     # Phone Service
    "CellularTime",                 # Cellular Time
    "WWANAutoConfig",               # Mobile broadband
    "BluetoothUserService_15e6c7ff", # Bluetooth User Support
    "BTAGService",                  # Bluetooth Audio Gateway
    "bthserv",                      # Bluetooth Support

    # --- Media & Streaming ---
    "WMPNetworkSvc",                # Windows Media Player Network Sharing
    "CameraFrameServer",            # Camera support
    "CameraMonitor",                # Camera monitor
    "GameDVR and Broadcast User Service_15e6c7ff", # Game recording

    # --- Notifications & Push ---
    "PushToInstall",                # Push install service
    "WpnService",                   # Windows Push Notifications
    "WpnUserService_15e6c7ff",      # Push Notifications User Service

    # --- Backup & History ---
    "FileHistorySvc",              # File History
    "SDRSVC",                      # Windows Backup
    "WaaSMedicSvc",                # Windows Update Medic

    # --- Error Reporting & Health ---
    "WerSvc",                      # Windows Error Reporting
    "WindowsHealthService",        # Health and Optimized Experiences

    # --- Web & Cloud Services ---
    "WebClient",                   # WebDAV
    "CloudBackupRestoreService_15e6c7ff", # Cloud Backup
    "MicrosoftEdgeElevationService",      # Edge Elevation
    "edgeupdate",                         # Edge Update
    "edgeupdatem",                        # Edge Update (machine)
    "GoogleUpdaterService138.0.7194.0",   # Chrome Updater
    "MozillaMaintenance",                # Firefox Maintenance

    # --- Security Agents (3rd Party) ---
    "CarbonBlack",                # Carbon Black App Control
    "CBDefense",                  # CB Defense
    "Symantec Endpoint Data Loss Prevention LiveUpdate", # Symantec
    "WebThreatDefSvc",           # Web Threat Defense
    "WebThreatDefUserSvc_15e6c7ff", # Web Threat Defense User

    # --- Miscellaneous ---
    "RetailDemo",                # Retail Demo Service
    "SensorService",             # Sensor support
    "SensorDataService",         # Sensor data
    "SensorMonitoringService",   # Sensor monitoring
    "MapsBroker",                # Maps updates
    "OfflineFiles",              # Offline file sync
    "WindowsInsiderService",     # Insider program
    "WindowsCameraFrameServer", # Camera support
    "WindowsCameraFrameServerMonitor", # Camera monitor
    "WindowsPushToInstall",      # Push install
    "WindowsMediaPlayerNetworkSharingService", # Media sharing
    "WindowsBackup",             # Backup service
    "WindowsErrorReportingService", # Error reporting
    "WindowsHealthService",      # Health checks
    "WindowsSearch",             # File indexing
    "WindowsUpdate",             # Windows Update
    "WaaSMedicSvc",              # Update Medic
    "WMPNetworkSvc",             # Media Player sharing
    "WWANAutoConfig"             # Mobile broadband
)

foreach ($svc in $servicesToDisable) {
    try {
        Write-Host "Disabling service: $svc"
        Stop-Service -Name $svc -ErrorAction SilentlyContinue
        Set-Service -Name $svc -StartupType Disabled
    } catch {
        Write-Host "⚠️ Could not disable $svc — may not exist or already disabled."
    }
}

Write-Host "`n✅ Optimization complete. Reboot recommended to finalize changes."
