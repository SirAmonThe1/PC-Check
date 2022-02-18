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


$scriptFolder   = Split-Path -Parent $MyInvocation.MyCommand.Path
write-host "Aktueller Pfad: " $scriptFolder
Write-Host "Installationspfad:" $setupPath

if (Test-Path -Path $setupPath\10_modules) {
    Get-ChildItem $setupPath\10_modules\*.psm1 | Import-Module -Force
	write-host
	write-host "Module importiert aus Installationspfad"
} else {

    #Zurück zum Menü

	write-host
	write-host "Bitte zuerst das Skript installieren im Menü"
	& $menuPS1
}
write-host





show-TrennerHeader1 "PC-Check durchführen"


#####################
# Vorbereitung
#####################


show-TrennerHeader2 "Vorbereitung"

show-TrennerInfo "Logging starten"

Start-logging "Log_31_fuer_$PCname"         #   "LogName"

show-TrennerKlein
show-TrennerInfo "PC umbenennen"

Request-RenamePC


#####################
# Windows Update
#####################

show-TrennerHeader2 "Windows Update ausführen"

Start-WindowsUpdatex
	

#####################
# SOFTWARE
#####################

show-TrennerHeader2 "Software"

show-TrennerInfo "installierte Software zu Chocolatey hinzufügen"

get-SW2Choco


#####################
# Bereinigungen und Checks durchführen
#####################

show-TrennerHeader2 "Bereinigungen und Checks durchführen"

show-TrennerInfo "Aufräumen mit CCleaner"
    
    show-Output "CCleaner wird gestartet"
    start-process ccleaner -windowstyle Maximized
    Read-Host ">>> Mit CCleaner fertig aufgeräumt? [Enter]"

show-TrennerKlein
show-TrennerInfo "Systemreport mit HWInfo erstellen"

    show-Output "HWInfo wird gestartet"
    start-process hwinfo -windowstyle Maximized
    Read-Host ">>> Report unter C:\!_Checkup erstellt? [Enter]"

show-TrennerKlein
show-TrennerInfo "S.M.A.R.T Festplatteninfos auslesen mit CrystalDiskInfo"

get-SMARTinfo

show-TrennerKlein
show-TrennerInfo "R/W Geschwindigkeit prüfen mit CrystalDiskMark"

    show-Output "CrystalDiskMark8 wird gestartet"
    start-SW "DiskMark64.exe"
    Read-Host ">>> Geprüft? [Enter]"

show-TrennerKlein
show-TrennerInfo "Speicherplatz auf Festplatten prüfen"

    show-Output "TreeSizeFree wird gestartet"
    start-SW "treesizefree.exe"
    Read-Host ">>> Geprüft? [Enter]"

show-TrennerKlein
show-TrennerInfo "Festplattentest mit ScanNow"

start-scannowtest

show-TrennerKlein
show-TrennerInfo "RAM-Test"

    show-Output "mdsched Ergebnisse werden abgerufen"
    Get-winevent -FilterHashTable @{logname='System'; id='1101'}|?{$_.providername -match 'MemoryDiagnostics-Results'}
    Get-winevent -FilterHashTable @{logname='System'; id='1201'}|?{$_.providername -match 'MemoryDiagnostics-Results'}

show-TrennerKlein
show-TrennerInfo "Treiber-Daten bereinigen"

out-beep

    show-Output "DriverStoreExplorer wird gestartet"
    start-process $softwarePath\DriverStoreExplorer\rapr.exe -windowstyle Maximized
    Read-Host ">>> Geprüft? [Enter]"

show-TrennerKlein
show-TrennerInfo "AdWare Prüfen"

out-beep

    show-Output "AdwCleaner wird gestartet --> Bitte Prüfen aber Bereinigung NICHT durchführen"
    start-process adwcleaner -windowstyle Maximized
    Read-Host ">>> Geprüft? [Enter]"


#####################
# Fertig
#####################

show-TrennerFertig
	
out-beep

show-TrennerInfo "Logging beenden"

Stop-logging 

show-TrennerKlein
show-TrennerInfo "AdwCleaner --> moegliche Bereinigung jetzt durchfuehren"

    Read-Host ">>> Geprueft? [Enter]"

show-TrennerKlein
show-TrennerInfo "Reboot Status"

show-rebootstatus

show-TrennerKlein
show-TrennerInfo "Zurück zum Menü?"

""
Read-Host "Zurück zum Menü? [ENTER]"
& $menuPS1
