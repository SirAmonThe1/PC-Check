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


write-host -BackgroundColor Green -ForegroundColor White "Willkommen bei der Standard-Grundeinrichtung"
write-host

Set-ExecutionPolicy Bypass -Scope Process -Force


Write-Host -BackgroundColor Black -ForegroundColor Cyan "PowerShell-Prozess mit Admin-Rechten ausfuehren"
gsudo
write-host


$scriptFolder   = Split-Path -Parent $MyInvocation.MyCommand.Path
write-host "Aktueller Pfad: " $scriptFolder
Write-Host "Installationspfad:" $setupPath

if (Test-Path -Path $setupPath\10_modules) {
    Get-ChildItem $setupPath\10_modules\*.psm1 | Import-Module -Force
	write-host
	write-host "Module importiert aus Installationspfad"
} else {

    #Zur�ck zum Men�

	write-host
	write-host "Bitte zuerst das Skript installieren im Men�"
	& $menuPS1
}
write-host







show-TrennerHeader1 "Grundeinrichtung starten"

#####################
# Vorbereitung
#####################

show-TrennerHeader2 "Vorbereitung"

show-TrennerInfo "Logging starten"

Start-logging "Log_20_fuer_$PCname"         #   "LogName"

install-teamviewer

show-TrennerKlein
show-TrennerInfo "PC umbenennen"

Request-RenamePC


#####################
# Windows Update
#####################

show-TrennerHeader2 "Windows Update ausf�hren"

Start-WindowsUpdatex


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
	
install-software "Basic"                    # Basic, optional, admin, pccheck

show-TrennerKlein
show-TrennerInfo "Virenschutz installieren"

install-antivir

show-TrennerKlein
show-TrennerInfo "Adobe Reader zum Standard f�r .pdf machen"

Start-Process "C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe"
Read-Host "Fertig? [ENTER]"

show-TrennerKlein
show-TrennerInfo "Unnoetige Software mit Bulk Crap Uninstaller manuell deinstallieren"
 
show-Output "BCUninstaller wird gestartet"

start-process $softwarePath\BCUninstaller\BCUninstaller.exe -windowstyle Maximized

write-host
show-Output "Unnoetige Software bitte jetzt deinstallieren"

out-beep

Read-Host "Fertig deinstalliert? [Enter]"

show-TrennerKlein
show-TrennerInfo "Installierte Programme"

get-SWInstalled


#####################
# Fertig
#####################

show-TrennerFertig
	
out-beep

show-TrennerInfo "Logging beenden"

Stop-logging 

show-TrennerKlein
show-TrennerInfo "Reboot Status"

show-rebootstatus

show-TrennerKlein
show-TrennerInfo "Zur�ck zum Men�?"

""
Read-Host "Zur�ck zum Men�? [ENTER]"
& $menuPS1
