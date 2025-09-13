# Install Chocolatey (if not already installed)
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Core Software Installation
$packages = @(
    "googlechrome",
    "firefox",
    "vscode",
    "git",
    "nodejs",
    "python",
    "7zip",
    "notepadplusplus",
    "vlc",
    "spotify",
    # New additions
    "adobereader",
    "audacity",
    "brave",
    "citrix-workspace",
    "cpu-z",
    "equalizerapo",
    "googledrive",
    "irfanview",
    "itunes",
    "onedrive",
    "obs-studio",
    "treesizefree"
)

foreach ($pkg in $packages) {
    choco install $pkg -y
}


# Install the Windows Update module
Install-PackageProvider -Name NuGet -Force
Install-Module -Name PSWindowsUpdate -Force

# Import the module
Import-Module PSWindowsUpdate

# Check for updates
Get-WindowsUpdate

# Install all available updates
Install-WindowsUpdate -AcceptAll -AutoReboot

$LanguageTag = "zh-HK"  # Traditional Chinese - Hong Kong
Add-WindowsCapability -Online -Name "Language.Basic~~~$LanguageTag~0.0.1.0"

$LanguageList = Get-WinUserLanguageList
$LanguageList.Add("zh-HK")
Set-WinUserLanguageList $LanguageList -Force

Set-WinUILanguageOverride -Language "zh-HK"
Set-WinSystemLocale -SystemLocale "zh-HK"


