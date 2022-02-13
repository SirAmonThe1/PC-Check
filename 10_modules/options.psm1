

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

    # Logging starten
    Write-Host -BackgroundColor Magenta -ForegroundColor White "##### --- Logging wird gestartet"

    

    start-transcript C:\!_Checkup\$LogName.txt
    Write-Host

    Write-Host -BackgroundColor Black -ForegroundColor Cyan "############################################################"
    Write-Host
    Write-Host -BackgroundColor Black -ForegroundColor Cyan "---- $LogName"
    Write-Host
    Write-Host -BackgroundColor Black -ForegroundColor Cyan "############################################################"

    Write-Host
    Write-Host -BackgroundColor Black -ForegroundColor Cyan "Ausführung des Skriptes in $scriptFolder"
    Write-Host

}

function Stop-logging {

    # Logging starten

    Write-Host -BackgroundColor Magenta -ForegroundColor White "##### --- Logging wird beendet"

    stop-transcript
    Write-Host

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