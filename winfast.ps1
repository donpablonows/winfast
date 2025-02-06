# Check and install PowerShell 7 if needed
if ($PSVersionTable.PSVersion.Major -lt 7) {
    Write-Host "Installing PowerShell 7 silently..." -ForegroundColor Cyan
    
    # Try winget first (fastest and silent)
    $winget = Get-Command winget -ErrorAction SilentlyContinue
    if ($winget) {
        winget install --id Microsoft.PowerShell --silent --accept-source-agreements --accept-package-agreements
    } else {
        # Fallback to direct MSI download if winget not available
        $msiUrl = "https://github.com/PowerShell/PowerShell/releases/download/v7.4.1/PowerShell-7.4.1-win-x64.msi"
        $msiPath = "$env:TEMP\pwsh7.msi"
        
        # Download MSI
        (New-Object System.Net.WebClient).DownloadFile($msiUrl, $msiPath)
        
        # Silent install
        Start-Process msiexec.exe -ArgumentList "/i `"$msiPath`" /qn /norestart" -Wait
        Remove-Item $msiPath -Force
    }
    
    # Get the new pwsh path and relaunch
    $pwsh = "$env:ProgramFiles\PowerShell\7\pwsh.exe"
    if (Test-Path $pwsh) {
        Start-Process $pwsh -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Wait
        exit
    } else {
        Write-Host "Failed to install PowerShell 7. Please install it manually." -ForegroundColor Red
        exit 1
    }
}

# El Patrón's Elevation Method
function Start-ElevatedInstance {
    param([string]$ScriptPath)
    
    # Try different elevation methods
    try {
        # Method 1: Direct PowerShell 7 elevation
        $pwsh = "$env:ProgramFiles\PowerShell\7\pwsh.exe"
        if (Test-Path $pwsh) {
            $arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$ScriptPath`""
            Start-Process $pwsh -ArgumentList $arguments -Verb RunAs
            exit
        }
        
        # Method 2: Through cmd.exe (bypasses some service restrictions)
        $arguments = "/c start /b `"$env:ProgramFiles\PowerShell\7\pwsh.exe`" -NoProfile -ExecutionPolicy Bypass -File `"$ScriptPath`""
        Start-Process cmd.exe -ArgumentList $arguments -Verb RunAs
        exit
        
        # Method 3: Legacy PowerShell fallback
        $arguments = "-NoProfile -ExecutionPolicy Bypass -Command `"& {Start-Process '$env:ProgramFiles\PowerShell\7\pwsh.exe' -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File `"`"$ScriptPath`"`"' -Verb RunAs}`""
        Start-Process powershell.exe -ArgumentList $arguments
        exit
    }
    catch {
        Write-Host "Mi amigo, we need administrative powers to run this cartel..." -ForegroundColor Red
        Write-Host "Please run as administrator manually." -ForegroundColor Yellow
        Start-Sleep -Seconds 5
        exit 1
    }
}

# Check for elevation and elevate if needed
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "Acquiring el poder (administrative rights)..." -ForegroundColor DarkYellow
    Start-ElevatedInstance -ScriptPath $PSCommandPath
    exit
}

<# 
.SYNOPSIS
    Advanced Windows 11 Performance Optimization Script
.DESCRIPTION
    Enterprise-grade script to maximize Windows 11 performance through:
    - Advanced service optimization
    - Comprehensive bloatware removal
    - Deep system optimization
    - Memory and CPU optimization
    - Network performance tuning
    - Extensive cleanup routines
    WARNING: Create a system restore point before running (auto-created by script)
.NOTES
    Version: 2.0
    Last Updated: 2025-02-06
#>
# Script initialization
Set-StrictMode -Version Latest
$ErrorActionPreference = 'SilentlyContinue'
$ProgressPreference = 'SilentlyContinue'
$host.UI.RawUI.WindowTitle = "El Patrón's Windows Optimization Cartel"
$host.UI.RawUI.BackgroundColor = 'Black'
$host.UI.RawUI.ForegroundColor = 'White'
Clear-Host

# Define your ASCII Art
$asciiArt = @"
	the 𝕰𝖘𝖈𝖔𝖇𝖆𝖗 𝕰𝖉𝖎𝖙𝖎𝖔𝖓
		█▄─▄▄─██▀▄─██▄─▄─▀█▄─▄███─▄▄─█
		██─▄▄▄██─▀─███─▄─▀██─██▀█─██─█
		▀▄▄▄▀▀▀▄▄▀▄▄▀▄▄▄▄▀▀▄▄▄▄▄▀▄▄▄▄▀
                         ░█──░█ ▀█▀ ░█▄─░█ ░█▀▀▀ ─█▀▀█ ░█▀▀▀█ ▀▀█▀▀ 
                         ░█░█░█ ░█─ ░█░█░█ ░█▀▀▀ ░█▄▄█ ─▀▀▀▄▄ ─░█── 
                         ░█▄▀▄█ ▄█▄ ░█──▀█ ░█─── ░█─░█ ░█▄▄▄█ ─░█──
        EL PATRÓN'S WINDOWS CARTEL| Plata o Plomo for Windows 
"@

# Function to animate the text
function Animate-Text {
    param(
        [string]$Text,
        [int]$Delay = 100
    )

    foreach ($line in $Text -split "`n") {
        Write-Host $line
        Start-Sleep -Milliseconds $Delay
    }
}

# Call the function to animate the ASCII art
Animate-Text  -ForegroundColor DarkYellow -Text $asciiArt -Delay 200


Write-Host @"
"@ -ForegroundColor DarkYellow

Write-Host "`nInitializing El Patrón's optimization cartel..." -ForegroundColor Red
Write-Host "Remember mi amigo... in this business, Windows plays by our rules." -ForegroundColor DarkYellow

# Progress bar with cartel style
function Show-CartelProgress {
    param([int]$PercentComplete, [string]$Status)
    $width = $host.UI.RawUI.WindowSize.Width - 20
    $completedWidth = [math]::Floor($width * ($PercentComplete / 100))
    $remainingWidth = $width - $completedWidth
    $progressBar = "[" + ("█" * $completedWidth) + ("░" * $remainingWidth) + "]"
    Write-Host "`r$progressBar $PercentComplete% - $Status" -NoNewline -ForegroundColor DarkYellow
}

# Narcos-themed logging
function Write-CartelLog {
    param([string]$Message, [string]$Type = "Info")
    $timestamp = Get-Date -Format "HH:mm:ss"
    switch ($Type) {
        "Success" { Write-Host "[$timestamp] ✓ $Message" -ForegroundColor Green }
        "Warning" { Write-Host "[$timestamp] ⚠ $Message" -ForegroundColor Yellow }
        "Error" { Write-Host "[$timestamp] † $Message" -ForegroundColor Red }
        default { Write-Host "[$timestamp] ⚡ $Message" -ForegroundColor DarkYellow }
    }
}

# SAFE PERFORMANCE OPTIMIZATION ONLY
$MaxThreads = [Environment]::ProcessorCount * 2

# PARALLEL EXECUTION FUNCTIONS
$ParallelTasks = @()

function Start-ParallelTask {
    param([scriptblock]$Script)
    $job = Start-Job -ScriptBlock $Script
    $ParallelTasks += $job
}

function Wait-ParallelTasks {
    $ParallelTasks | Wait-Job | Receive-Job
    $ParallelTasks | Remove-Job
}

# BEAST MODE POWER OPTIMIZATION
$powerCmds = @(
    {powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 88888888-8888-8888-8888-888888888888},
    {powercfg /setactive 88888888-8888-8888-8888-888888888888},
    {powercfg /change monitor-timeout-ac 0},
    {powercfg /change monitor-timeout-dc 0},
    {powercfg /change disk-timeout-ac 0},
    {powercfg /change disk-timeout-dc 0},
    {powercfg /change standby-timeout-ac 0},
    {powercfg /change standby-timeout-dc 0},
    {powercfg /change hibernate-timeout-ac 0},
    {powercfg /change hibernate-timeout-dc 0}
)

# SAFE REGISTRY OPTIMIZATION
$regTweaks = @{
    "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" = @{
        "NetworkThrottlingIndex" = 0xFFFFFFFF
        "SystemResponsiveness" = 0
        "AlwaysOn" = 1
    }
    "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" = @{
        "Tcp1323Opts" = 1
        "TcpMaxDupAcks" = 2
        "SackOpts" = 1
        "DefaultTTL" = 64
        "EnablePMTUDiscovery" = 1
        "EnablePMTUBHDetect" = 1
        "GlobalMaxTcpWindowSize" = 65535
        "TcpWindowSize" = 65535
        "MaxFreeTcbs" = 65535
        "MaxUserPort" = 65534
        "TcpTimedWaitDelay" = 30
    }
    "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" = @{
        "Affinity" = 0
        "Background Only" = "False"
        "Clock Rate" = 10000
        "GPU Priority" = 8
        "Priority" = 6
        "Scheduling Category" = "High"
        "SFIO Priority" = "High"
    }
    "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" = @{
        "LargeSystemCache" = 0
        "IoPageLockLimit" = 983040
    }
    "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" = @{
        "NtfsMemoryUsage" = 2
        "NtfsDisableLastAccessUpdate" = 1
        "DontVerifyRandomDrivers" = 1
        "LongPathsEnabled" = 0
        "ContigFileAllocSize" = 64
        "DisableDeleteNotification" = 0
        "FilterSupportedFeaturesMode" = 1
    }
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" = @{
        "HideFileExt" = 0
        "Hidden" = 1
        "ShowSuperHidden" = 1
        "AutoCheckSelect" = 0
        "LaunchTo" = 1
        "TaskbarSmallIcons" = 1
        "DisablePreviewDesktop" = 1
        "DisableThumbnailCache" = 1
        "NoLowDiskSpaceChecks" = 1
        "TaskbarAnimations" = 0
    }
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" = @{
        "Max Cached Icons" = 4096
        "AlwaysUnloadDLL" = 1
        "EnableAutoTray" = 0
    }
    "HKLM:\SYSTEM\CurrentControlSet\Control\Power" = @{
        "HibernateEnabled" = 0
    }
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" = @{
        "DisableAutomaticRestartSignOn" = 1
    }
}

# BEAST MODE NETWORK OPTIMIZATION
$networkCmds = @(
    "netsh int tcp set global autotuninglevel=normal",
    "netsh int tcp set global dca=enabled",
    "netsh int tcp set global rss=enabled",
    "netsh int tcp set global fastopen=enabled",
    "netsh int tcp set global ecncapability=enabled",
    "netsh int tcp set global timestamps=disabled",
    "netsh int tcp set global initialRto=2000",
    "netsh int tcp set global rsc=enabled",
    "netsh int tcp set global nonsackrttresiliency=disabled",
    "netsh int tcp set global maxsynretransmissions=2",
    "netsh interface ipv4 set subinterface `"Ethernet`" mtu=1500 store=persistent",
    "netsh interface ipv6 set subinterface `"Ethernet`" mtu=1500 store=persistent",
    "netsh interface tcp set heuristics disabled",
    "netsh interface tcp set global congestionprovider=ctcp"
)

# PERFORMANCE BOOST SERVICES
$performanceServices = @{
    "SysMain" = "Automatic"  # Superfetch for faster app loading
    "Schedule" = "Automatic"  # Task Scheduler for performance tasks
    "Power" = "Automatic"    # Power management
    "BITS" = "Automatic"     # Background transfers
}

foreach ($service in $performanceServices.GetEnumerator()) {
    Set-Service -Name $service.Key -StartupType $service.Value -ErrorAction SilentlyContinue
    Start-Service -Name $service.Key -ErrorAction SilentlyContinue
}

# VISUAL PERFORMANCE OPTIMIZATION
$visualTweaks = @{
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" = @{
        "VisualFXSetting" = 2
    }
    "HKCU:\Control Panel\Desktop" = @{
        "UserPreferencesMask" = ([byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00))
        "MenuShowDelay" = "0"
        "WaitToKillAppTimeout" = "5000"
        "HungAppTimeout" = "4000"
        "AutoEndTasks" = "1"
        "LowLevelHooksTimeout" = "4000"
        "ForegroundLockTimeout" = "150000"
    }
    "HKCU:\Control Panel\Mouse" = @{
        "MouseHoverTime" = "8"
    }
}

# MEMORY OPTIMIZATION
$memoryTweaks = @{
    "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" = @{
        "ClearPageFileAtShutdown" = 0
        "DisablePagingExecutive" = 0
        "LargeSystemCache" = 0
        "NonPagedPoolQuota" = 0
        "NonPagedPoolSize" = 0
        "PagedPoolQuota" = 0
        "PagedPoolSize" = 192
        "SecondLevelDataCache" = 0x100000
        "SessionPoolSize" = 48
        "SessionViewSize" = 192
        "SystemPages" = 0xFFFFFFFF
        "PhysicalAddressExtension" = 1
    }
}

# DISK OPTIMIZATION
$diskTweaks = @{
    "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" = @{
        "DisableDeleteNotification" = 0
        "DontVerifyRandomDrivers" = 1
        "NtfsDisableLastAccessUpdate" = 1
        "NtfsMemoryUsage" = 2
        "Win31FileSystem" = 0
    }
}

# APPLY ALL TWEAKS IN PARALLEL
$allTweaks = @($regTweaks, $visualTweaks, $memoryTweaks, $diskTweaks)
foreach ($tweakSet in $allTweaks) {
    $tweakSet.GetEnumerator() | ForEach-Object -ThrottleLimit $MaxThreads -Parallel {
        $path = $_.Key
        if (!(Test-Path $path)) { New-Item -Path $path -Force }
        $_.Value.GetEnumerator() | ForEach-Object {
            Set-ItemProperty -Path $path -Name $_.Key -Value $_.Value -Type DWord
        }
    }
}

# BEAST MODE CLEANUP
$enhancedCleanupPaths = @(
    "$env:windir\SoftwareDistribution\Download\*",
    "$env:ProgramData\Microsoft\Windows\WER\*",
    "$env:SystemRoot\TEMP\*",
    "$env:SystemRoot\Minidump\*",
    "$env:SystemRoot\Prefetch\*",
    "$env:ProgramData\Microsoft\Search\Data\Applications\Windows\*"
)

# SAFE PRIVACY OPTIMIZATION
Write-CartelLog "Securing your privacy like a Medellín vault..." "Info"

$privacySettings = @{
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy" = @{
        "TailoredExperiencesWithDiagnosticDataEnabled" = 0
    }
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" = @{
        "Enabled" = 0
    }
    "HKCU:\Control Panel\International\User Profile" = @{
        "HttpAcceptLanguageOptOut" = 1
    }
    "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" = @{
        "AllowTelemetry" = 0
        "DoNotShowFeedbackNotifications" = 1
    }
    "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" = @{
        "EnableActivityFeed" = 0
        "PublishUserActivities" = 0
        "UploadUserActivities" = 0
    }
}

$privacySettings.GetEnumerator() | ForEach-Object -ThrottleLimit $MaxThreads -Parallel {
    $path = $_.Key
    if (!(Test-Path $path)) { New-Item -Path $path -Force }
    $_.Value.GetEnumerator() | ForEach-Object {
        Set-ItemProperty -Path $path -Name $_.Key -Value $_.Value -Type DWord
    }
}

# ADDITIONAL SAFE REGISTRY OPTIMIZATIONS
Write-CartelLog "Optimizing Windows like fine Colombian engineering..." "Info"

$additionalRegTweaks = @{
    "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" = @{
        "NtfsMemoryUsage" = 2
        "NtfsDisableLastAccessUpdate" = 1
    }
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" = @{
        "HideFileExt" = 0
        "Hidden" = 1
        "ShowSuperHidden" = 1
        "AutoCheckSelect" = 0
        "LaunchTo" = 1
        "TaskbarSmallIcons" = 1
    }
}

$additionalRegTweaks.GetEnumerator() | ForEach-Object -ThrottleLimit $MaxThreads -Parallel {
    $path = $_.Key
    if (!(Test-Path $path)) { New-Item -Path $path -Force }
    $_.Value.GetEnumerator() | ForEach-Object {
        Set-ItemProperty -Path $path -Name $_.Key -Value $_.Value -Type DWord
    }
}

# ENHANCED TEMP CLEANUP
Write-CartelLog "Cleaning the system like money through Los Olivos..." "Info"

$enhancedCleanupPaths | ForEach-Object -ThrottleLimit $MaxThreads -Parallel {
    Get-ChildItem -Path $_ -Recurse -Force -ErrorAction SilentlyContinue | 
    Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-7) } | 
    Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
}

# OPTIMIZATION REPORT
$report = @{
    OptimizationDate = Get-Date
    PrivacySettingsConfigured = ($privacySettings.Values | ForEach-Object { $_.Count } | Measure-Object -Sum).Sum
    RegistryKeysModified = ($regTweaks.Values | ForEach-Object { $_.Count } | Measure-Object -Sum).Sum + 
                          ($additionalRegTweaks.Values | ForEach-Object { $_.Count } | Measure-Object -Sum).Sum +
                          ($visualTweaks.Values | ForEach-Object { $_.Count } | Measure-Object -Sum).Sum +
                          ($memoryTweaks.Values | ForEach-Object { $_.Count } | Measure-Object -Sum).Sum +
                          ($diskTweaks.Values | ForEach-Object { $_.Count } | Measure-Object -Sum).Sum
    NetworkSettingsOptimized = $networkCmds.Count
    CleanupPathsProcessed = $enhancedCleanupPaths.Count
    ServicesOptimized = $performanceServices.Count
}

# Save report with style
$reportPath = "$env:USERPROFILE\Desktop\ElPatron_Optimization_Report.txt"
@"
╔══════════════════════════════════════════╗
║        EL PATRÓN'S OPTIMIZATION          ║
║            MISSION REPORT                ║
╚══════════════════════════════════════════╝

Generated: $($report.OptimizationDate)
Privacy Settings Secured: $($report.PrivacySettingsConfigured)
Registry Optimizations: $($report.RegistryKeysModified)
Network Enhancements: $($report.NetworkSettingsOptimized)
Areas Cleaned: $($report.CleanupPathsProcessed)
Services Optimized: $($report.ServicesOptimized)

Remember, mi amigo - a clean system is a loyal system.
"@ | Out-File $reportPath

Write-CartelLog "El reporte is ready on your desktop, Patrón" "Success"

Write-Host @"

    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣤⣤⣤⣤⣤⣤⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⣠⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣄⠀⠀⠀⠀
    ⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀
    ⠀⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀
    ⢠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷
    ⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿

    El trabajo está hecho... Windows is now optimized safely.
    
    Like a smooth Colombian coffee, your system runs clean and pure.
"@ -ForegroundColor DarkYellow

Write-Host "`nA restart is recommended to apply optimizations..." -ForegroundColor Yellow
$restart = Read-Host "¿Would you like to restart now, amigo? (y/n)"

if ($restart -eq 'y') {
    Write-Host "`nHasta luego, mi amigo..." -ForegroundColor DarkYellow
    Start-Sleep -Seconds 3
    Restart-Computer
} else {
    Write-Host "`nNo problem, just remember to restart soon for best results." -ForegroundColor Yellow
}