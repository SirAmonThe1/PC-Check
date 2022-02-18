

function Request-RenamePC {

    # PC-Rename
    Write-Host -BackgroundColor Black -ForegroundColor Cyan "##### --- PC-Rename"
    Write-Host
    Write-Host -BackgroundColor Blue -ForegroundColor White ">>> Aktueller Computername"

    hostname

    Write-Host


    $confirmation = Read-Host ">>> Diesen Computer jetzt umbenennen? [y/n]"
        if ($confirmation -eq 'y') {
		    $name = Read-Host ">>> Wie soll der Computer benannt werden?"
		    Rename-Computer -NewName $name
		    Echo " Der Computer muss neue gestartet werden!"}

    write-host

}



function Start-logging ( $LogName ) {

    start-transcript C:\!_Checkup\$LogName.txt
    ""
    Write-Host -BackgroundColor Black -ForegroundColor white "---- $LogName"
    ""
    Write-Host -BackgroundColor Black -ForegroundColor white "Ausführung des Skriptes in $scriptFolder"
    ""

}

function Stop-logging {

    ""
    stop-transcript
    ""

}




function Set-SystemCheckpoint ( $CheckpointName ) {         # "Text"

    Write-Host -BackgroundColor Black -ForegroundColor Cyan "##### --- Systemwiederherstellung"
    Write-Host
    Write-Host -BackgroundColor Blue -ForegroundColor White ">>> Aktivieren fuer Laufwerk C:\"
    Write-Host
    Enable-ComputerRestore "C:\"
    Write-Host -BackgroundColor Blue -ForegroundColor White ">>> Neuen Wiederherstellungspunkt erstellen"
    Write-Host
    Checkpoint-Computer -Description $CheckpointName
    Write-Host Write-Host -BackgroundColor Blue -ForegroundColor White ">>> Alle Wiederherstellungspunkte anzeigen"
    Write-Host
    Get-ComputerRestorePoint
    Write-Host

}




function show-rebootstatus {

    Write-Host -ForegroundColor ">>> Muss ein Neustart durchgeführt werden?"
    Write-Host -ForegroundColor Red "            Nach Neustart muss das Menü aus dem Pfad $setupPath gestartet werden"
	

    Get-WURebootStatus

}


function show-rebootstatusForce {

    Write-Host -ForegroundColor Red ">>> Bitte auf jeden Fall jetzt neu Starten"
    ""

	$confirmation = Read-Host ">>> jetzt Neustart mit RAM-Test durchfuehren? [y/n]"
        if ($confirmation -eq 'y') {  mdsched  }
	"" 
	$confirmation = Read-Host ">>> jetzt nur Neustart durchfuehren? [y/n]"
        if ($confirmation -eq 'y') {  Restart-Computer  }
    ""

}


function confirm-menu {

    ""
    Read-Host "Zurück zum Menü? [ENTER]"
    & $menuPS1

}



function out-beep {

	[console]::beep(2000,250)
    [console]::beep(1000,250)

}


function start-scannowtest {

    Write-Host -BackgroundColor Blue -ForegroundColor White ">>> Festplatten-Scan (sfc /Scannow) wird gestartet"
    sfc /scannow

    write-host San beendet

    out-beep

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

}




function get-SMARTinfo {

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

}