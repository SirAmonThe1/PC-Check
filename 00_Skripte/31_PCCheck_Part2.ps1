#clear      #Debugging

#Version
#2022-02-12


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


    Write-Host -BackgroundColor Black -ForegroundColor Cyan "Aktueller Pfad"
    $scriptFolder   = Split-Path -Parent $MyInvocation.MyCommand.Path
    Write-Host $scriptFolder

    Write-Host -BackgroundColor Black -ForegroundColor Cyan "Install Pfad"
    Write-Host $setupPath

    if (Test-Path -Path $setupPath\10_modules) {
        Get-ChildItem $setupPath\10_modules\*.psm1 | Import-Module -Force
	    write-host
	    write-host "Module importiert aus Install Pfad"
    } else {

        #Zurück zum Menü

	    write-host
	    Write-Host -BackgroundColor Black -ForegroundColor Cyan "Bitte zuerst das Skript installieren im Menü"
	    & $menuPS1
    }
    write-host







	#####################
	# Vorbereitung
	#####################


    # Logging starten
    Start-logging "Log_31_fuer_$PCname"         #   "LogName"


    # PC-Rename
    Request-RenamePC


	

	Write-Host -BackgroundColor Black -ForegroundColor Cyan  "****"
	Write-Host -BackgroundColor Black -ForegroundColor Cyan  "****"
	Write-Host -BackgroundColor Black -ForegroundColor Cyan  "****"
	Write-Host -BackgroundColor Black -ForegroundColor Cyan  "# ----- Starte den PC-Check"
	Write-Host -BackgroundColor Black -ForegroundColor Cyan  "****"
	Write-Host -BackgroundColor Black -ForegroundColor Cyan  "****"
	Write-Host -BackgroundColor Black -ForegroundColor Cyan  "****"



	#####################
	# Windows Update
	#####################

	Start-WindowsUpdatex
	
	
	
	
write-host	





show-Trenner






write-host


#### benoetigte SW install


install-software "PCCheck"                    # Basic, optional, admin, pccheck

#### installierte SW zu chocolatey hinzufügen

$resultY = $skriptPath + "11_SWtoChoco.ps1"

    #Starte das Skript

& $resultY

write-host	





show-Trenner






write-host

Write-Host -BackgroundColor Black -ForegroundColor Cyan "--- Schrit fuer Schritt Checkup"
Write-Host
Write-Host -BackgroundColor Blue -ForegroundColor White ">>> CCleaner wird gestartet"

start-process ccleaner -windowstyle Maximized

Read-Host ">>> Mit CCleaner fertig aufgeraeumt? [Enter]"

write-host	





show-Trenner






write-host

#### HWInfo

Write-Host -BackgroundColor Blue -ForegroundColor White ">>> HWInfo wird gestartet"

start-process hwinfo -windowstyle Maximized

Read-Host ">>> Report unter C:\!_Checkup erstellt? [Enter]"

write-host	





show-Trenner





	
write-host

#### smart test

Write-Host -BackgroundColor Black -ForegroundColor Cyan ">>> S.M.A.R.T Festplatteninfos auslesen mit CrystalDiskInfo"

#We start CrystalDiskInfo with the COPYEXIT parameter. This just collects the SMART information in DiskInfo.txt
$DiskInfoLoc = "C:\ProgramData\chocolatey\lib\crystaldiskinfo.portable\tools"
start-process $DiskInfoLoc\DiskInfo64.exe -windowstyle Maximized -ArgumentList "/CopyExit" -wait

$line = 1
$nextline = ""

write-host 

# Festplatten aus erstellter .txt Datei auslesen

do{
    $nextline = get-content "$DiskInfoLoc\DiskInfo.txt" | select-string "-- Disk List ---------------------------------------------------------------" -Context 0,$line
    If ($nextline -ne "") {
        $line = $line+1
    }
}until($nextline -ne "")

get-content "$DiskInfoLoc\DiskInfo.txt" | select-string "-- Disk List ---------------------------------------------------------------" -Context 0,$line
write-host

# SMART Infos Darstellen aus der .txt datei

get-content "$DiskInfoLoc\DiskInfo.txt" | select-string "model" -Context 4,25

write-host	





show-Trenner





	
write-host

#### Festplatte auf Speicherfresser prüfen

Write-Host
Write-Host -BackgroundColor Black -ForegroundColor Cyan "Speicherplatz auf Festplatten prüfen"
Write-Host -BackgroundColor Blue -ForegroundColor White ">>> TreeSizeFree wird gestartet" # und zudem Infos gelogged"

start-process "C:\Program Files (x86)\JAM Software\TreeSize Free\treesizefree.exe" -windowstyle Maximized -verb runas

write-host

write-host	





show-Trenner






write-host



#### Festplattentest sfc /Scannow


Write-Host -BackgroundColor Black -ForegroundColor Cyan "--- Festplattentest"
Write-Host
Write-Host -BackgroundColor Blue -ForegroundColor White ">>> Festplatten-Scan (sfc /Scannow) wird gestartet"
sfc /scannow

write-host San beendet
    [console]::beep(2000,250)
    [console]::beep(2000,250)
write-host


$confirmation = Read-Host ">>> Hat der Scan fehlgeschlagen? [y/n]"
    if ($confirmation -eq 'y') {
		Write-Host -ForegroundColor Red ">>> Windows Health Check wird gestartet"
		dism /Online /Cleanup-Image /ScanHealth
		Write-Host -ForegroundColor Red ">>> Checkup wird gestartet"
		Dism /Online /Cleanup-Image /CheckHealth
		[console]::beep(2000,250)
		[console]::beep(2000,250)
		$confirmation = Read-Host ">>> Fehler beheben? --> NUR WENN FEHLER GEFUNDEN WURDEN AUSFueHREN!!! [y/n]"
		if ($confirmation -eq 'y') {
			dism /Online /Cleanup-Image /RestoreHealth
		}
	}

write-host	





show-Trenner





	
write-host

#### ram test + ergebnisse abrufen

Write-Host -BackgroundColor Black -ForegroundColor Cyan "--- RAM-Test"
Write-Host
Write-Host -BackgroundColor Blue -ForegroundColor White ">>> mdsched Ergebnisse werden abgerufen"

Get-winevent -FilterHashTable @{logname='System'; id='1101'}|?{$_.providername -match 'MemoryDiagnostics-Results'}
Get-winevent -FilterHashTable @{logname='System'; id='1201'}|?{$_.providername -match 'MemoryDiagnostics-Results'}

write-host	





show-Trenner






write-host


#### Treiber altdateien pruefen

Write-Host -BackgroundColor Black -ForegroundColor Cyan "--- Treiber Pruefen"

    [console]::beep(2000,250)
    [console]::beep(2000,250)

Write-Host -BackgroundColor Blue -ForegroundColor White ">>> DriverStoreExplorer wird gestartet"

start-process $softwarePath\DriverStoreExplorer\rapr.exe -windowstyle Maximized

Read-Host ">>> Geprueft? [Enter]"

write-host	





show-Trenner





	
write-host

#### adwcleaner check

Write-Host -BackgroundColor Black -ForegroundColor Cyan "--- AdWare Pruefen"

    [console]::beep(2000,250)
    [console]::beep(2000,250)

Write-Host -BackgroundColor Blue -ForegroundColor White ">>> AdwCleaner wird gestartet --> Bitte Pruefen aber Bereinigung NICHT durchfuehren"

start-process adwcleaner -windowstyle Maximized

Read-Host ">>> Geprueft? [Enter]"

write-host	





show-Trenner





	
write-host



#### benoetigte SW deinstall
Write-Host
Write-Host -BackgroundColor Black -ForegroundColor Cyan "--- Deinstalliere temporaer fuer den Checkup installierte Software"
Write-Host -BackgroundColor Blue -ForegroundColor White ">>> Pakete: " $SW_PCCheck
write-host

choco uninstall $SW_PCCheck --ignore-checksums --limit-output -y

write-host	





show-Trenner






write-host

    [console]::beep(2000,250)
    [console]::beep(2000,250)








	# Logging beenden
Write-Host -BackgroundColor Magenta -ForegroundColor White "##### --- Logging wird beendet"

stop-transcript

Write-Host

Write-Host -BackgroundColor Blue -ForegroundColor White ">>> AdwCleaner --> moegliche Bereinigung jetzt durchfuehren"

start-process adwcleaner -windowstyle Maximized

Read-Host ">>> Geprueft? [Enter]"






show-TrennerFertig






	
	# Reboot
	Write-Host -BackgroundColor Red -ForegroundColor White "##### --- REBOOT STATUS"
	Write-Host
	Write-Host -ForegroundColor Red ">>> Checking for reboot status"
	$Reboot = Get-WURebootStatus
	if ($Reboot -like "*localhost: Reboot is not required*") {
		Write-Host -ForegroundColor Green ">>> No reboot required"
	} 





        #zurück zum Menü

        Read-Host "Zurück zum Menü? [ENTER]"
        & $menuPS1