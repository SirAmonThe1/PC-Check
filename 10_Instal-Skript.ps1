write-host -BackgroundColor Green -ForegroundColor White "Willkommen beim PC-Check - Install-Skript"
write-host

# Settings
Set-ExecutionPolicy Bypass -Scope Process -Force


Write-Host -BackgroundColor Black -ForegroundColor Magenta "PowerShell-Prozess mit Admin-Rechten ausfuehren"
[console]::beep(2000,250)
[console]::beep(2000,250)
gsudo
write-host

$setupPath = "C:/!_Checkup_Install"
$modulesPath = "C:/!_Checkup_Install/10_modules"
$registryPath = "C:/!_Checkup_Install/11_registry"
$softwarePath = "C:/!_Checkup_Install/12_software"

Write-Host -BackgroundColor Black -ForegroundColor Magenta "Aktueller Pfad"
$scriptFolder   = Split-Path -Parent $MyInvocation.MyCommand.Path
Write-Host $scriptFolder

Write-Host -BackgroundColor Black -ForegroundColor Magenta "Install Pfad"
Write-Host $setupPath

if (Test-Path -Path $setupPath\10_modules) {
    Get-ChildItem $setupPath\10_modules\*.psm1 | Import-Module -Force
	write-host
	write-host "Importiert aus Install Pfad"
} else {
	write-host
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "Bitte zuerst das Start-Skript '00_Start.ps1' ausfueheren"
	$confirmation = Read-Host ">>> jetzt ausfuehren? [y/n]"
    if ($confirmation -eq 'y') {
		iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/SirAmonThe1/PC-Check/master/00_Start.ps1'))
	} else {
		read-host ">>> beliebige Taste duercken zum beenden...   "
		EXIT
	}
}
write-host

# Logging starten
Write-Host -BackgroundColor Magenta -ForegroundColor White "##### --- Logging wird gestartet"

$PCname = hostname
$LogName = "Instal-Log_fuer_$PCname"

start-transcript C:\!_Checkup\$LogName.txt
Write-Host

Write-Host -BackgroundColor Black -ForegroundColor Magenta "############################################################"
Write-Host
Write-Host -BackgroundColor Black -ForegroundColor Magenta "---- $LogName"
Write-Host
Write-Host -BackgroundColor Black -ForegroundColor Magenta "############################################################"

Write-Host
Write-Host -BackgroundColor Black -ForegroundColor Magenta "Ausfuehrung des Skriptes in $scriptFolder"
Write-Host

# PC-Rename
Write-Host -BackgroundColor Black -ForegroundColor Magenta "##### --- PC-Rename"
Write-Host
Write-Host -BackgroundColor Blue -ForegroundColor Cyan ">>> Aktueller Computername"

hostname

Write-Host


$confirmation = Read-Host ">>> Diesen Computer jetzt umbenennen? [y/n]"
    if ($confirmation -eq 'y') {
		$name = Read-Host ">>> Wie soll der Computer benannt werden?"
		Rename-Computer -NewName $name
		Echo " Der Computer muss neue gestartet werden!"}

write-host
    
	#####################
	# Vorbereitung
	#####################
	

	Write-Host -BackgroundColor Black -ForegroundColor Magenta "****"
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "****"
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "****"
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "# ----- Beginning the Set-Up"
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "****"
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "****"
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "****"
	
	Write-Host
	
	#####################
	# Windows-Einstellungen
	#####################
	
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "****"
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "#####################"
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "# ----- Windows-Einstellungen"
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "#####################"
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "****"
	Write-Host

	Write-Host -BackgroundColor Black -ForegroundColor Magenta "## Set-HidePeopleOnTaskbar $true"
    Set-HidePeopleOnTaskbar $true
	Write-Host -BackgroundColor Blue -ForegroundColor Cyan ">>> OK"
    
	Write-Host
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "## Set-ShowSearchOnTaskbar $value"
    Set-ShowSearchOnTaskbar "1"
	Write-Host -BackgroundColor Blue -ForegroundColor Cyan ">>> OK"
	
		<#SearchboxTaskbarMode:
		0 = In der Taskleiste wird kein Suchfeld und kein Suchsymbol angezeugt.
		1 = In der Taskleiste wird nur das Suchsymbol fuer die Suche angezeigt.
		2 = In der Taskleiste wird direkt zur Eingabe das Suchfeld angezeigt. (Standard)
		#>
	
	Write-Host
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "## Set-AllowCortana $value"
    Set-AllowCortana "0"
	Write-Host -BackgroundColor Blue -ForegroundColor Cyan ">>> OK"
		#0 = Disable / 1 or delete = Enable
    
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "## Set-SmallButtonsOnTaskbar $true"
    Set-SmallButtonsOnTaskbar $true
	Write-Host -BackgroundColor Blue -ForegroundColor Cyan ">>> OK"
    
	Write-Host
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "## Set-MultiMonitorTaskbarMode "2""
    Set-MultiMonitorTaskbarMode "2"
	Write-Host -BackgroundColor Blue -ForegroundColor Cyan ">>> OK"
    
	Write-Host
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "## Set-DisableWindowsDefender $true"
    Set-DisableWindowsDefender $false
	Write-Host -BackgroundColor Blue -ForegroundColor Cyan ">>> OK"
    
	Write-Host
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "## Set-DarkTheme"
    Set-DarkTheme 
	Write-Host -BackgroundColor Blue -ForegroundColor Cyan ">>> OK"
    
	Write-Host
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "## Set-DisableLockScreen $true"
    Set-DisableLockScreen $true
	Write-Host -BackgroundColor Blue -ForegroundColor Cyan ">>> OK"
    
	Write-Host
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "## Set-DisableAeroShake $true"
    Set-DisableAeroShake $true
	Write-Host -BackgroundColor Blue -ForegroundColor Cyan ">>> OK"
    
	Write-Host
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "## Set-EnableLongPathsForWin32 $true"
    Set-EnableLongPathsForWin32 $true
	Write-Host -BackgroundColor Blue -ForegroundColor Cyan ">>> OK"
    
	Write-Host
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "## Set-OtherWindowsStuff"
    Set-OtherWindowsStuff
	Write-Host -BackgroundColor Blue -ForegroundColor Cyan ">>> OK"

	Write-Host
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "## Disable-BingSearchInStartMenu"
	Disable-BingSearchInStartMenu
	Write-Host -BackgroundColor Blue -ForegroundColor Cyan ">>> OK"
    
	Write-Host
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "## Disable-UselessServices"
    Disable-UselessServices
	Write-Host -BackgroundColor Blue -ForegroundColor Cyan ">>> OK"
	
	Write-Host
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "## Disable-EasyAccessKeyboard"
    Disable-EasyAccessKeyboard
	Write-Host -BackgroundColor Blue -ForegroundColor Cyan ">>> OK"
    
	Write-Host
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "## Set-FolderViewOptions"
    Set-FolderViewOptions
	Write-Host -BackgroundColor Blue -ForegroundColor Cyan ">>> OK"
	
	Write-Host
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "## Privacy Settings einstellen"
    Protect-Privacy
	Write-Host -BackgroundColor Blue -ForegroundColor Cyan ">>> OK"
	
	Write-Host
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "## Enable Photo Viewer"
	reg import $registryPath\enable-photo-viewer.reg
	Write-Host -BackgroundColor Blue -ForegroundColor Cyan ">>> OK"
	
	Write-Host
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "## Remove 3D Objects from This PC"
	Remove-Item -ErrorAction SilentlyContinue -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
	Remove-Item -ErrorAction SilentlyContinue -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
	Write-Host -BackgroundColor Blue -ForegroundColor Cyan ">>> OK"
	
	Write-Host
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "## Deactivate XPS and FAX-Services"
    @(
        "Printing-XPSServices-Features"
        "Printing-XPSServices-Features"
        "FaxServicesClientPackage"
    ) | ForEach-Object { Disable-WindowsOptionalFeature -FeatureName $_ -Online -NoRestart -ErrorAction silentlycontinue}

### Energieeinstellungen setzen
	Write-Host
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "## Schnellstart deaktivieren"
	powercfg /hibernate off 
	Write-Host -BackgroundColor Blue -ForegroundColor Cyan ">>> OK"

	powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e  # (Ausbalanciert)
	# powercfg -duplicatescheme  a1841308-3541-4fab-bc81-f71556f20b4a  # (Energiesparmodus)
	# powercfg -duplicatescheme  8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c  # (Hoechstleistung)
	powercfg -duplicatescheme  94bd7b55-a0ae-4c21-9de4-96bebb1ba1d6  # (Ultimative Leistung)

	write-host
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "Explorer neu starten"
	Stop-Process -ProcessName explorer	
	Write-Host -BackgroundColor Blue -ForegroundColor Cyan ">>> OK"
	
	
#####################
# SOFTWARE
#####################

Write-Host
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "****"
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "#####################"
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "# ----- SOFTWARE"
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "#####################"
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "****"
Write-Host
	
Write-Host -BackgroundColor Black -ForegroundColor Magenta "Wichtige Software wird installiert"
Write-Host -BackgroundColor Blue -ForegroundColor Cyan ">>> Pakete: PSWindowsUpdate PowerShell 7zip notepadplusplus keepassxc adwcleaner vlc googlechrome firefox teamviewer anydesk.install javaruntime adobereader veracrypt"
Write-Host
	
	# Installationen 
	
	cinst PSWindowsUpdate --ignore-checksums --limit-output -y -f
	cup  PowerShell 7zip notepadplusplus keepassxc adwcleaner vlc googlechrome firefox teamviewer anydesk.install javaruntime adobereader veracrypt --ignore-checksums --limit-output -y


Write-Host -BackgroundColor Black -ForegroundColor Magenta "Virenschutz bitte jetzt installieren"
    [console]::beep(2000,250)
    [console]::beep(2000,250)
$confirmation = Read-Host -ForegroundColor DarkGray ">>> Kaspersky Internet Security installieren? [y/n]"
    if ($confirmation -eq 'y') {
		start-process $softwarePath\Kaspersky\kis.exe}
	if ($confirmation -eq 'n') {
		Write-Host -BackgroundColor Blue -ForegroundColor Cyan ">>> Bitte einen anderen Virenschutz aktivieren (evtl. Windows Defender)"
	}
    [console]::beep(2000,250)
    [console]::beep(2000,250)
Read-Host ">>> Virenschutz fertig installiert? [Enter]"
write-host

Write-Host -BackgroundColor Black -ForegroundColor Magenta "############################################################"
Write-Host -BackgroundColor Black -ForegroundColor Magenta "############################################################"

Write-Host
Write-Host -BackgroundColor Black -ForegroundColor Magenta "--- Installierte Programme"
Write-Host

Get-Package -Provider Programs -IncludeWindowsInstaller | sort-object -Property name | Format-Table -Property Name, Version

Write-Host
Write-Host -BackgroundColor Black -ForegroundColor Magenta "############################################################"
Write-Host -BackgroundColor Black -ForegroundColor Magenta "############################################################"



#####################
# Windows Update
#####################

Write-Host
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "****"
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "#####################"
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "# ----- Windows-Update"
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "#####################"
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "****"
	Write-Host 

	Write-Host -BackgroundColor Black -ForegroundColor Magenta "PSWindowsUpdate installieren"
	Install-Module -Name PSWindowsUpdate -Force -allowclobber
	
	Write-Host
	Write-Host -BackgroundColor Blue -ForegroundColor Cyan ">>> Checking for Windows Updates"
	Write-Host -ForegroundColor DarkGray "This will take a while ..."
	Write-Host
	$updates = Get-WUlist -MicrosoftUpdate
	if ($updates) {
		Write-Host -BackgroundColor Black -ForegroundColor Magenta ">>> Updates found:"
		Write-Host ($updates | Format-Table | Out-String)
		Get-WindowsUpdate -Install -MicrosoftUpdate -AcceptAll -IgnoreReboot
	} else {
		Write-Host -ForegroundColor Green ">>> No Windows Updates available!"
	}
	Write-Host
			
	Write-Host -BackgroundColor Black -ForegroundColor Magenta 
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "****"
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "#####################"
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "# ----- StoreApps deinstallieren"
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "#####################"
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "****"
	Write-Host -BackgroundColor Black -ForegroundColor Magenta 

    Uninstall-StoreApps


	Write-Host -BackgroundColor Black -ForegroundColor Magenta "****"
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "#####################"
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "# "
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "# ----- Fertig"
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "# "
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "#####################"
	Write-Host -BackgroundColor Black -ForegroundColor Magenta "****"

	Write-Host
	Write-Host
	
	[console]::beep(2000,250)
    [console]::beep(2000,250)
	
	# Logging beenden
Write-Host -BackgroundColor Magenta -ForegroundColor White "##### --- Logging wird beendet"

stop-transcript
Write-Host

	
	# Reboot
	Write-Host -BackgroundColor Red -ForegroundColor White "##### --- REBOOT STATUS"
	Write-Host
	Write-Host -ForegroundColor Red ">>> Checking for reboot status"
	$Reboot = Get-WURebootStatus
	if ($Reboot -like "*localhost: Reboot is not required*") {
		Write-Host -ForegroundColor Green ">>> No reboot required"
	} 
