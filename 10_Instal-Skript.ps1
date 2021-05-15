# Settings
Set-ExecutionPolicy Bypass -Scope Process -Force


write-host "PowerShell-Prozess mit Admin-Rechten ausfuehren"
[console]::beep(2000,250)
[console]::beep(2000,250)
gsudo
write-host

$setupPath = "C:/!_Checkup_Install"
$modulesPath = "C:/!_Checkup_Install/10_modules"
$registryPath = "C:/!_Checkup_Install/11_registry"
$softwarePath = "C:/!_Checkup_Install/12_software"

Write-Host -ForegroundColor Red "Aktueller Pfad"
$scriptFolder   = Split-Path -Parent $MyInvocation.MyCommand.Path
Write-Host $scriptFolder

Write-Host -ForegroundColor Red "Install Pfad"
Write-Host $setupPath

if (Test-Path -Path $setupPath\10_modules) {
    Get-ChildItem $setupPath\10_modules\*.psm1 | Import-Module -Force
	write-host
	write-host "Importiert aus Install Pfad"
} else {
	write-host
	write-host "Bitte zuerst das Start-Skript '00_Start.ps1' ausfueheren"
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

Write-Host "############################################################"
Write-Host
write-host $LogName
Write-Host
Write-Host "############################################################"

Write-Host
Write-Host "Ausfuehrung des Skriptes in $scriptFolder"
Write-Host

# PC-Rename
Write-Host -BackgroundColor Magenta -ForegroundColor White "##### --- PC-Rename"
Write-Host
Write-Host -ForegroundColor Red ">>> Aktueller Computername"

hostname

Write-Host


$confirmation = Read-Host ">>> Diesen Computer jetzt umbenennen? [y/n]"
    if ($confirmation -eq 'y') {
		$name = Read-Host "Wie soll der Computer benannt werden?"
		Rename-Computer -NewName $name
		Echo " Der Computer muss neue gestartet werden!"}

write-host
    
	#####################
	# Vorbereitung
	#####################
	

	Write-Host "****"
	Write-Host "****"
	Write-Host "****"
	Write-Host "# ----- Beginning the Set-Up"
	Write-Host "****"
	Write-Host "****"
	Write-Host "****"
	
Write-Host
	
	#####################
	# Windows-Einstellungen
	#####################
	
	Write-Host "****"
	Write-Host "#####################"
	Write-Host "# ----- Windows-Einstellungen"
	Write-Host "#####################"
	Write-Host "****"
	Write-Host

	Write-Host "## Set-HidePeopleOnTaskbar $true"
    Set-HidePeopleOnTaskbar $true
	write-host "OK"
    
	Write-Host
	Write-Host "## Set-ShowSearchOnTaskbar $value"
    Set-ShowSearchOnTaskbar "1"
	write-host "OK"
	
		<#SearchboxTaskbarMode:
		0 = In der Taskleiste wird kein Suchfeld und kein Suchsymbol angezeugt.
		1 = In der Taskleiste wird nur das Suchsymbol für die Suche angezeigt.
		2 = In der Taskleiste wird direkt zur Eingabe das Suchfeld angezeigt. (Standard)
		#>
	
	Write-Host
	Write-Host "## Set-AllowCortana $value"
    Set-AllowCortana "0"
	write-host "OK"
		#0 = Disable / 1 or delete = Enable
    
	#Write-Host "## Set-SmallButtonsOnTaskbar $true"
    #Set-SmallButtonsOnTaskbar $true
    
	Write-Host
	Write-Host "## Set-MultiMonitorTaskbarMode "2""
    Set-MultiMonitorTaskbarMode "2"
	write-host "OK"
    
	Write-Host
	Write-Host "## Set-DisableWindowsDefender $true"
    Set-DisableWindowsDefender $false
	write-host "OK"
    
	Write-Host
	Write-Host "## Set-DarkTheme"
    Set-DarkTheme 
	write-host "OK"

	#Write-Host "## Set-ColorTheme $true"
    #Set-ColouTheme $true
    
	Write-Host
	Write-Host "## Set-DisableLockScreen $true"
    Set-DisableLockScreen $true
	write-host "OK"
    
	Write-Host
	Write-Host "## Set-DisableAeroShake $true"
    Set-DisableAeroShake $true
	write-host "OK"
    
	Write-Host
	Write-Host "## Set-EnableLongPathsForWin32 $true"
    Set-EnableLongPathsForWin32 $true
	write-host "OK"
    
	Write-Host
	Write-Host "## Set-OtherWindowsStuff"
    Set-OtherWindowsStuff
	write-host "OK"
	        
	## Write-Host "## Disable-AdministratorSecurityPrompt"
    ## Disable-AdministratorSecurityPrompt
	
	Write-Host
	Write-Host "## Disable-BingSearchInStartMenu"
	Disable-BingSearchInStartMenu
	write-host "OK"
    
	Write-Host
	Write-Host "## Disable-UselessServices"
    Disable-UselessServices
	write-host "OK"
	
	Write-Host
	Write-Host "## Disable-EasyAccessKeyboard"
    Disable-EasyAccessKeyboard
	write-host "OK"
    
	Write-Host
	Write-Host "## Set-FolderViewOptions"
    Set-FolderViewOptions
	write-host "OK"
    
	Write-Host
	Write-Host "## Disable-AeroShaking"
    Disable-AeroShaking
	write-host "OK"
	
	Write-Host
	Write-host "## Enable Photo Viewer"
	reg import $registryPath\enable-photo-viewer.reg
	write-host "OK"
	
	Write-Host
	Write-host "## Remove 3D Objects from This PC"
	Remove-Item -ErrorAction SilentlyContinue -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
	Remove-Item -ErrorAction SilentlyContinue -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
	write-host "OK"
	
	Write-Host
	Write-Host "## Deactivate XPS and FAX-Services"
    @(
        "Printing-XPSServices-Features"
        "Printing-XPSServices-Features"
        "FaxServicesClientPackage"
    ) | ForEach-Object { Disable-WindowsOptionalFeature -FeatureName $_ -Online -NoRestart -ErrorAction silentlycontinue}

### Energieeinstellungen setzen
	Write-Host
	Write-Host "## Schnellstart deaktivieren"
	powercfg /hibernate off 
	write-host "OK"

	powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e  # (Ausbalanciert)
	# powercfg -duplicatescheme  a1841308-3541-4fab-bc81-f71556f20b4a  # (Energiesparmodus)
	# powercfg -duplicatescheme  8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c  # (Höchstleistung)
	powercfg -duplicatescheme  94bd7b55-a0ae-4c21-9de4-96bebb1ba1d6  # (Ultimative Leistung)

	write-host "Explorer neu starten"
	Stop-Process -ProcessName explorer	
	write-host "OK"
	
	
#####################
# SOFTWARE
#####################

Write-Host
	Write-Host "****"
	Write-Host "#####################"
	Write-Host "# ----- SOFTWARE"
	Write-Host "#####################"
	Write-Host "****"
Write-Host
	
Write-Host -ForegroundColor Red "Wichtige Software wird installiert"
Write-Host "Pakete: PSWindowsUpdate PowerShell 7zip notepadplusplus keepassxc adwcleaner vlc googlechrome firefox teamviewer anydesk.install javaruntime adobereader veracrypt"
Write-Host
	
	# Installationen 
	
	cup PSWindowsUpdate PowerShell 7zip notepadplusplus keepassxc adwcleaner vlc googlechrome firefox teamviewer anydesk.install javaruntime adobereader veracrypt --ignore-checksums --limit-output -y


Write-Host -ForegroundColor Magenta ">>> Virenschutz bitte jetzt installieren"
    [console]::beep(2000,250)
    [console]::beep(2000,250)
$confirmation = Read-Host ">>> Kaspersky Internet Security installieren? [y/n]"
    if ($confirmation -eq 'y') {
		start-process $softwarePath\Kaspersky\kis.exe}
	if ($confirmation -eq 'n') {
		Write-Host "Bitte einen anderen Virenschutz aktivieren (evtl. Windows Defender)"}


    [console]::beep(2000,250)
    [console]::beep(2000,250)
Read-Host -Prompt "Virenschutz fertig installiert? [Enter]"

Write-Host "############################################################"
Write-Host "############################################################"

Write-Host
Write-Host -ForegroundColor Red ">>> Installierte Programme"
Write-Host

Get-Package -Provider Programs -IncludeWindowsInstaller | sort-object -Property name | Format-Table -Property Name, Version

Write-Host
Write-Host "############################################################"
Write-Host "############################################################"



#####################
# Windows Update
#####################

Write-Host
	Write-Host "****"
	Write-Host "#####################"
	Write-Host "# ----- Windows-Update"
	Write-Host "#####################"
	Write-Host "****"
	Write-Host 

	Write-Host "PSWindowsUpdate installieren"
	Install-Module -Name PSWindowsUpdate -Force -allowclobber
	
	Write-Host
	Write-Host -ForegroundColor Red ">>> Checking for Windows Updates"
	Write-Host -ForegroundColor DarkGray "This will take a while ..."
	Write-Host
	$updates = Get-WUlist -MicrosoftUpdate
	if ($updates) {
		Write-Host -ForegroundColor Magenta ">>> Updates found:"
		Write-Host ($updates | Format-Table | Out-String)
		Get-WindowsUpdate -Install -MicrosoftUpdate -AcceptAll -IgnoreReboot
	} else {
		Write-Host -ForegroundColor Green ">>> No Windows Updates available!"
	}
	Write-Host
		
Write-Host "############################################################"
Write-Host "############################################################"
	
	Write-Host 
	Write-Host "****"
	Write-Host "#####################"
	Write-Host "# ----- StoreApps deinstallieren"
	Write-Host "#####################"
	Write-Host "****"
	Write-Host 

    Uninstall-StoreApps


	Write-Host "****"
	Write-Host "#####################"
	Write-Host "# "
	Write-Host "# ----- Fertig"
	Write-Host "# "
	Write-Host "#####################"
	Write-Host "****"

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
