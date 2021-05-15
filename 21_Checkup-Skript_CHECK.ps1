# Settings
Set-ExecutionPolicy Bypass -Scope Process -Force


write-host "PowerShell-Prozess mit Admin-Rechten ausführen"
[console]::beep(2000,250)
[console]::beep(2000,250)
gsudo
write-host

$setupPath = "C:/!_Checkup_Install"

Write-Host -ForegroundColor Red "Aktueller Pfad"
$scriptFolder   = Split-Path -Parent $MyInvocation.MyCommand.Path
Write-Host $scriptFolder

Write-Host -ForegroundColor Red "Install Pfad"
Write-Host $setupPath

if (Test-Path -Path $setupPath) {
    Get-ChildItem $setupPath\10_modules\*.psm1 | Import-Module -Force
	write-host
	write-host "Importiert aus Install Pfad"
} else {
	Get-ChildItem $scriptFolder\10_modules\*.psm1 | Import-Module -Force
	write-host
	write-host "Importiert aus Aktuellem Pfad (Keine Dateien unter Laufwerk C:\)"
}
write-host

# Logging starten
Write-Host -BackgroundColor Magenta -ForegroundColor White "##### --- Logging wird gestartet"

$PCname = hostname
$LogName = "Checkup-Log_fuer_$PCname_(Checkup)"

start-transcript C:\!_Checkup\$LogName.txt


$stoppuhr1 = [system.diagnostics.stopwatch]::StartNew()

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


# Import all Modules

Get-ChildItem .\modules\*.psm1 | Import-Module -Force

    
	#####################
	# Vorbereitung
	#####################
	

	Write-Output "****"
	Write-Output "****"
	Write-Output "****"
	Write-Output "# ----- Starte den PC-Check"
	Write-Output "****"
	Write-Output "****"
	Write-Output "****"


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

	Write-Host -ForegroundColor Red ">>> Checking for Windows Updates"
	Write-Host -ForegroundColor DarkGray "This will take a while ..."
	$updates = Get-WUlist -MicrosoftUpdate
	if ($updates) {
		Write-Host -ForegroundColor Magenta ">>> Updates found:"
		Write-Host ($updates | Format-Table | Out-String)
		Get-WindowsUpdate -Install -MicrosoftUpdate -AcceptAll -IgnoreReboot
	} else {
		Write-Host -ForegroundColor Green ">>> No Windows Updates available!"
	}
	
	
write-host	
Write-Host "############################################################"
Write-Host "############################################################"	
write-host


#### benötigte SW install
Write-Host
Write-Host -ForegroundColor Red ">>> Installiere notwendige Software fuer den Checkup"
Write-Host	"Pakete: hwinfo.install crystaldiskinfo.install ccleaner ccenhancer treesizefree"
write-host

cup hwinfo.install crystaldiskinfo.install ccleaner ccenhancer treesizefree --ignore-checksums --limit-output -y

write-host	
Write-Host "############################################################"
Write-Host "############################################################"	
write-host

Write-Host -ForegroundColor Red ">>> Schrit fuer Schritt Checkup"
Write-Host
Write-Host "CCleaner wird gestartet"

start-process ccleaner -windowstyle Maximized

Read-Host -Prompt "Mit CCleaner fertig aufgeraeumt? [Enter]"

write-host	
Write-Host "############################################################"
Write-Host "############################################################"	
write-host

#### HWInfo

Write-Host "HWInfo wird gestartet"

start-process hwinfo -windowstyle Maximized

Read-Host -Prompt "Report unter C:\!_Checkup erstellt? [Enter]"

write-host	
Write-Host "############################################################"
Write-Host "############################################################"	
write-host

#### smart test

write-host "S.M.A.R.T Festplatteninfos auslesen mit CrystalDiskInfo"

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
Write-Host "############################################################"
Write-Host "############################################################"	
write-host

#### Festplatte auf übergroße Dateien prüfen

Write-Host
Write-Host "TreeSizeFree wird gestartet"

start-process "C:\Program Files (x86)\JAM Software\TreeSize Free\treesizefree.exe" -windowstyle Maximized -verb runas

Write-Host "Auflistung aller Ordner über 3 GB im Verzeichniss C:\Users\$Env:USERNAME"
Write-Host -ForegroundColor DarkGray "Sammeln der Infos kann etwas dauern ..."

Get-DirectoryTreeSize -BasePath "C:\Users\$Env:USERNAME" | Sort-Object 'Size(Bytes)' -Descending | Select 'Size(GB)', 'FullPath'  | Where-Object {$_.'Size(GB)' -gt 3}

do{
	$confirmation = Read-Host ">>> Weitere Festplatte geprüft werden? [y/n]"
    if ($confirmation -eq 'n') {
        Write-Host
        break
        }
    if ($confirmation -eq 'y') {
		$LWBuchstabe = Read-Host "Von welcher Festplatte soll noch geprüft werden? Bitte Laufwerksbuchstaben eingeben"
		Write-Host
		Write-Host "Auflistung aller Ordner über 3 GB auf der Festplatte ${LWBuchstabe}:\"
		write-host
		Get-DirectoryTreeSize -BasePath "${LWBuchstabe}:\" | Sort-Object 'Size(Bytes)' -Descending | Select 'Size(GB)', 'FullPath'  | Where-Object {$_.'Size(GB)' -gt 3}
		write-host
	}
}while($confirmation -eq 'n')


write-host	
Write-Host "############################################################"
Write-Host "############################################################"	
write-host



#### Festplattentest sfc /Scannow


Write-Host -BackgroundColor Magenta -ForegroundColor White "##### --- Festplattentest"
Write-Host
Write-Host -ForegroundColor Red ">>> Festplatten-Scan (sfc /Scannow) wird gestartet"
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
$confirmation = Read-Host ">>> Fehler beheben? --> NUR WENN FEHLER GEFUNDEN WURDEN AUSFÜHREN!!! [y/n]"
    if ($confirmation -eq 'y') {
        dism /Online /Cleanup-Image /RestoreHealth
	}

}

write-host	
Write-Host "############################################################"
Write-Host "############################################################"	
write-host

#### ram test + ergebnisse abrufen

Write-Host -BackgroundColor Magenta -ForegroundColor White "##### --- RAM-Test"
Write-Host
Write-Host -ForegroundColor Red ">>> mdsched Ergebnisse werden abgerufen"

Get-winevent -FilterHashTable @{logname='System'; id='1101'}|?{$_.providername -match 'MemoryDiagnostics-Results'}
Get-winevent -FilterHashTable @{logname='System'; id='1201'}|?{$_.providername -match 'MemoryDiagnostics-Results'}

write-host	
Write-Host "############################################################"
Write-Host "############################################################"	
write-host


#### Treiber altdateien prüfen

    [console]::beep(2000,250)
    [console]::beep(2000,250)

Write-Host "DriverStoreExplorer wird gestartet"

start-process .\software\DriverStoreExplorer\rapr.exe -windowstyle Maximized

Read-Host -Prompt "Geprüft? [Enter]"

write-host	
Write-Host "############################################################"
Write-Host "############################################################"	
write-host

#### adwcleaner check

Write-Host "AdwCleaner wird gestartet --> Bitte Prüfen aber Bereinigung NICHT durchführen"

start-process adwcleaner -windowstyle Maximized

Read-Host -Prompt "Geprüft? [Enter]"

write-host	
Write-Host "############################################################"
Write-Host "############################################################"	
write-host



#### benötigte SW deinstall
Write-Host
Write-Host -ForegroundColor Red ">>> Deinstalliere Software fuer den Checkup"
Write-Host	"Pakete: hwinfo.install crystaldiskinfo.install ccleaner ccenhancer treesizefree"
write-host

choco uninstall hwinfo.install crystaldiskinfo.install ccleaner ccenhancer treesizefree --ignore-checksums --limit-output -y

write-host	
Write-Host "############################################################"
Write-Host "############################################################"	
write-host

    [console]::beep(2000,250)
    [console]::beep(2000,250)

	# Logging beenden
Write-Host -BackgroundColor Magenta -ForegroundColor White "##### --- Logging wird beendet"

stop-transcript
$stoppuhr1
$stoppuhr1.stop()
Write-Host

Write-Host "AdwCleaner --> mögliche Bereinigung jetzt durchführen"

start-process adwcleaner -windowstyle Maximized

Read-Host -Prompt "Geprüft? [Enter]"


	
	# Reboot
	Write-Host -BackgroundColor Red -ForegroundColor White "##### --- REBOOT STATUS"
	Write-Host
	Write-Host -ForegroundColor Red ">>> Checking for reboot status"
	$Reboot = Get-WURebootStatus
	if ($Reboot -like "*localhost: Reboot is not required*") {
		Write-Host -ForegroundColor Green ">>> No reboot required"
	} 
