





	
	#####################
	# Windows Update
	#####################

function Start-WindowsUpdatex {
	Write-Host
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "****"
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "#####################"
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "# ----- Windows-Update"
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "#####################"
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "****"
	Write-Host 

	Write-Host -BackgroundColor Black -ForegroundColor Cyan "PSWindowsUpdate installieren"
	Install-Module -Name PSWindowsUpdate -Force -allowclobber
    cinst PSWindowsUpdate --ignore-checksums --limit-output -y -f
	
	Write-Host
	Write-Host -BackgroundColor Blue -ForegroundColor White ">>> Checking for Windows Updates"
	Write-Host -ForegroundColor DarkGray "This will take a while ..."
	Write-Host
	$updates = Get-WUlist -MicrosoftUpdate
	if ($updates) {
		Write-Host -BackgroundColor Black -ForegroundColor Cyan ">>> Updates found:"
		Write-Host ($updates | Format-Table | Out-String)
		Write-Host "--> ausgenommene Updates mit folgenden Wörtern im Titel: Lenovo"
		Get-WindowsUpdate -Install -MicrosoftUpdate -AcceptAll -IgnoreReboot -NotTitle "Lenovo"
	} else {
		Write-Host -ForegroundColor Green ">>> No Windows Updates available!"
	}
	Write-Host
	
}







	#####################
	# Windows-Einstellungen
	#####################


function Set-WindowsSettings {
	
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "****"
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "#####################"
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "# ----- Windows-Einstellungen"
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "#####################"
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "****"
	Write-Host
	
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "## Set-MultiMonitorTaskbarMode "2""
    Set-MultiMonitorTaskbarMode "2"
	Write-Host -BackgroundColor Blue -ForegroundColor White ">>> OK"
    
	Write-Host
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "## Set-DisableLockScreen $true"
    Set-DisableLockScreen $true
	Write-Host -BackgroundColor Blue -ForegroundColor White ">>> OK"
    
	Write-Host
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "## Set-DisableAeroShake $true"
    Set-DisableAeroShake $true
	Write-Host -BackgroundColor Blue -ForegroundColor White ">>> OK"
    
	Write-Host
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "## Set-OtherWindowsStuff z.B Taskbar Glom"
    Set-OtherWindowsStuff
	Write-Host -BackgroundColor Blue -ForegroundColor White ">>> OK"

	Write-Host
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "## Disable-BingSearchInStartMenu"
	Disable-BingSearchInStartMenu
	Write-Host -BackgroundColor Blue -ForegroundColor White ">>> OK"
	
	Write-Host
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "## Enable Photo Viewer"
	reg import $registryPath\enable-photo-viewer.reg
	Write-Host -BackgroundColor Blue -ForegroundColor White ">>> OK"
	
	Write-Host
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "## Remove 3D Objects from This PC"
	Remove-Item -ErrorAction SilentlyContinue -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
	Remove-Item -ErrorAction SilentlyContinue -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
	Write-Host -BackgroundColor Blue -ForegroundColor White ">>> OK"

	### Energieeinstellungen setzen
	Write-Host
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "## Schnellstart deaktivieren"
	powercfg /hibernate off 
	Write-Host -BackgroundColor Blue -ForegroundColor White ">>> OK"

	# powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e  # (Ausbalanciert)
	# powercfg -duplicatescheme  a1841308-3541-4fab-bc81-f71556f20b4a  # (Energiesparmodus)
	# powercfg -duplicatescheme  8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c  # (Hoechstleistung)
	powercfg -duplicatescheme  94bd7b55-a0ae-4c21-9de4-96bebb1ba1d6  # (Ultimative Leistung)
	Write-Host

}










function Install-WindowsFeature($feature) {
    $featureState = Get-WindowsOptionalFeature -Online -FeatureName $feature
    if ($feature -ne "Enabled") {
        Enable-WindowsOptionalFeature -Online -FeatureName $feature -NoRestart | Out-Null
    }
}

function Uninstall-WindowsFeature($feature) {
    $featureState = Get-WindowsOptionalFeature -Online -FeatureName $feature
    if ($feature -eq "Enabled") {
        Disable-WindowsOptionalFeature -Online -FeatureName $feature -NoRestart | Out-Null
    }
}


function Set-RegistryValue([string]$path, [string]$key, $value) {
    reg add $path /t REG_DWORD /f /v $key /d $value
}

function Set-RegistryBool([string]$path, [string]$key, [bool]$enable) {
    $value = "0"
    if ($true -eq $enable) {
        $value = "1"
    }

    Set-RegistryValue $path $key $value
}

function Remove-RegistryKey([string]$path, [string]$key) {
    Remove-ItemProperty -Path $path -Name $key -Force
}

function Remove-RegistryFolder([string]$path) {
    if (Test-Path $path) {
        Remove-Item -Path $path -Recurse -Force
    }
}

function Install-WindowsDeveloperMode {
    Set-RegistryBool "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" "AllowDevelopmentWithoutDevLicense" $true
}

function Set-HidePeopleOnTaskbar([bool]$enable) {
    Set-RegistryBool "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\Explorer" "HidePeopleBar" $enable
    Set-RegistryBool "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Explorer" "HidePeopleBar" $enable
}

function Set-AllowCortana($value) {
    Set-RegistryValue "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" "AllowCortana" $value
}

function Set-ShowSearchOnTaskbar($value) {
    Set-RegistryValue "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" "SearchboxTaskbarMode" $value
    Set-RegistryValue "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" "SearchboxTaskbarMode" $value
}

function Set-SmallButtonsOnTaskbar([bool]$enable) {
    Set-RegistryBool "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarSmallIcons " $enable
    Set-RegistryBool "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarSmallIcons " $enable
}

function Set-MultiMonitorTaskbarMode($value) {
    Set-RegistryValue "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "MMTaskbarMode " $value
    Set-RegistryValue "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "MMTaskbarMode " $value
}

function Set-DisableLockScreen($value) {
    Set-RegistryBool "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Personalization" "NoLockScreen " $value
}

function Set-DisableAeroShake($value) {
    Set-RegistryBool "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\Explorer" "NoWindowMinimizingShortcuts " $value
    Set-RegistryBool "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Explorer" "NoWindowMinimizingShortcuts " $value
}

function Set-EnableLongPathsForWin32($value) {
    Set-RegistryBool "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\FileSystem" "LongPathsEnabled " $value
}

function Set-DisableWindowsDefender([bool]$enable) {
    # Disables Windows Defender. Also impacts third-party antivirus software and apps.
    # https://docs.microsoft.com/en-us/windows-hardware/customize/desktop/unattend/security-malware-windows-defender-disableantispyware
    Set-RegistryValue "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows Defender" "DisableAntiSpyware" "1"
}

function Set-DarkTheme {
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes" -Name "Personalize" -Force
	New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes" -Name "Personalize" -Force
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value "0" -PropertyType "Dword" # 0=Dark / 1=Color
	New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value "0" -PropertyType "Dword" # 0=Dark / 1=Color
}


function Disable-AdministratorSecurityPrompt() {
    # This option SHOULD be used to disable the automatic detection of installation packages that require elevation to install.
    # https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-gpsb/c2b4efc5-2fe8-4dc9-95f7-2417b3d4cc6d
    Set-RegistryValue "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" "EnableInstallerDetection" "0"

    # Disabling this policy disables secure desktop prompting. All credential or consent prompting will occur on the interactive user's desktop.
    # https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-gpsb/9ad50fd3-4d8d-4870-9f5b-978ce292b9d8
    Set-RegistryValue "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" "PromptOnSecureDesktop" "0"

    # This option allows the Consent Admin to perform an operation that requires elevation without consent or credentials.
    # https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-gpsb/341747f5-6b5d-4d30-85fc-fa1cc04038d4
    Set-RegistryValue "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" "ConsentPromptBehaviorAdmin" "0"
}

function Disable-BingSearchInStartMenu {
    Set-RegistryValue "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" "BingSearchEnabled" "0"
}

function Set-OtherWindowsStuff {
    Set-RegistryValue "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "MMTaskbarGlomLevel" "0"
    Set-RegistryValue "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "MMTaskbarGlomLevel" "0"
    Set-RegistryValue "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarGlomLevel" "0"
    Set-RegistryValue "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarGlomLevel" "0"
    Set-RegistryValue "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarSizeMove" "0"
    Set-RegistryValue "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarSizeMove" "0"
    Set-RegistryValue "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ShowSuperHidden" "1"
    Set-RegistryValue "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ShowSuperHidden" "1"
}

function Remove-3dObjectsFolder {
    Remove-RegistryFolder "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
    Remove-RegistryFolder "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
}

function Disable-UselessServices {
    @(
        "diagnosticshub.standardcollector.service" # Microsoft (R) Diagnostics Hub Standard Collector Service
        "DiagTrack"                                # Diagnostics Tracking Service
        "dmwappushservice"                         # WAP Push Message Routing Service (see known issues)
        "lfsvc"                                    # Geolocation Service
        "MapsBroker"                               # Downloaded Maps Manager
        "NetTcpPortSharing"                        # Net.Tcp Port Sharing Service
        #"RemoteAccess"                             # Routing and Remote Access
        #"RemoteRegistry"                           # Remote Registry
        "SharedAccess"                             # Internet Connection Sharing (ICS)
        "TrkWks"                                   # Distributed Link Tracking Client
        "WbioSrvc"                                 # Windows Biometric Service (required for Fingerprint reader / facial detection)
        "WMPNetworkSvc"                            # Windows Media Player Network Sharing Service
        "XblAuthManager"                           # Xbox Live Auth Manager
        "XblGameSave"                              # Xbox Live Game Save Service
        "XboxNetApiSvc"                            # Xbox Live Networking Service
    ) |
    ForEach-Object {
        Get-Service -Name $_ | Set-Service -StartupType Disabled
    }
}

function Disable-EasyAccessKeyboard {
    Set-ItemProperty "HKCU:\Control Panel\Accessibility\StickyKeys" "Flags" "506"
    Set-ItemProperty "HKCU:\Control Panel\Accessibility\Keyboard Response" "Flags" "122"
    Set-ItemProperty "HKCU:\Control Panel\Accessibility\ToggleKeys" "Flags" "58"    
}

function Set-FolderViewOptions {
    Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Hidden" 2							#1=Versteckte Dateien anzeigen / 2=nicht anzeigen
    Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideFileExt" 0					#0=Dateierweiterungen anzeigen / 1=nicht anzeigen
    Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideDrivesWithNoMedia" 0			
		#0 = Es werden alle angeschlossenen Laufwerke (auch ohne Medium) im Ordner "Computer" bzw. "Dieser PC" eingeblendet.
		#1 = Angeschlossene Laufwerke ohne Medium werden im Ordner "Computer" bzw. "Dieser PC" ausgeblendet. (Standard)
    Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ShowSyncProviderNotifications" 1
		#0 = Es werden keine Benachrichtigungen des Synchronisierungsanbieters (OneDrive) mehr im Fenster angezeigt.
		#1 = Es werden ggf. Benachrichtigungen des Synchronisierungsanbieters (OneDrive) im Fenster angezeigt. (Standard)
	Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "LaunchTo" 1
		#1 = Bei einem neuen Explorer-Fenster wird als Inhalt "Dieser PC" (Arbeitsplatz) angezeigt.
		#2 = Bei einem neuen Explorer-Fenster wird als Inhalt der Schnellzugriff angezeigt. (Standard)
}

function Disable-AeroShaking {
    Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "DisallowShaking" 1
}

