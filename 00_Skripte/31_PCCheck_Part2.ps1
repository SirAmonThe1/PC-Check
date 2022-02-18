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

    #Zur�ck zum Men�

	write-host
	write-host "Bitte zuerst das Skript installieren im Men�"
	& $menuPS1
}
write-host





show-TrennerHeader1 "PC-Check durchf�hren"


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

show-TrennerHeader2 "Windows Update ausf�hren"

Start-WindowsUpdatex
	

#####################
# SOFTWARE
#####################

show-TrennerHeader2 "Software"

show-TrennerInfo "installierte Software zu Chocolatey hinzuf�gen"

get-SW2Choco


#####################
# Bereinigungen und Checks durchf�hren
#####################

show-TrennerHeader2 "Bereinigungen und Checks durchf�hren"

show-TrennerInfo "Aufr�umen mit CCleaner"
    
    show-Output "CCleaner wird gestartet"
    start-process ccleaner -windowstyle Maximized
    Read-Host ">>> Mit CCleaner fertig aufger�umt? [Enter]"

show-TrennerKlein
show-TrennerInfo "Systemreport mit HWInfo erstellen"

    show-Output "HWInfo wird gestartet"
    start-process hwinfo -windowstyle Maximized
    Read-Host ">>> Report unter C:\!_Checkup erstellt? [Enter]"

show-TrennerKlein
show-TrennerInfo "S.M.A.R.T Festplatteninfos auslesen mit CrystalDiskInfo"

get-SMARTinfo

show-TrennerKlein
show-TrennerInfo "R/W Geschwindigkeit pr�fen mit CrystalDiskMark"

    show-Output "CrystalDiskMark8 wird gestartet"
    start-SW "DiskMark64.exe"
    Read-Host ">>> Gepr�ft? [Enter]"

show-TrennerKlein
show-TrennerInfo "Speicherplatz auf Festplatten pr�fen"

    show-Output "TreeSizeFree wird gestartet"
    start-SW "treesizefree.exe"
    Read-Host ">>> Gepr�ft? [Enter]"

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
    Read-Host ">>> Gepr�ft? [Enter]"

show-TrennerKlein
show-TrennerInfo "AdWare Pr�fen"

out-beep

    show-Output "AdwCleaner wird gestartet --> Bitte Pr�fen aber Bereinigung NICHT durchf�hren"
    start-process adwcleaner -windowstyle Maximized
    Read-Host ">>> Gepr�ft? [Enter]"


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
show-TrennerInfo "Zur�ck zum Men�?"

""
Read-Host "Zur�ck zum Men�? [ENTER]"
& $menuPS1
