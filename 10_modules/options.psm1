#clear                      #Debugging

#Version
#2022-02-18



function Request-RenamePC {

    show-Output "Aktueller Computername"

    hostname
    ""
    $confirmation = Read-Host ">>> Diesen Computer jetzt umbenennen? [y/n]"
        if ($confirmation -eq 'y') {
		    $name = Read-Host ">>> Wie soll der Computer benannt werden?"
		    Rename-Computer -NewName $name
		    Echo " Der Computer muss neue gestartet werden!"}
}



function Start-logging ( $LogName ) {

    start-transcript C:\!_Checkup\$LogName.txt
    ""
    show-Output "Logname: $LogName"
    ""

}

function Stop-logging {

    ""
    stop-transcript
    ""

}




function Set-SystemCheckpoint ( $CheckpointName ) {         # "Text"

    show-Output "Aktivieren fuer Laufwerk C:\"
    Enable-ComputerRestore "C:\"
    show-Output "OK"

    show-Output "Neuen Wiederherstellungspunkt erstellen"
    Checkpoint-Computer -Description $CheckpointName
    show-Output "OK"

    show-Output "Alle Wiederherstellungspunkte anzeigen"
    Get-ComputerRestorePoint
    show-Output "OK"
    ""
}




function show-rebootstatus {

    show-Output "Muss ein Neustart durchgeführt werden?"
    show-OutputAlert "Nach Neustart muss das Menü aus dem Pfad $setupPath gestartet werden"
	
    Get-WURebootStatus

}


function show-rebootstatusForce {

    show-OutputAlert "Bitte auf jeden Fall jetzt neu Starten"
    ""

	$confirmation = Read-Host ">>> jetzt Neustart mit RAM-Test durchfuehren? [y/n]"
        if ($confirmation -eq 'y') {  mdsched  }
	"" 
	$confirmation = Read-Host ">>> jetzt nur Neustart durchfuehren? [y/n]"
        if ($confirmation -eq 'y') {  Restart-Computer  }
    ""

}



function get-LIndex {

    show-OutputGray "läuft, bitte warten"
    ""
    $LIndex = winsat formal
    ""
    show-Output "Erstellung erfolgreich"

}



function out-beep {

	[console]::beep(2000,250)
    [console]::beep(1000,250)

}


function start-scannowtest {

    show-Output "Festplatten-Scan (sfc /Scannow) wird gestartet"
    sfc /scannow

    show-Output "Scan beendet"

    out-beep

    ""

    $confirmation = Read-Host ">>> Hat der Scan fehlgeschlagen? [y/n]"
        if ($confirmation -eq 'y') {
		    show-OutputAlert "Windows Health Check wird gestartet"
		    dism /Online /Cleanup-Image /ScanHealth
		    show-OutputAlert "Checkup wird gestartet"
		    Dism /Online /Cleanup-Image /CheckHealth

            out-beep

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