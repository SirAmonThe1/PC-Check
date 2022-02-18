#clear                      #Debugging

#Version
#2022-02-18


#Settings

$repoUrl = "https://raw.githubusercontent.com/SirAmonThe1/PC-Check/master/00_Start.ps1"
$setupPath = "C:/!_Checkup_Install/"
#$setupPath = "D:/Coding/01_GitHub/PC-Check/"       #Debugging
$skriptPath = $setupPath + "00_Skripte/"
$menuPS1 = $setupPath + "01_Menu.ps1"

$modulesPath = $setupPath + "10_modules"
$registryPath = $setupPath + "11_registry"
$softwarePath = $setupPath + "12_software"
$sophiaPath = $softwarePath + "/Sophia_Script"

$PCname = hostname





#Skript




write-host -BackgroundColor Green -ForegroundColor White "Willkommen beim PC-Check - Install-Skript"
write-host

# Settings
Set-ExecutionPolicy Bypass -Scope Process -Force


Write-Host -BackgroundColor Black -ForegroundColor Cyan "PowerShell-Prozess mit Admin-Rechten ausfuehren"
gsudo
write-host



show-Output "Aktueller Pfad"
$scriptFolder   = Split-Path -Parent $MyInvocation.MyCommand.Path
Write-Host $scriptFolder

show-Output "Installationspfad"
Write-Host $setupPath

if (Test-Path -Path $setupPath\10_modules) {
    Get-ChildItem $setupPath\10_modules\*.psm1 | Import-Module -Force
	write-host
	show-Output "Module importiert aus Install Pfad"
} else {

    #Zurück zum Menü

	write-host
	show-Output "Bitte zuerst das Skript installieren im Menü"
	& $menuPS1
}
write-host








show-TrennerHeader1 "Vorbereitungen für PC-Check treffen"


#####################
# Vorbereitung
#####################


show-TrennerHeader2 "Vorbereitung"

show-TrennerInfo "Logging starten"

Start-logging "Log_30_fuer_$PCname"         #   "LogName"

show-TrennerKlein
show-TrennerInfo "PC umbenennen"

Request-RenamePC

	

#####################
# Windows Update
#####################

show-TrennerHeader2 "Windows Updates anzeigen"

Show-WindowsUpdatex


#####################
# Windows-Einstellungen
#####################

show-TrennerHeader2 "Windows Einstellungen"
	
Set-WindowsSettings
	
out-beep

	
#####################
# SOFIA Skript
#####################
	
show-TrennerHeader2 "Sophia-Skript"

Set-SophiaSkript "Basic"                 # Admin triggert Admin-Einstellungen

	
#####################
# SOFTWARE
#####################

show-TrennerHeader2 "Software"

show-TrennerInfo "Installierte Programme vor der Bereinigung"

get-SWInstalled

show-TrennerKlein
show-TrennerInfo "Basic Software installieren"
	
install-software "Basic"                    # Basic, optional, admin, pccheck

show-TrennerKlein
show-TrennerInfo "Virenschutz installieren"

install-antivir

show-TrennerKlein
show-TrennerInfo "Unnoetige Software mit Bulk Crap Uninstaller manuell deinstallieren"
 
show-Output "BCUninstaller wird gestartet"

start-process $softwarePath\BCUninstaller\BCUninstaller.exe -windowstyle Maximized

write-host
show-Output "Unnoetige Software bitte jetzt deinstallieren"

out-beep

Read-Host "Fertig deinstalliert? [Enter]"

show-TrennerKlein
show-TrennerInfo "Installierte Programme nach der Bereinigung"

get-SWInstalled


#####################
# Fertig
#####################

show-TrennerFertig
	
out-beep

show-TrennerInfo "Logging beenden"

Stop-logging 

show-TrennerKlein
show-TrennerInfo "NEUSTARTEN"

show-rebootstatusForce

show-TrennerKlein
show-TrennerInfo "Zurück zum Menü?"

confirm-menu
