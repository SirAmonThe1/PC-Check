# Settings
Set-ExecutionPolicy Bypass -Scope Process -Force
Write-Host -ForegroundColor Red "Aktueller Pfad"
$scriptFolder   = Split-Path -Parent $MyInvocation.MyCommand.Path
Write-Host $scriptFolder

Get-ChildItem $scriptFolder\modules\*.psm1 | Import-Module -Force

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

# Install chocolately, the minimum requirement


Write-Host
	Write-Output "****"
	Write-Output "#####################"
	Write-Output "# ----- Install chocolately, the minimum requirement"
	Write-Output "#####################"
	Write-Output "****"
Write-Host

Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
#Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Import all Modules
Write-Host
Get-ChildItem .\modules\*.psm1 | Import-Module -Force
Write-Host
    
	#####################
	# Vorbereitung
	#####################
	

	Write-Output "****"
	Write-Output "****"
	Write-Output "****"
	Write-Output "# ----- Beginning the Set-Up"
	Write-Output "****"
	Write-Output "****"
	Write-Output "****"
	
Write-Host
	
	#####################
	# Windows-Einstellungen
	#####################
	
	Write-Output "****"
	Write-Output "#####################"
	Write-Output "# ----- Windows-Einstellungen"
	Write-Output "#####################"
	Write-Output "****"
	Write-Host
	
	# !!! KOPIEREN AUS DEM EINSTELLUNGEN-SKRIPT 
	# Z:\daniel\Drive\1 Dokumente\20 Arbeit\02 IT-Service Remke\01_Organisation\07_Checklisten+Tools\11_Einstellungen

	Write-Output "## Set-HidePeopleOnTaskbar $true"
    Set-HidePeopleOnTaskbar $true
    
	Write-Host
	Write-Output "## Set-ShowSearchOnTaskbar $value"
    Set-ShowSearchOnTaskbar "1"
	
		<#SearchboxTaskbarMode:
		0 = In der Taskleiste wird kein Suchfeld und kein Suchsymbol angezeugt.
		1 = In der Taskleiste wird nur das Suchsymbol für die Suche angezeigt.
		2 = In der Taskleiste wird direkt zur Eingabe das Suchfeld angezeigt. (Standard)
		#>
	
	Write-Host
	Write-Output "## Set-AllowCortana $value"
    Set-AllowCortana "0"
		#0 = Disable / 1 or delete = Enable
    
	#Write-Output "## Set-SmallButtonsOnTaskbar $true"
    #Set-SmallButtonsOnTaskbar $true
    
	Write-Host
	Write-Output "## Set-MultiMonitorTaskbarMode "2""
    Set-MultiMonitorTaskbarMode "2"
    
	Write-Host
	Write-Output "## Set-DisableWindowsDefender $true"
    Set-DisableWindowsDefender $false
    
	Write-Host
	Write-Output "## Set-DarkTheme $true"
    Set-DarkTheme $true

	#Write-Output "## Set-ColorTheme $true"
    #Set-ColouTheme $true
    
	Write-Host
	Write-Output "## Set-DisableLockScreen $true"
    Set-DisableLockScreen $true
    
	Write-Host
	Write-Output "## Set-DisableAeroShake $true"
    Set-DisableAeroShake $true
    
	Write-Host
	Write-Output "## Set-EnableLongPathsForWin32 $true"
    Set-EnableLongPathsForWin32 $true
    
	Write-Host
	Write-Output "## Set-OtherWindowsStuff"
    Set-OtherWindowsStuff
	        
	## Write-Output "## Disable-AdministratorSecurityPrompt"
    ## Disable-AdministratorSecurityPrompt
	
	Write-Host
	Write-Output "## Disable-BingSearchInStartMenu"
	Disable-BingSearchInStartMenu
    
	Write-Host
	Write-Output "## Disable-UselessServices"
    Disable-UselessServices
	
	Write-Host
	Write-Output "## Disable-EasyAccessKeyboard"
    Disable-EasyAccessKeyboard
    
	Write-Host
	Write-Output "## Set-FolderViewOptions"
    Set-FolderViewOptions
    
	Write-Host
	Write-Output "## Disable-AeroShaking"
    Disable-AeroShaking
	
	Write-Host
	Write-host "## Enable Photo Viewer"
	reg import $scriptFolder\registys\enable-photo-viewer.reg
	
	Write-Host
	Write-host "## Remove 3D Objects from This PC"
	Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
	Remove-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
	
	Write-Host
	Write-Output "## Deactivate XPS and FAX-Services"
    @(
        "Printing-XPSServices-Features"
        "Printing-XPSServices-Features"
        "FaxServicesClientPackage"
    ) | ForEach-Object { Disable-WindowsOptionalFeature -FeatureName $_ -Online -NoRestart -ErrorAction silentlycontinue}

### Energieeinstellungen setzen
	Write-Host
	Write-Output "## Schnellstart deaktivieren"
	powercfg /hibernate off 

	powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e  # (Ausbalanciert)
	# powercfg -duplicatescheme  a1841308-3541-4fab-bc81-f71556f20b4a  # (Energiesparmodus)
	# powercfg -duplicatescheme  8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c  # (Höchstleistung)
	powercfg -duplicatescheme  94bd7b55-a0ae-4c21-9de4-96bebb1ba1d6  # (Ultimative Leistung)

	
Stop-Process -ProcessName explorer	
	
	
#####################
# SOFTWARE
#####################

Write-Host
	Write-Output "****"
	Write-Output "#####################"
	Write-Output "# ----- SOFTWARE"
	Write-Output "#####################"
	Write-Output "****"
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
		start-process .\software\Kaspersky\kis.exe}
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
	Write-Output "****"
	Write-Output "#####################"
	Write-Output "# ----- Windows-Update"
	Write-Output "#####################"
	Write-Output "****"
	Write-Host 

	Write-Output "PSWindowsUpdate installieren"
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
	Write-Output "****"
	Write-Output "#####################"
	Write-Output "# ----- StoreApps deinstallieren"
	Write-Output "#####################"
	Write-Output "****"
	Write-Host 

    Uninstall-StoreApps


	Write-Output "****"
	Write-Output "#####################"
	Write-Output "# "
	Write-Output "# ----- Fertig"
	Write-Output "# "
	Write-Output "#####################"
	Write-Output "****"

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
