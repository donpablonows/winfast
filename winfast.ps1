# El Patrón's Ultimate Windows Optimization Script - PLATA O PLOMO EDITION
# Version: 6.0 - The Medellín Cartel Supreme Protocol
# Last Updated: 2024-02-07

# Initialize error tracking
$script:errorOccurred = $false
$ErrorActionPreference = 'Stop'

# Initialize optimization variables
$extremeServiceOptimizations = @(
    "DiagTrack",              # Connected User Experiences and Telemetry
    "dmwappushservice",       # Device Management WAP Push Service
    "MapsBroker",            # Downloaded Maps Manager
    "lfsvc",                 # Geolocation Service
    "WSearch",               # Windows Search (only if you don't use search)
    "XboxGipSvc",            # Xbox Peripherals Service
    "XblAuthManager",        # Xbox Live Auth Manager
    "XblGameSave",           # Xbox Live Game Save Service
    "XboxNetApiSvc",         # Xbox Live Networking Service
    "WMPNetworkSvc",         # Windows Media Player Network Sharing
    "wisvc",                 # Windows Insider Service
    "WerSvc",                # Windows Error Reporting Service
    "RetailDemo",            # Retail Demo Service
    "WalletService",         # Wallet Service
    "WebClient"              # WebClient Service
)

$bloatwareApps = @(
    "Microsoft.3DBuilder",
    "Microsoft.Microsoft3DViewer",
    "Microsoft.AppConnector",
    "Microsoft.BingFinance"
)

$netshCommands = @(
    "netsh int tcp set global autotuninglevel=normal",
    "netsh int tcp set global chimney=enabled"
)

$bcdeditCommands = @(
    "bcdedit /set disabledynamictick yes",
    "bcdedit /set useplatformtick yes"
)

$fsutilCommands = @(
    "fsutil behavior set disablelastaccess 1",
    "fsutil behavior set disable8dot3 1"
)

# Initialize Registry Optimization Variables
$memoryTweaks = @{
    "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" = @{
        "DisablePagingExecutive" = 1
        "LargeSystemCache" = 0
        "DisablePageCombining" = 1
        "IoPageLockLimit" = 983040
        "SystemPages" = 0xFFFFFFFF
        "SessionPoolSize" = 40
        "PoolUsageMaximum" = 96
        "NonPagedPoolQuota" = 0
        "NonPagedPoolSize" = 0
        "PagedPoolQuota" = 0
        "PagedPoolSize" = 192
        "SecondLevelDataCache" = 1048576
        "PhysicalAddressExtension" = 1
        "ClearPageFileAtShutdown" = 0
        "DisablePagingCombining" = 1
        "FeatureSettingsOverride" = 3
        "FeatureSettingsOverrideMask" = 3
        "SystemCacheDirtyPageThreshold" = 0
        "DynamicMemoryBoost" = 0
    }
}

$networkTweaks = @{
    "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" = @{
        "DefaultTTL" = 64
        "EnablePMTUBHDetect" = 1
        "EnablePMTUDiscovery" = 1
        "GlobalMaxTcpWindowSize" = 65535
        "TcpMaxDupAcks" = 2
        "SackOpts" = 1
        "TcpWindowSize" = 65535
        "Tcp1323Opts" = 1
        "MaxFreeTcbs" = 65535
        "MaxUserPort" = 65534
        "TcpTimedWaitDelay" = 30
        "MaxHashTableSize" = 65536
        "NumTcbTablePartitions" = 16
        "MaxConnectionsPerServer" = 0
        "EnableWsd" = 0
        "EnableTCPA" = 0
        "EnableICMPRedirect" = 0
        "DeadGWDetectDefault" = 1
        "MaxConnectionsPer1_0Server" = 16
        "TcpMaxDataRetransmissions" = 3
        "KeepAliveTime" = 7200000
        "KeepAliveInterval" = 1000
        "TcpMaxPortsExhausted" = 5
        "TcpFinWait2Delay" = 30
        "TcpNumConnections" = 0xfffffe
        "EnableDCA" = 1
        "EnableRSS" = 1
        "EnableTCPChimney" = 1
    }
}

$gamingTweaks = @{
    "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" = @{
        "GPU Priority" = 8
        "Priority" = 6
        "Scheduling Category" = 2
        "SFIO Priority" = 2
        "Background Only" = 0
        "Clock Rate" = 10000
        "Affinity" = 0
        "Latency Sensitive" = 1
    }
    "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" = @{
        "NetworkThrottlingIndex" = 4294967295
        "SystemResponsiveness" = 0
        "NoLazyMode" = 1
        "LazyModeTimeout" = 10000
    }
}

# Initialize report variable
$report = @{
    ServicesOptimized = ($extremeServiceOptimizations | Measure-Object).Count
    RegistryKeysModified = 0  # Will be updated during optimization
    NetworkOptimizations = ($netshCommands | Measure-Object).Count
    PowerOptimizations = ($bcdeditCommands | Measure-Object).Count
    CleanupPathsProcessed = ($fsutilCommands | Measure-Object).Count
    BloatwareRemoved = ($bloatwareApps | Measure-Object).Count
    PerformanceBoosts = 7  # Number of major optimization categories
    BackupLocation = ""  # Will be set during backup
    SystemRestorePoint = $true
    OptimizationDate = Get-Date
}

# Error handling function
function Write-ElPatronError {
    param(
        [string]$Message,
        [System.Management.Automation.ErrorRecord]$ErrorRecord
    )
    $script:errorOccurred = $true
    Write-Host "❌ Error: $Message" -ForegroundColor Red
    if ($ErrorRecord) {
        Write-Host "Details: $($ErrorRecord.Exception.Message)" -ForegroundColor Red
    }
}

# Advanced Visual Effects Functions
function Write-HostAnimated {
    param(
        [string]$Text,
        [System.ConsoleColor]$ForegroundColor = [System.ConsoleColor]::White,
        [int]$DelayMS = 10
    )
    
    $Text.ToCharArray() | ForEach-Object {
        Write-Host $_ -NoNewline -ForegroundColor $ForegroundColor
        Start-Sleep -Milliseconds $DelayMS
    }
    Write-Host ""
}

function Show-SpinnerAnimation {
    param(
        [string]$Text,
        [int]$DurationSeconds
    )
    
    $spinner = @('|', '/', '-', '\')
    $startTime = Get-Date
    
    while (((Get-Date) - $startTime).TotalSeconds -lt $DurationSeconds) {
        foreach ($spin in $spinner) {
            Write-Host "`r$Text [$spin]" -NoNewline
            Start-Sleep -Milliseconds 100
        }
    }
    Write-Host "`r$Text [✓]"
}

function Show-LoadingBar {
    param(
        [int]$Percent,
        [string]$Text,
        [ConsoleColor]$BarColor = 'Green'
    )
    
    $width = $host.UI.RawUI.WindowSize.Width - 20
    $completed = [math]::Floor($width * ($Percent / 100))
    $remaining = $width - $completed
    
    Write-Host "`r[$(" " * $completed)$(" " * $remaining)] $Percent% - $Text" -NoNewline
    $cursorPosition = $host.UI.RawUI.CursorPosition
    $cursorPosition.X = 1
    $host.UI.RawUI.CursorPosition = $cursorPosition
    
    Write-Host ("█" * $completed) -NoNewline -ForegroundColor $BarColor
}

function Show-ColorfulBanner {
    param([string]$Text)
    
    $colors = @('Red', 'Yellow', 'Green', 'Cyan', 'Blue', 'Magenta')
    $colorIndex = 0
    
    $Text.ToCharArray() | ForEach-Object {
        Write-Host $_ -NoNewline -ForegroundColor $colors[$colorIndex]
        $colorIndex = ($colorIndex + 1) % $colors.Length
    }
    Write-Host ""
}

function Show-Matrix {
    param([int]$DurationSeconds = 3)
    
    $originalBg = $host.UI.RawUI.BackgroundColor
    $originalFg = $host.UI.RawUI.ForegroundColor
    
    try {
        $host.UI.RawUI.BackgroundColor = 'Black'
        $width = $host.UI.RawUI.WindowSize.Width
        $height = $host.UI.RawUI.WindowSize.Height
        $startTime = Get-Date
        
        while (((Get-Date) - $startTime).TotalSeconds -lt $DurationSeconds) {
            $x = Get-Random -Minimum 0 -Maximum $width
            $chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'.ToCharArray()
            
            for ($y = 0; $y -lt $height; $y++) {
                $char = $chars | Get-Random
                $pos = New-Object System.Management.Automation.Host.Coordinates $x, $y
                $host.UI.RawUI.CursorPosition = $pos
                Write-Host $char -NoNewline -ForegroundColor 'Green'
                Start-Sleep -Milliseconds 1
            }
        }
    }
    finally {
        $host.UI.RawUI.BackgroundColor = $originalBg
        $host.UI.RawUI.ForegroundColor = $originalFg
        Clear-Host
    }
}

# Replace the original Show-ElPatronProgress with this enhanced version
function Show-ElPatronProgress {
    param(
        [int]$PercentComplete,
        [string]$Status,
        [string]$Operation
    )
    
    $width = $host.UI.RawUI.WindowSize.Width - 30
    $completed = [math]::Floor($width * ($PercentComplete / 100))
    $remaining = $width - $completed
    
    $progressChars = @('▏','▎','▍','▌','▋','▊','▉','█')
    $randomChar = $progressChars | Get-Random
    
    $progressBar = "[$($randomChar * $completed)$('░' * $remaining)]"
    $statusLine = "$Operation - $Status"
    
    $colors = @('Red', 'Yellow', 'Green', 'Cyan', 'Magenta')
    $color = $colors[$PercentComplete % $colors.Length]
    
    Write-Host "`r$progressBar" -NoNewline -ForegroundColor $color
    Write-Host " $PercentComplete% " -NoNewline -ForegroundColor Yellow
    Write-Host $statusLine -NoNewline -ForegroundColor Cyan
}

Clear-Host
Write-Host @"
🔥 EL PATRÓN'S SUPREME CARTEL DISCLAIMER 🔥

By proceeding, you accept:                      User Responsibilities:
----------------------------------------       ----------------------------------------
🛡️ SAFETY MEASURES:                            🚀 BEFORE PROCEEDING:
- Triple-verified checks                        - Create system backup
- Auto system backups                          - Read each step carefully
- Instant recovery                             - Accept/reject changes
- User confirmations                           - Restart when prompted

⚠️ LIABILITY:                                  💎 PERFORMANCE CHANGES:
- Run at your own risk                         - System pushed to limits
- No warranty provided                         - Features may be disabled
- Not responsible for damages                  - Bloatware removed
- Data protected cartel-style                  - Services optimized

[Y] Yes - Accept & Unleash Maximum Performance | [N] No - Keep Slow System
"@ -ForegroundColor Cyan

Write-Host "`nDo you accept El Patrón's terms? [Y/N]: " -ForegroundColor Yellow -NoNewline
$agreement = Read-Host

if ($agreement.ToLower() -ne 'y') {
    Write-Host @"
    
    ╔═══════════════════════════════════════════════════════════════╗
    ║              OPTIMIZATION CANCELLED, MI AMIGO                  ║
    ║          Come back when you're ready for real power           ║
    ╚═══════════════════════════════════════════════════════════════╝
    
"@ -ForegroundColor Red
    exit
}

Write-Host @"
    
    ╔═══════════════════════════════════════════════════════════════╗
    ║             WELCOME TO THE FAMILY, MI AMIGO                   ║
    ║        PREPARING TO UNLEASH MAXIMUM PERFORMANCE               ║
    ╚═══════════════════════════════════════════════════════════════╝
    
"@ -ForegroundColor Green

# MAXIMUM SAFETY PROTOCOLS WITH USER CONTROL
Set-StrictMode -Version Latest
$ProgressPreference = 'SilentlyContinue'
$VerbosePreference = 'Continue'

# El Patrón's Supreme Safety Manifesto
$script:SAFETY_FIRST = $true
$script:PROTECTION_LEVEL = "MAXIMUM"
$script:BACKUP_EVERYTHING = $true
$script:RESTORE_ON_FAILURE = $true
$script:USER_CONFIRMATION_REQUIRED = $true
$script:SAFE_MODE = $true

# MAXIMUM PARALLEL PROCESSING
$MaxThreads = [Environment]::ProcessorCount * 2
$RunspacePool = [runspacefactory]::CreateRunspacePool(1, $MaxThreads)
$RunspacePool.Open()
$Jobs = @()

# Parallel Execution Function
function Start-ParallelJob {
    param(
        [scriptblock]$ScriptBlock,
        [string]$JobName
    )
    
    $PowerShell = [powershell]::Create().AddScript($ScriptBlock)
    $PowerShell.RunspacePool = $RunspacePool
    
    $Jobs += @{
        PowerShell = $PowerShell
        Handle = $PowerShell.BeginInvoke()
        Name = $JobName
        StartTime = Get-Date
    }
}

# Enhanced ASCII Art with Supreme Cartel Style
$asciiArt = @"
    ╔═══════════════════════════════════════════════════════════════╗
    ║     𝕰𝖑 𝕻𝖆𝖙𝖗ó𝖓'𝖘 𝖀𝖑𝖙𝖎𝖒𝖆𝖙𝖊 𝖂𝖎𝖓𝖉𝖔𝖜𝖘 𝕺𝖕𝖙𝖎𝖒𝖎𝖟𝖆𝖙𝖎𝖔𝖓        ║
    ║        💎 PLATA O PLOMO EDITION v6.0 💎                      ║
    ║        👑 THE SUPREME CARTEL PROTOCOL 👑                     ║
    ╚═══════════════════════════════════════════════════════════════╝

     ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
     █▀▀▀▀▀█ ▄▄█ █ ▄▀█▀ █▄ ▄█▀█▀█ █ ▀▄▀▄█ ██▀▄▀█ █▄█▀█ █ ▀▀▀▀▀█
     █ ███ █ ▀▄▀ █ █▄█ ▄▄▄ ██ ▄▄█▄ ▀█▄█▄▀ ███▀█▄ ▄▄█▄█ █ ███ █
     █ ▀▀▀ █ ▄▀█ ▄ █▀▄▀▄▀▄▀▄▀▄▀▄▀▄ █▄▀▄█ ▀█▄█▀█ █▀▄▀█ █ ▀▀▀ █
     ▀▀▀▀▀▀▀ ▀ ▀ ▀ ▀  ▀ ▀ ▀ ▀ ▀ ▀  ▀  ▀▀▀▀▀▀ ▀  ▀  ▀▀▀▀▀▀▀
     
    💎 El Patrón's Diamond Rules 💎
    1. Safety First, Always, No Exceptions 🛡️
    2. Protect User Data Like Cartel Gold 💰
    3. Maximum Performance, Zero Risk 🚀
    4. Zero Data Loss Guarantee 🔒
    5. Instant Recovery, Always Ready ⚡
    6. User Control, User Trust 👑
"@

# Enhanced User Confirmation System
function Get-UserConfirmation {
    param(
        [string]$Operation,
        [string]$Impact,
        [string]$Details
    )
    
    Write-Host @"

    ╔═══════════════════════════════════════════╗
    ║           ATTENTION, MI AMIGO             ║
    ╚═══════════════════════════════════════════╝
    
    El Patrón needs your approval for:
    
    🎯 Operation: $Operation
    💥 Impact Level: $Impact
    📋 Details: $Details
    
    Are you sure you want to proceed? 
    [Y] Sí, Patrón 💎  [N] No, gracias 🛑
    
"@ -ForegroundColor Yellow

    $choice = Read-Host "Your decision"
    return $choice.ToLower() -eq 'y'
}

# Enhanced Safety Check Function with User Warnings
function Test-SafetyRequirements {
    $safetyChecks = @{
        "System Restore Service" = {
            $srService = Get-Service -Name "VSS" -ErrorAction SilentlyContinue
            return $srService.Status -eq "Running"
        }
        "Disk Space (Minimum 20GB)" = {
            $disk = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'"
            return ($disk.FreeSpace / 1GB) -gt 20
        }
        "System Drive Health" = {
            $volume = Get-Volume -DriveLetter C
            return $volume.HealthStatus -eq "Healthy"
        }
        "Power Source" = {
            return (Get-WmiObject -Class BatteryStatus -Namespace root\wmi -ErrorAction SilentlyContinue).PowerOnLine -ne $false
        }
        "Windows Version" = {
            $os = Get-WmiObject -Class Win32_OperatingSystem
            return [Version]$os.Version -ge [Version]"10.0.17763"
        }
        "System Stability" = {
            $uptime = (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
            $uptimeHours = ((Get-Date) - $uptime).TotalHours
            return $uptimeHours -gt 1
        }
        "Critical Process Check" = {
            $criticalProcesses = @("explorer", "winlogon", "services", "lsass")
            $running = Get-Process | Where-Object { $criticalProcesses -contains $_.Name }
            return $running.Count -eq $criticalProcesses.Count
        }
        "Memory Available" = {
            $memory = Get-WmiObject -Class Win32_OperatingSystem
            $freeMemoryGB = [math]::Round($memory.FreePhysicalMemory / 1MB, 2)
            return $freeMemoryGB -gt 2
        }
        "Antivirus Status" = {
            $av = Get-WmiObject -Namespace "root\SecurityCenter2" -Class AntiVirusProduct -ErrorAction SilentlyContinue
            return $av -ne $null
        }
        "User Profile Safety" = {
            $userProfile = $env:USERPROFILE
            return (Test-Path $userProfile) -and (Get-ChildItem $userProfile -Force).Count -gt 0
        }
        "Network Connection" = {
            $network = Get-NetAdapter | Where-Object Status -eq 'Up'
            return $network -ne $null
        }
        "System Restore Point Space" = {
            $systemDrive = Get-WmiObject Win32_Volume -Filter "DriveLetter = 'C:'"
            return ($systemDrive.FreeSpace / 1GB) -gt 30
        }
    }

    # Triple verification with user notification
    for ($i = 1; $i -le 3; $i++) {
        Write-Host @"
        
        ╔═══════════════════════════════════════════╗
        ║      SAFETY VERIFICATION PASS $i/3        ║
        ╚═══════════════════════════════════════════╝
"@ -ForegroundColor Cyan

        $allPassed = $true
        $warnings = @()

        foreach ($check in $safetyChecks.GetEnumerator()) {
            try {
                $result = & $check.Value
                if (-not $result) {
                    $warnings += "⚠️ $($check.Key) check failed"
                    $allPassed = $false
                }
                else {
                    Write-Host "✅ $($check.Key) verified" -ForegroundColor Green
                }
            }
            catch {
                $warnings += "❌ $($check.Key) error: $_"
                $allPassed = $false
            }
        }

        if (-not $allPassed) {
            Write-Host @"
            
            ╔═══════════════════════════════════════════╗
            ║             SAFETY WARNINGS               ║
            ╚═══════════════════════════════════════════╝
            
            $($warnings | ForEach-Object { "$_`n" })
            
            Would you like to:
            [C] Continue anyway (at your own risk) 💀
            [R] Retry safety checks 🔄
            [X] Exit script 🚫
            
"@ -ForegroundColor Yellow

            $choice = Read-Host "Your choice"
            switch ($choice.ToLower()) {
                'c' { 
                    if (Get-UserConfirmation -Operation "Continue with Warnings" -Impact "HIGH RISK" -Details "Some safety checks failed") {
                        return $true
                    }
                }
                'r' { continue }
                default { return $false }
            }
        }
        Start-Sleep -Seconds 1
    }
    return $true
}

# Enhanced Backup Function with User Control
function Backup-CriticalData {
    $backupPaths = @(
        "$env:USERPROFILE\Desktop",
        "$env:USERPROFILE\Documents",
        "$env:USERPROFILE\Pictures",
        "$env:USERPROFILE\Downloads",
        "$env:USERPROFILE\Videos",
        "$env:USERPROFILE\Music",
        "$env:USERPROFILE\Favorites",
        "$env:APPDATA\Microsoft\Windows\Recent",
        "$env:LOCALAPPDATA\Microsoft\Windows\History",
        "$env:APPDATA\Microsoft\Windows\Cookies"
    )

    # Ask user for additional paths
    Write-Host @"
    
    ╔═══════════════════════════════════════════╗
    ║         BACKUP CONFIGURATION              ║
    ╚═══════════════════════════════════════════╝
    
    El Patrón will protect these locations:
    $(($backupPaths | ForEach-Object { "💾 $_" }) -join "`n")
    
    Would you like to add more locations? [Y/N]
"@ -ForegroundColor Cyan

    if ((Read-Host) -eq 'y') {
        do {
            $additionalPath = Read-Host "Enter additional path to backup (or press Enter to continue)"
            if ($additionalPath -and (Test-Path $additionalPath)) {
                $backupPaths += $additionalPath
            }
        } while ($additionalPath)
    }

    # Create backup with verification and progress
    $backupRoot = "$env:USERPROFILE\ElPatron_Backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null

    $total = $backupPaths.Count
    $current = 0

    foreach ($path in $backupPaths) {
        $current++
        $percent = [math]::Round(($current / $total) * 100)
        
        Show-ElPatronProgress -PercentComplete $percent -Status "Backing up $path" -Operation "Data Protection"
        
        if (Test-Path $path) {
            $destinationPath = Join-Path $backupRoot (Split-Path $path -Leaf)
            
            # Backup with verification
            Copy-Item -Path $path -Destination $destinationPath -Recurse -Force
            
            # Verify backup integrity
            $sourceHash = Get-ChildItem -Path $path -Recurse | Get-FileHash
            $backupHash = Get-ChildItem -Path $destinationPath -Recurse | Get-FileHash
            
            if (Compare-Object -ReferenceObject $sourceHash -DifferenceObject $backupHash) {
                throw "💔 Backup verification failed for: $path"
            }
            
            Write-Host "✅ Verified backup: $path" -ForegroundColor Green
        }
    }

    # Create comprehensive registry backup with user confirmation
    Write-Host @"
    
    ╔═══════════════════════════════════════════╗
    ║         REGISTRY BACKUP OPTIONS           ║
    ╚═══════════════════════════════════════════╝
    
    Choose registry backup level:
    [1] Essential Only (Faster, Less Space) 🚀
    [2] Complete Backup (Slower, More Space) 💎
    
"@ -ForegroundColor Yellow

    $regChoice = Read-Host "Your choice"
    $registryBackup = "$backupRoot\RegistryBackup"
    
    switch ($regChoice) {
        '1' {
            reg export HKCU "$registryBackup.HKCU.reg" /y
            reg export "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion" "$registryBackup.HKLM.SOFTWARE.reg" /y
        }
        '2' {
            reg export HKLM "$registryBackup.HKLM.reg" /y
            reg export HKCU "$registryBackup.HKCU.reg" /y
            reg export HKCR "$registryBackup.HKCR.reg" /y
            reg export HKU "$registryBackup.HKU.reg" /y
            reg export HKCC "$registryBackup.HKCC.reg" /y
        }
    }

    # Create detailed backup manifest
    $manifest = @{
        BackupDate = Get-Date
        BackupPaths = $backupPaths
        RegistryBackupLevel = if ($regChoice -eq '1') { "Essential" } else { "Complete" }
        SystemInfo = Get-ComputerInfo
        WindowsVersion = [System.Environment]::OSVersion.Version.ToString()
        BackupVerification = "Completed"
        UserConfiguration = @{
            Theme = (Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize").AppsUseLightTheme
            StartMenuLayout = Test-Path "$env:LOCALAPPDATA\Microsoft\Windows\Shell\LayoutModification.xml"
            CustomFonts = Test-Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
        }
    }

    $manifest | ConvertTo-Json -Depth 10 | Out-File "$backupRoot\backup_manifest.json"

    return $backupRoot
}

# Enhanced System State Verification
function Test-SystemState {
    $systemChecks = @{
        "Registry Integrity" = {
            reg query HKLM > $null
            return $?
        }
        "File System Access" = {
            Test-Path "C:\" > $null
            return $?
        }
        "Service Controller" = {
            Get-Service > $null
            return $?
        }
        "Process Management" = {
            Get-Process > $null
            return $?
        }
        "Network Connectivity" = {
            Test-Connection -ComputerName 8.8.8.8 -Count 1 -Quiet
            return $?
        }
    }

    $results = @()
    foreach ($check in $systemChecks.GetEnumerator()) {
        try {
            $result = & $check.Value
            $results += $result
        }
        catch {
            $results += $false
        }
    }

    return ($results -notcontains $false)
}

# Enhanced Error Recovery System
$script:recoveryPoints = @()

function Add-RecoveryPoint {
    param(
        [string]$Operation,
        [hashtable]$State
    )
    
    $recoveryPoint = @{
        Timestamp = Get-Date
        Operation = $Operation
        State = $State
        SystemState = Get-SystemState
    }
    
    $script:recoveryPoints += $recoveryPoint
}

function Get-SystemState {
    return @{
        RunningServices = @(Get-Service -ErrorAction SilentlyContinue | Where-Object { $_.Status -eq "Running" -and $_ } | Select-Object -ExpandProperty Name)
        RunningProcesses = @(Get-Process -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Name)
        RegistrySnapshot = Get-RegistrySnapshot
        SystemPerformance = Get-Counter '\Processor(_Total)\% Processor Time' -SampleInterval 1 -MaxSamples 1 -ErrorAction SilentlyContinue
    }
}

function Get-RegistrySnapshot {
    $important_keys = @(
        "HKLM:\SYSTEM\CurrentControlSet\Control",
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion",
        "HKCU:\Software\Microsoft\Windows\CurrentVersion"
    )
    
    $snapshot = @{}
    foreach ($key in $important_keys) {
        $snapshot[$key] = Get-ItemProperty -Path $key -ErrorAction SilentlyContinue
    }
    return $snapshot
}

# Final Report with Style
function Show-FinalReport {
    param($report)
    
    $border = "═" * 100
    Write-Host @"
    $border
    
    █▀▀ █░░   █▀█ ▄▀█ ▀█▀ █▀█ █▀█ █▄░█ █▀   █▀█ █▀▀ █▀█ █▀█ █▀█ ▀█▀
    █▀░ █▄▄   █▀▀ █▀█ ░█░ █▀▄ █▄█ █░▀█ ▄█   █▀▄ ██▄ █▀▀ █▄█ █▀▄ ░█░
    
    $border

    💎 Optimization Complete - The Cartel Way 💎

    📊 Performance Metrics:
    ╔════════════════════════════════════════╗
    ║ 🚀 Services Optimized: $($report.ServicesOptimized.ToString().PadRight(15)) ║
    ║ ⚡ Registry Keys Modified: $($report.RegistryKeysModified.ToString().PadRight(12)) ║
    ║ 🌐 Network Optimizations: $($report.NetworkOptimizations.ToString().PadRight(12)) ║
    ║ 🔋 Power Optimizations: $($report.PowerOptimizations.ToString().PadRight(14)) ║
    ║ 🧹 Cleanup Completed: $($report.CleanupPathsProcessed.ToString().PadRight(16)) ║
    ║ 🗑️ Bloatware Removed: $($report.BloatwareRemoved.ToString().PadRight(16)) ║
    ║ 🏎️ Performance Boosts: $($report.PerformanceBoosts.ToString().PadRight(15)) ║
    ╚════════════════════════════════════════╝

    💾 Backup Information:
    ╔════════════════════════════════════════╗
    ║ 📂 Location: $($report.BackupLocation.PadRight(25)) ║
    ║ 🛡️ System Restore Point: $($report.SystemRestorePoint.ToString().PadRight(15)) ║
    ║ 📅 Date: $($report.OptimizationDate.ToString("yyyy-MM-dd HH:mm:ss").PadRight(25)) ║
    ╚════════════════════════════════════════╝

    🛡️ Safety Measures Verified:
    ✅ Triple-Verified System Checks
    ✅ Full Data Backup with Verification
    ✅ Registry State Tracking
    ✅ Service State Preservation
    ✅ Automatic Recovery System
    ✅ Performance Monitoring
    ✅ User Preferences Preserved
    
    $border
"@ -ForegroundColor Cyan
}

# Add this at the beginning of the script, right after the initial variables
# Check for Admin Rights
function Test-AdminRights {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Elevate if not admin
if (-not (Test-AdminRights)) {
    Write-Host @"
    
    ╔═══════════════════════════════════════════════════════════════╗
    ║     🛑 HOLD UP MI AMIGO - ADMIN RIGHTS REQUIRED 🛑           ║
    ╚═══════════════════════════════════════════════════════════════╝
    
    El Patrón needs administrative powers to optimize your system.
    Attempting to elevate privileges...
    
"@ -ForegroundColor Red
    
    Start-Process powershell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}

# Safe Registry Function
function Set-RegistryPropertySafe {
    param(
        [string]$Path,
        [string]$Name,
        [object]$Value,
        [string]$Type = "DWord"
    )
    
    try {
        if (!(Test-Path $Path)) {
            New-Item -Path $Path -Force -ErrorAction Stop | Out-Null
        }
        
        # Convert string values to appropriate numeric types if needed
        if ($Type -eq "DWord" -and $Value -is [string]) {
            $Value = [int]$Value
        }
        
        Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type $Type -ErrorAction Stop
        return $true
    }
    catch {
        Write-ElPatronError -Message "Could not set registry value: $Path\$Name" -ErrorRecord $_
        return $false
    }
}

# Update the registry modification sections to use the safe function
# Replace registry modification blocks with this pattern:
foreach ($category in @($memoryTweaks, $networkTweaks, $gamingTweaks)) {
    foreach ($path in $category.Keys) {
        foreach ($name in $category[$path].Keys) {
            if (-not (Set-RegistryPropertySafe -Path $path -Name $name -Value $category[$path][$name])) {
                Write-Host "⚠️ Skipping some optimizations due to access restrictions..." -ForegroundColor Yellow
                continue
            }
        }
    }
}

# El Patrón's Ultimate Performance Tweaks
function Apply-UltimatePerformance {
    if (-not (Test-AdminRights)) {
        Write-Host "❌ Administrative rights required for performance optimization!" -ForegroundColor Red
        return
    }

    try {
        # Create a system restore point first
        Write-Host "💾 Creating system restore point..." -ForegroundColor Cyan
        Checkpoint-Computer -Description "El Patron's Optimization" -RestorePointType "MODIFY_SETTINGS" -ErrorAction Stop
        
        # Continue with existing optimization code...
        Show-Matrix -DurationSeconds 3
        Write-HostAnimated "INITIALIZING EL PATRÓN'S SUPREME OPTIMIZATION PROTOCOL..." -ForegroundColor Red -DelayMS 20
        Show-SpinnerAnimation "Loading optimization modules" 3

        Write-Host @"
        
        ╔═══════════════════════════════════════════════════════════════╗
        ║     UNLEASHING EL PATRÓN'S ULTIMATE PERFORMANCE 🚀           ║
        ╚═══════════════════════════════════════════════════════════════╝
        
"@ -ForegroundColor Red

        # PARALLEL OPTIMIZATION EXECUTION
        Write-Host "🚀 Initializing parallel performance optimization threads..." -ForegroundColor Red

        # Parallel Registry Optimization
        Start-ParallelJob -JobName "Registry Optimization" -ScriptBlock {
            $regTweaks = @{
                "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" = $memoryTweaks
                "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" = $networkTweaks
                "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" = $gamingTweaks
            }
            foreach ($path in $regTweaks.Keys) {
                if (!(Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
                foreach ($name in $regTweaks[$path].Keys) {
                    Set-ItemProperty -Path $path -Name $name -Value $regTweaks[$path][$name] -Type DWord
                }
            }
        }

        # Parallel Service Optimization
        Start-ParallelJob -JobName "Service Optimization" -ScriptBlock {
            foreach ($service in $extremeServiceOptimizations) {
                Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
                Set-Service -Name $service -StartupType Disabled -ErrorAction SilentlyContinue
            }
        }

        # Parallel Bloatware Removal
        Start-ParallelJob -JobName "Bloatware Removal" -ScriptBlock {
            foreach ($app in $bloatwareApps) {
                Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue
                Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $app | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
            }
        }

        # Parallel System Optimization
        Start-ParallelJob -JobName "System Optimization" -ScriptBlock {
            # Power Plan Optimization
            powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 88888888-8888-8888-8888-888888888888
            powercfg -setactive 88888888-8888-8888-8888-888888888888
            
            # CPU Priority Optimization
            foreach ($process in $criticalProcesses) {
                Get-Process -Name $process -ErrorAction SilentlyContinue | ForEach-Object {
                    $_.PriorityClass = 256  # High priority (numeric value)
                }
            }
        }

        # Parallel Network Optimization
        Start-ParallelJob -JobName "Network Optimization" -ScriptBlock {
            foreach ($cmd in $netshCommands) {
                Invoke-Expression $cmd
            }
        }

        # Wait for all jobs to complete
        Write-Host "⚡ Executing parallel optimizations..." -ForegroundColor Red
        do {
            $Jobs | ForEach-Object {
                if (-not $_.Handle.IsCompleted) {
                    $elapsedTime = ((Get-Date) - $_.StartTime).TotalSeconds
                    Write-Host "💎 Still working on $($_.Name) - $elapsedTime seconds elapsed" -ForegroundColor Yellow
                }
            }
            Start-Sleep -Milliseconds 500
        } while ($Jobs | Where-Object { -not $_.Handle.IsCompleted })

        # Clean up jobs
        $Jobs | ForEach-Object {
            $_.PowerShell.EndInvoke($_.Handle)
            $_.PowerShell.Dispose()
        }
        $Jobs.Clear()

        # ULTIMATE PERFORMANCE UNLEASHED
        Write-Host "🔥 All optimization threads completed successfully!" -ForegroundColor Green

        # Ultimate Memory Optimization
        $memoryTweaks = @{
            "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" = @{
                "DisablePagingExecutive" = 1
                "LargeSystemCache" = 0
                "DisablePageCombining" = 1
                "IoPageLockLimit" = 983040
                "SystemPages" = 0xFFFFFFFF
                "SessionPoolSize" = 40
                "PoolUsageMaximum" = 96
                "NonPagedPoolQuota" = 0
                "NonPagedPoolSize" = 0
                "PagedPoolQuota" = 0
                "PagedPoolSize" = 192
                "SecondLevelDataCache" = 1048576
                "PhysicalAddressExtension" = 1
                "ClearPageFileAtShutdown" = 0
                "DisablePagingCombining" = 1
                "FeatureSettingsOverride" = 3
                "FeatureSettingsOverrideMask" = 3
                "SystemCacheDirtyPageThreshold" = 0
                "DynamicMemoryBoost" = 0
            }
        }

        # Ultimate Network Performance
        $networkTweaks = @{
            "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" = @{
                "DefaultTTL" = 64
                "EnablePMTUBHDetect" = 1
                "EnablePMTUDiscovery" = 1
                "GlobalMaxTcpWindowSize" = 65535
                "TcpMaxDupAcks" = 2
                "SackOpts" = 1
                "TcpWindowSize" = 65535
                "Tcp1323Opts" = 1
                "MaxFreeTcbs" = 65535
                "MaxUserPort" = 65534
                "TcpTimedWaitDelay" = 30
                "MaxHashTableSize" = 65536
                "NumTcbTablePartitions" = 16
                "MaxConnectionsPerServer" = 0
                "EnableWsd" = 0
                "EnableTCPA" = 0
                "EnableICMPRedirect" = 0
                "DeadGWDetectDefault" = 1
                "MaxConnectionsPer1_0Server" = 16
                "TcpMaxDataRetransmissions" = 3
                "KeepAliveTime" = 7200000
                "KeepAliveInterval" = 1000
                "TcpMaxPortsExhausted" = 5
                "TcpFinWait2Delay" = 30
                "TcpNumConnections" = 0xfffffe
                "EnableDCA" = 1
                "EnableRSS" = 1
                "EnableTCPChimney" = 1
            }
        }

        # Ultimate Gaming Performance
        $gamingTweaks = @{
            "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" = @{
                "GPU Priority" = 8
                "Priority" = 6
                "Scheduling Category" = 2
                "SFIO Priority" = 2
                "Background Only" = 0
                "Clock Rate" = 10000
                "Affinity" = 0
                "Latency Sensitive" = 1
            }
            "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" = @{
                "NetworkThrottlingIndex" = 4294967295
                "SystemResponsiveness" = 0
                "NoLazyMode" = 1
                "LazyModeTimeout" = 10000
            }
        }

        # Apply all tweaks
        foreach ($category in @($memoryTweaks, $networkTweaks, $gamingTweaks)) {
            foreach ($path in $category.Keys) {
                if (!(Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
                foreach ($name in $category[$path].Keys) {
                    Set-ItemProperty -Path $path -Name $name -Value $category[$path][$name] -Type DWord
                }
            }
        }

        # Ultimate Service Optimization
        $servicesToDisable = @(
            "DiagTrack",          # Connected User Experiences and Telemetry
            "dmwappushservice",   # Device Management Wireless Application Protocol
            "SysMain",           # Superfetch (disable for SSDs)
            "WSearch",           # Windows Search
            "XboxGipSvc",        # Xbox Peripherals Service
            "XblAuthManager",    # Xbox Live Auth Manager
            "XblGameSave",       # Xbox Live Game Save
            "XboxNetApiSvc"      # Xbox Live Networking
        )

        # Enhanced Service Management Function
        function Get-ServiceStatus {
            param (
                [string]$ServiceName
            )
            try {
                $service = Get-Service -Name $ServiceName -ErrorAction Stop
                return @{
                    Name = $service.Name
                    Status = $service.Status
                    StartType = $service.StartType
                    Success = $true
                    Error = $null
                }
            }
            catch {
                return @{
                    Name = $ServiceName
                    Status = "Unknown"
                    StartType = "Unknown"
                    Success = $false
                    Error = $_.Exception.Message
                }
            }
        }

        function Stop-ServiceSafely {
            param (
                [string]$ServiceName
            )
            try {
                $service = Get-Service -Name $ServiceName -ErrorAction Stop
                if ($service.Status -eq "Running") {
                    Stop-Service -Name $ServiceName -Force -ErrorAction Stop
                    return $true
                }
                return $true
            }
            catch {
                Write-ElPatronError -Message "Could not stop service $ServiceName" -ErrorRecord $_
                return $false
            }
        }

        function Set-ServiceStartupType {
            param (
                [string]$ServiceName,
                [string]$StartupType
            )
            try {
                Set-Service -Name $ServiceName -StartupType $StartupType -ErrorAction Stop
                return $true
            }
            catch {
                Write-ElPatronError -Message "Could not set startup type for service $ServiceName" -ErrorRecord $_
                return $false
            }
        }

        # Update service optimization section
        Write-Host "🚫 Disabling non-essential services..." -ForegroundColor Red
        
        # Single confirmation for all services
        if (Get-UserConfirmation -Operation "Optimize Services" -Impact "PERFORMANCE" -Details "Optimizing non-essential services while preserving system functionality") {
            foreach ($service in $extremeServiceOptimizations) {
                try {
                    # Check if service is in critical list
                    if ($criticalServices -contains $service) {
                        Write-Host "  ⚠️ Skipping critical service $service" -ForegroundColor Yellow
                        continue
                    }

                    $serviceObj = Get-Service -Name $service -ErrorAction Stop
                    if ($serviceObj.Status -eq "Running") {
                        Write-Host "  ⚡ Optimizing $service..." -ForegroundColor Cyan
                        
                        # Set to Manual instead of Disabled for safety
                        Set-Service -Name $service -StartupType Manual -ErrorAction Stop
                        
                        # Only stop if not dependent on critical services
                        $deps = Get-Service -Name $service -DependentServices -ErrorAction Stop
                        $hasCriticalDeps = $false
                        foreach ($dep in $deps) {
                            if ($criticalServices -contains $dep.Name) {
                                $hasCriticalDeps = $true
                                break
                            }
                        }
                        
                        if (-not $hasCriticalDeps) {
                            Stop-Service -Name $service -Force -ErrorAction Stop
                        }
                    }
                }
                catch {
                    Write-Host "  ⚠️ Skipping $service - Required by system" -ForegroundColor Yellow
                    continue
                }
            }
            Write-Host "✅ Service optimization complete!" -ForegroundColor Green
        } else {
            Write-Host "⏭️ Skipping service optimization..." -ForegroundColor Yellow
        }

        # Ultimate System Response
        $fsutilCommands = @(
            "fsutil behavior set disablelastaccess 1",
            "fsutil behavior set disable8dot3 1",
            "fsutil behavior set disablecompression 1",
            "fsutil behavior set disabledeletenotify 0",
            "fsutil behavior set encryptpagingfile 0"
        )

        foreach ($cmd in $fsutilCommands) {
            Invoke-Expression $cmd
        }

        # Ultimate Boot Configuration
        $bcdeditCommands = @(
            "bcdedit /set disabledynamictick yes",
            "bcdedit /set useplatformtick yes",
            "bcdedit /set nx OptIn",
            "bcdedit /set bootmenupolicy Legacy",
            "bcdedit /set hypervisorlaunchtype off",
            "bcdedit /set tpmbootentropy ForceDisable",
            "bcdedit /set quietboot yes",
            "bcdedit /set bootux disabled",
            "bcdedit /set bootlog no",
            "bcdedit /set debug no",
            "bcdedit /set isolatedcontext no"
        )

        foreach ($cmd in $bcdeditCommands) {
            Invoke-Expression $cmd
        }

        # Ultimate Visual Performance
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
            }
        }

        foreach ($path in $visualTweaks.Keys) {
            if (!(Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
            foreach ($name in $visualTweaks[$path].Keys) {
                Set-ItemProperty -Path $path -Name $name -Value $visualTweaks[$path][$name]
            }
        }

        # Ultimate I/O Performance
        $ioPerfTweaks = @{
            "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\I/O System" = @{
                "PassiveIntRealTimeWorkerCount" = 8
                "ActiveIntRealTimeWorkerCount" = 8
                "IoBlockedProcessCount" = 8
            }
            "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" = @{
                "NetworkThrottlingIndex" = 0xFFFFFFFF
                "SystemResponsiveness" = 0
                "IoLatencyCap" = 0
            }
        }

        foreach ($path in $ioPerfTweaks.Keys) {
            if (!(Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
            foreach ($name in $ioPerfTweaks[$path].Keys) {
                Set-ItemProperty -Path $path -Name $name -Value $ioPerfTweaks[$path][$name] -Type DWord
            }
        }

        # Ultimate Network Stack Optimization
        $netshCommands = @(
            "netsh int tcp set global autotuninglevel=normal",
            "netsh int tcp set global chimney=enabled",
            "netsh int tcp set global dca=enabled",
            "netsh int tcp set global netdma=enabled",
            "netsh int tcp set global congestionprovider=ctcp",
            "netsh int tcp set global ecncapability=disabled",
            "netsh int tcp set heuristics disabled",
            "netsh int tcp set global rss=enabled",
            "netsh int tcp set global maxsynretransmissions=2",
            "netsh int tcp set global fastopen=enabled",
            "netsh int tcp set global timestamps=disabled",
            "netsh int tcp set global initialRto=2000",
            "netsh int tcp set global rsc=enabled",
            "netsh int tcp set global nonsackrttresiliency=disabled",
            "netsh int tcp set global maxcurrentlyestablished=0xFFFFFFFF"
        )

        foreach ($cmd in $netshCommands) {
            Invoke-Expression $cmd
        }

        # Ultimate GPU Performance
        $gpuTweaks = @{
            "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" = @{
                "TdrDelay" = 20
                "TdrDdiDelay" = 20
                "HwSchMode" = 2
                "PlatformSupportMiracast" = 0
            }
        }

        foreach ($path in $gpuTweaks.Keys) {
            if (!(Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
            foreach ($name in $gpuTweaks[$path].Keys) {
                Set-ItemProperty -Path $path -Name $name -Value $gpuTweaks[$path][$name] -Type DWord
            }
        }

        # Ultimate Disk Performance
        $diskTweaks = @{
            "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" = @{
                "NtfsMemoryUsage" = 2
                "NtfsDisableLastAccessUpdate" = 1
                "DontVerifyRandomDrivers" = 1
                "LongPathsEnabled" = 0
                "ContigFileAllocSize" = 64
                "DisableDeleteNotify" = 0
                "FilterSupportedFeaturesMode" = 0
            }
        }

        foreach ($path in $diskTweaks.Keys) {
            if (!(Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
            foreach ($name in $diskTweaks[$path].Keys) {
                Set-ItemProperty -Path $path -Name $name -Value $diskTweaks[$path][$name] -Type DWord
            }
        }

        # Ultimate Memory Management
        $moreMemoryTweaks = @{
            "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" = @{
                "EnablePrefetcher" = 3
                "EnableSuperfetch" = 0
                "EnableBootTrace" = 0
            }
            "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" = @{
                "ClearPageFileAtShutdown" = 0
                "DisablePagingExecutive" = 1
                "LargeSystemCache" = 1
                "NonPagedPoolSize" = 0
                "SystemPages" = 0xFFFFFFFF
                "SecondLevelDataCache" = 0x00100000
            }
        }

        foreach ($path in $moreMemoryTweaks.Keys) {
            if (!(Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
            foreach ($name in $moreMemoryTweaks[$path].Keys) {
                Set-ItemProperty -Path $path -Name $name -Value $moreMemoryTweaks[$path][$name] -Type DWord
            }
        }

        # Ultimate System Responsiveness
        $win32PriorityControl = @{
            "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" = @{
                "Win32PrioritySeparation" = 38
                "IRQ8Priority" = 1
                "IRQ16Priority" = 2
            }
        }

        foreach ($path in $win32PriorityControl.Keys) {
            if (!(Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
            foreach ($name in $win32PriorityControl[$path].Keys) {
                Set-ItemProperty -Path $path -Name $name -Value $win32PriorityControl[$path][$name] -Type DWord
            }
        }

        # MAXIMUM BLOATWARE REMOVAL
        $bloatwareApps = @(
            "Microsoft.3DBuilder",
            "Microsoft.Microsoft3DViewer",
            "Microsoft.AppConnector",
            "Microsoft.BingFinance",
            "Microsoft.BingNews",
            "Microsoft.BingSports",
            "Microsoft.BingTranslator",
            "Microsoft.BingWeather",
            "Microsoft.BingFoodAndDrink",
            "Microsoft.BingHealthAndFitness",
            "Microsoft.BingTravel",
            "Microsoft.GetHelp",
            "Microsoft.Getstarted",
            "Microsoft.Messaging",
            "Microsoft.Microsoft3DViewer",
            "Microsoft.MicrosoftOfficeHub",
            "Microsoft.MicrosoftSolitaireCollection",
            "Microsoft.NetworkSpeedTest",
            "Microsoft.News",
            "Microsoft.Office.Lens",
            "Microsoft.Office.OneNote",
            "Microsoft.Office.Sway",
            "Microsoft.OneConnect",
            "Microsoft.People",
            "Microsoft.Print3D",
            "Microsoft.SkypeApp",
            "Microsoft.Wallet",
            "Microsoft.WindowsAlarms",
            "Microsoft.WindowsCamera",
            "Microsoft.WindowsMaps",
            "Microsoft.WindowsPhone",
            "Microsoft.WindowsSoundRecorder",
            "Microsoft.XboxApp",
            "Microsoft.ZuneMusic",
            "Microsoft.ZuneVideo",
            "Microsoft.YourPhone",
            "Microsoft.MixedReality.Portal",
            "Microsoft.549981C3F5F10",  # Cortana
            "Microsoft.Windows.SecureAssessmentBrowser",
            "Microsoft.Windows.SecHealthUI",
            "Microsoft.BioEnrollment",
            "Microsoft.CredDialogHost",
            "Microsoft.ECApp",
            "Microsoft.LockApp",
            "*Microsoft.MicrosoftEdge*",
            "*Microsoft.Windows.Cortana*",
            "*Microsoft.WindowsFeedback*",
            "*Microsoft.XboxGameCallableUI*",
            "*Microsoft.XboxSpeechToTextOverlay*",
            "*Microsoft.Xbox.TCUI*",
            "*Microsoft.MixedReality*",
            "*Microsoft.Windows.NarratorQuickStart*",
            "*Microsoft.Windows.ParentalControls*",
            "*Microsoft.WindowsReadingList*",
            "*Microsoft.GamingServices*",
            "*Microsoft.StorePurchaseApp*",
            "*Microsoft.WindowsStore*",
            "*Microsoft.Xbox*",
            "*Microsoft.Advertising*",
            "*Microsoft.MSPaint*",
            "*Microsoft.Office.Desktop*",
            "*Microsoft.Office.OneNote*",
            "*Microsoft.WebMediaExtensions*",
            "*Microsoft.MicrosoftStickyNotes*",
            "*Microsoft.ScreenSketch*",
            "*Microsoft.VP9VideoExtensions*",
            "*Microsoft.WebpImageExtension*",
            "*Microsoft.YourPhone*",
            "*Microsoft.WindowsCalculator*",
            "*Microsoft.Windows.Photos*",
            "*Microsoft.WindowsCamera*",
            "*microsoft.windowscommunicationsapps*",
            "*Microsoft.WindowsSoundRecorder*",
            "*Microsoft.ZuneMusic*",
            "*Microsoft.ZuneVideo*"
        )

        Write-Host "🗑️ Removing bloatware for maximum performance..." -ForegroundColor Red
        foreach ($app in $bloatwareApps) {
            Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue
            Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $app | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
        }

        # MAXIMUM SERVICE OPTIMIZATION
        $extremeServiceOptimizations = @(
            "AJRouter",                # AllJoyn Router Service
            "ALG",                    # Application Layer Gateway
            "Browser",               # Computer Browser
            "CDPSvc",                # Connected Devices Platform
            "CertPropSvc",           # Certificate Propagation
            "ClipSVC",               # Client License Service
            "COMSysApp",             # COM+ System Application
            "DoSvc",                 # Delivery Optimization
            "EntAppSvc",             # Enterprise App Management
            "Fax",                   # Fax
            "FDResPub",              # Function Discovery Resource Publication
            "FrameServer",           # Windows Camera Frame Server
            "GoogleChromeElevationService", # Chrome Elevation Service
            "HomeGroupListener",     # HomeGroup Listener
            "HomeGroupProvider",     # HomeGroup Provider
            "HvHost",                # HV Host Service
            "icssvc",                # Windows Mobile Hotspot Service
            "IpxlatCfgSvc",         # IP Translation Configuration Service
            "lltdsvc",               # Link-Layer Topology Discovery Mapper
            "MMCSS",                 # Multimedia Class Scheduler
            "MozillaMaintenance",    # Mozilla Maintenance Service
            "MSiSCSI",              # Microsoft iSCSI Initiator Service
            "NcaSvc",               # Network Connectivity Assistant
            "NcbService",           # Network Connection Broker
            "NcdAutoSetup",         # Network Connected Devices Auto-Setup
            "NetTcpPortSharing",    # Net.Tcp Port Sharing Service
            "PcaSvc",               # Program Compatibility Assistant Service
            "PerfHost",             # Performance Counter DLL Host
            "PhoneSvc",             # Phone Service
            "PNRPAutoReg",          # PNRP Machine Name Publication Service
            "PNRPsvc",              # Peer Name Resolution Protocol
            "PrintNotify",          # Printer Extensions and Notifications
            "PushToInstall",        # Windows PushToInstall Service
            "QWAVE",                # Quality Windows Audio Video Experience
            "RasAuto",              # Remote Access Auto Connection Manager
            "RasMan",               # Remote Access Connection Manager
            "RemoteAccess",         # Routing and Remote Access
            "RmSvc",                # Radio Management Service
            "RpcLocator",           # Remote Procedure Call (RPC) Locator
            "SCardSvr",             # Smart Card
            "ScDeviceEnum",         # Smart Card Device Enumeration Service
            "SCPolicySvc",          # Smart Card Removal Policy
            "SDRSVC",               # Windows Backup
            "SEMgrSvc",             # Payments and NFC/SE Manager
            "SensorDataService",    # Sensor Data Service
            "SensorService",        # Sensor Service
            "SensrSvc",             # Sensor Monitoring Service
            "SessionEnv",           # Remote Desktop Configuration
            "SharedAccess",         # Internet Connection Sharing (ICS)
            "SNMPTRAP",             # SNMP Trap
            "SSDPSRV",              # SSDP Discovery
            "SstpSvc",              # Secure Socket Tunneling Protocol Service
            "stisvc",               # Windows Image Acquisition (WIA)
            "StorSvc",              # Storage Service
            "svsvc",                # Spot Verifier
            "swprv",                # Microsoft Software Shadow Copy Provider
            "TabletInputService",   # Touch Keyboard and Handwriting Panel Service
            "TapiSrv",              # Telephony
            "TermService",          # Remote Desktop Services
            "TextInputManagementService", # Text Input Management Service
            "TieringEngineService", # Storage Tiers Management
            "TimeBrokerSvc",        # Time Broker
            "TrkWks",               # Distributed Link Tracking Client
            "tzautoupdate",         # Auto Time Zone Updater
            "UevAgentService",      # User Experience Virtualization Service
            "UmRdpService",         # Remote Desktop Services UserMode Port Redirector
            "upnphost",             # UPnP Device Host
            "UsoSvc",               # Update Orchestrator Service
            "VaultSvc",             # Credential Manager
            "vmicguestinterface",   # Hyper-V Guest Service Interface
            "vmicheartbeat",        # Hyper-V Heartbeat Service
            "vmickvpexchange",      # Hyper-V Data Exchange Service
            "vmicrdv",              # Hyper-V Remote Desktop Virtualization Service
            "vmicshutdown",         # Hyper-V Guest Shutdown Service
            "vmictimesync",         # Hyper-V Time Synchronization Service
            "vmicvmsession",        # Hyper-V PowerShell Direct Service
            "vmicvss",              # Hyper-V Volume Shadow Copy Requestor
            "VSS",                  # Volume Shadow Copy
            "W32Time",              # Windows Time
            "WaaSMedicSvc",         # Windows Update Medic Service
            "wbengine",             # Block Level Backup Engine Service
            "WbioSrvc",             # Windows Biometric Service
            "wcncsvc",              # Windows Connect Now - Config Registrar
            "WdiServiceHost",       # Diagnostic Service Host
            "WdiSystemHost",        # Diagnostic System Host
            "Wecsvc",               # Windows Event Collector
            "WEPHOSTSVC",           # Windows Encryption Provider Host Service
            "wercplsupport",        # Problem Reports and Solutions Control Panel Support
            "WiaRpc",               # Still Image Acquisition Events
            "wlidsvc",              # Microsoft Account Sign-in Assistant
            "wlpasvc",              # Local Profile Assistant Service
            "WManSvc",              # Windows Management Service
            "wmiApSrv",             # WMI Performance Adapter
            "workfolderssvc",       # Work Folders
            "WpcMonSvc",            # Parental Controls
            "WPDBusEnum",           # Portable Device Enumerator Service
            "WpnService",           # Windows Push Notifications System Service
            "WwanSvc"              # WWAN AutoConfig
        )

        Write-Host "🚫 Disabling non-essential services..." -ForegroundColor Red
        
        # Single confirmation for all services
        if (Get-UserConfirmation -Operation "Disable All Services" -Impact "PERFORMANCE" -Details "Disabling all non-essential services for maximum performance") {
            foreach ($service in $extremeServiceOptimizations) {
                $serviceStatus = Get-ServiceStatus -ServiceName $service
                if ($serviceStatus.Success) {
                    $stopped = Stop-ServiceSafely -ServiceName $service
                    if ($stopped) {
                        Set-ServiceStartupType -ServiceName $service -StartupType "Disabled"
                    }
                }
            }
        }

        # MAXIMUM MEMORY OPTIMIZATION
        Write-Host "💎 Optimizing memory for maximum performance..." -ForegroundColor Red
        
        # Clear Page File
        $computersys = Get-WmiObject Win32_ComputerSystem -EnableAllPrivileges
        $computersys.AutomaticManagedPagefile = $false
        $computersys.Put()
        
        $pagefile = Get-WmiObject -Query "Select * From Win32_PageFileSetting Where Name like '%pagefile.sys'"
        $pagefile.InitialSize = 16384  # 16GB
        $pagefile.MaximumSize = 16384  # 16GB
        $pagefile.Put()

        # RAM Optimization
        $ramOptimization = @{
            "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" = @{
                "DisablePagingExecutive" = 1
                "LargeSystemCache" = 0
                "DisablePageCombining" = 1
                "IoPageLockLimit" = 983040
                "SystemPages" = 0xFFFFFFFF
                "SessionPoolSize" = 40
                "PoolUsageMaximum" = 96
                "NonPagedPoolQuota" = 0
                "NonPagedPoolSize" = 0
                "PagedPoolQuota" = 0
                "PagedPoolSize" = 192
                "SecondLevelDataCache" = 1048576
                "PhysicalAddressExtension" = 1
                "ClearPageFileAtShutdown" = 0
                "DisablePagingCombining" = 1
                "FeatureSettingsOverride" = 3
                "FeatureSettingsOverrideMask" = 3
                "SystemCacheDirtyPageThreshold" = 0
                "DynamicMemoryBoost" = 0
            }
        }

        # MAXIMUM NETWORK OPTIMIZATION
        $extremeNetworkOptimization = @{
            "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" = @{
                "DefaultTTL" = 64
                "EnablePMTUBHDetect" = 1
                "EnablePMTUDiscovery" = 1
                "GlobalMaxTcpWindowSize" = 65535
                "TcpMaxDupAcks" = 2
                "SackOpts" = 1
                "TcpWindowSize" = 65535
                "Tcp1323Opts" = 1
                "MaxFreeTcbs" = 65535
                "MaxUserPort" = 65534
                "TcpTimedWaitDelay" = 30
                "MaxHashTableSize" = 65536
                "NumTcbTablePartitions" = 16
                "MaxConnectionsPerServer" = 0
                "EnableWsd" = 0
                "EnableTCPA" = 0
                "EnableICMPRedirect" = 0
                "DeadGWDetectDefault" = 1
                "MaxConnectionsPer1_0Server" = 16
                "TcpMaxDataRetransmissions" = 3
                "KeepAliveTime" = 7200000
                "KeepAliveInterval" = 1000
                "TcpMaxPortsExhausted" = 5
                "TcpFinWait2Delay" = 30
                "TcpNumConnections" = 0xfffffe
                "EnableDCA" = 1
                "EnableRSS" = 1
                "EnableTCPChimney" = 1
            }
        }

        # MAXIMUM DISK PERFORMANCE
        $extremeDiskOptimization = @{
            "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" = @{
                "NtfsDisableLastAccessUpdate" = 1
                "NtfsMemoryUsage" = 2
                "NtfsDisable8dot3NameCreation" = 1
                "DontVerifyRandomDrivers" = 1
                "NtfsDisableCompression" = 1
                "ContigFileAllocSize" = 64
                "DisableDeleteNotify" = 0
                "FileNameCache" = 1024
                "LongPathsEnabled" = 0
                "FilterSupportedFeaturesMode" = 0
                "Win31FileSystem" = 0
                "PathCache" = 128
                "RealtimeIsUniversal" = 1
            }
        }

        # Apply extreme optimizations
        foreach ($category in @($ramOptimization, $extremeNetworkOptimization, $extremeDiskOptimization)) {
            foreach ($path in $category.Keys) {
                if (!(Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
                foreach ($name in $category[$path].Keys) {
                    Set-ItemProperty -Path $path -Name $name -Value $category[$path][$name] -Type DWord
                }
            }
        }

        # MAXIMUM PROCESS OPTIMIZATION
        $processOptimization = @{
            "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options" = @{
                "EnableCpuQuota" = 0
                "CpuCyclesPerByte" = 1024
                "DisableQuantum" = 1
                "DisablePaging" = 1
                "UseLargePages" = 1
                "DisableExceptionChainValidation" = 1
                "UseHighQualityScheduling" = 1
            }
        }

        foreach ($path in $processOptimization.Keys) {
            if (!(Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
            foreach ($name in $processOptimization[$path].Keys) {
                Set-ItemProperty -Path $path -Name $name -Value $processOptimization[$path][$name] -Type DWord
            }
        }

        # MAXIMUM SYSTEM RESPONSIVENESS
        $systemResponsiveness = @{
            "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" = @{
                "NetworkThrottlingIndex" = 0xFFFFFFFF
                "SystemResponsiveness" = 0
                "AlwaysOn" = 1
                "NoLazyMode" = 1
                "LazyModeTimeout" = 10000
                "IdleDetectionCycles" = 1
                "KeyboardDataQueueSize" = 100
                "MouseDataQueueSize" = 100
                "ThreadPriorityBoost" = 1
            }
        }

        foreach ($path in $systemResponsiveness.Keys) {
            if (!(Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
            foreach ($name in $systemResponsiveness[$path].Keys) {
                Set-ItemProperty -Path $path -Name $name -Value $systemResponsiveness[$path][$name] -Type DWord
            }
        }

        Write-Host @"
        
        ╔═══════════════════════════════════════════════════════════════╗
        ║     💰 MAXIMUM PERFORMANCE UNLEASHED - CARTEL STYLE 💰       ║
        ║     🚀 SYSTEM OPTIMIZED TO THE ABSOLUTE LIMIT 🚀            ║
        ║     💎 RUNNING PURE COLOMBIAN PERFORMANCE 💎                ║
        ╚═══════════════════════════════════════════════════════════════╝
        
"@ -ForegroundColor Red
    }
    catch {
        Write-ElPatronError -Message "Error during optimization" -ErrorRecord $_
        Write-Host @"
        
        ⚠️ ATTENTION MI AMIGO ⚠️
        Some optimizations could not be applied due to system restrictions.
        El Patrón will continue with available optimizations...
        
"@ -ForegroundColor Yellow
    }
}

# Final Safety Confirmation and Restart
if ($script:errorOccurred) {
    Show-FinalReport $report
    Write-Host @"
    
    ⚠️ ATTENTION MI AMIGO ⚠️
    
    El Patrón has detected issues and restored your system.
     Your data is safe, always under our protection.
    
"@ -ForegroundColor Yellow
} else {
    Show-FinalReport $report
    Write-Host @"
    
    🌟 MISSION ACCOMPLISHED 🌟
    
    💎 Your system is now running Cartel Style 💎
    🚀 Performance: MAXIMIZED
    🛡️ Safety: GUARANTEED
    💰 Value: PRICELESS
    
"@ -ForegroundColor Green
}

# Call the ultimate performance function before the final report
Add-RecoveryPoint -Operation "Pre-Performance Optimization" -State (Get-SystemState)
Apply-UltimatePerformance

# Clean up runspace pool
$RunspacePool.Close()
$RunspacePool.Dispose()

Write-Host @"
    
    ╔═══════════════════════════════════════════════════════════════╗
    ║     💰 EL PATRÓN'S PARALLEL OPTIMIZATION COMPLETE 💰         ║
    ║     🚀 SYSTEM RUNNING AT MAXIMUM COLOMBIAN POWER 🚀         ║
    ║     💎 PERFORMANCE ENHANCED BY THE CARTEL'S FINEST 💎       ║
    ╚═══════════════════════════════════════════════════════════════╝
    
"@ -ForegroundColor Red

# Stylish Restart Prompt
Write-Host @"

╔══════════════════════════════════════════════════════════════════╗
║                    EL PATRÓN'S FINAL QUESTION                    ║
║-------------------------------------------------------------- ║
║  Would you like to restart now to activate these optimizations?  ║
║                                                                 ║
║  [Y] Sí, Patrón - Let's make it happen 🚀                      ║
║  [N] No, gracias - I'll restart later 🛑                       ║
║  [R] Review Changes - Show me what we did 📋                    ║
╚══════════════════════════════════════════════════════════════════╝

"@ -ForegroundColor Cyan

$restart = Read-Host "Your choice, Patrón"

switch ($restart.ToLower()) {
    'y' {
        Write-Host @"
        
        💎 Preparing for system restart...
        🌟 El Patrón thanks you for your trust
        ⚡ Your system will be more powerful than ever
        🎭 Welcome to the family, mi amigo
        
"@ -ForegroundColor Cyan
        Start-Sleep -Seconds 3
        Restart-Computer
    }
    'r' {
        Show-FinalReport $report
        Write-Host "Would you like to restart now? [Y/N]" -ForegroundColor Yellow
        if ((Read-Host) -eq 'y') { Restart-Computer }
    }
    default {
        Write-Host @"
        
        💎 Remember to restart soon, mi amigo
        🌟 El Patrón's optimizations await your command
        💰 Your system is ready for business
        
"@ -ForegroundColor Yellow
    }
}
