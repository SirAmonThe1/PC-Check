#clear      #Debugging

#Version
#2022-02-12


#Settings

#$setupPath = "C:/!_Checkup_Install/"
$repoUrl = "https://raw.githubusercontent.com/SirAmonThe1/PC-Check/master/00_Start.ps1"
$setupPath = "D:/Coding/01_GitHub/PC-Check/"       #Debugging
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
    Start-logging "Log_20_fuer_$PCname"         #   "LogName"


    # PC-Rename
    Request-RenamePC
	

	Write-Host -BackgroundColor Black -ForegroundColor Cyan "****"
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "****"
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "****"
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "# ----- Beginning the Set-Up"
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "****"
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "****"
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "****"
	
	Write-Host
	
	
	





	#####################
	# Windows Update
	#####################

    Do-Windows-Update
	






	
	
	#####################
	# Windows-Einstellungen
	#####################
	
    Set-WindowsSettings
	
	[console]::beep(2000,250)
    [console]::beep(2000,250)
	
	







	
	#####################
	# SOFIA Skript
	#####################
	

    Set-SophiaSkriptAdmin ""                 # Admin triggert Admin-Einstellungen





	
	#####################
	# SOFTWARE
	#####################

	Write-Host
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "****"
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "#####################"
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "# ----- SOFTWARE"
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "#####################"
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "****"
	Write-Host
	
    # Software


	Write-Host -BackgroundColor Black -ForegroundColor Cyan "Wichtige Software wird installiert"
	Write-Host -BackgroundColor Blue -ForegroundColor White ">>> Pakete: " $SW_Basic
	Write-Host
	
	# Installationen 
	
	cup  $SW_Basic --ignore-checksums --limit-output -y
    foreach ($SW in $SW_optional) {
        
        $confirmation = Read-Host ">>> $SW installieren? [y/n]"
		if ($confirmation -eq 'y') { cup $SW -y -r --ignore-checksum 
                                     Write-Host "" }
		if ($confirmation -eq 'n') { Write-Host -ForegroundColor darkgrey ">>> $SW wurde übersprungen"
		}

    }





    #Virenschutz

	write-host
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "Virenschutz bitte jetzt installieren"
    [console]::beep(2000,250)
    [console]::beep(2000,250)
	$confirmation = Read-Host ">>> Kaspersky Internet Security installieren? [y/n]"
		if ($confirmation -eq 'y') {
			start-process $softwarePath\Kaspersky\kis.exe}
		if ($confirmation -eq 'n') {
			Write-Host -BackgroundColor Blue -ForegroundColor White ">>> Bitte einen anderen Virenschutz aktivieren (evtl. Windows Defender)"
		}
    [console]::beep(2000,250)
    [console]::beep(2000,250)
	Read-Host ">>> Virenschutz fertig installiert? [Enter]"
	write-host









	Write-Host -BackgroundColor Black -ForegroundColor Cyan "############################################################"
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "############################################################"

	Write-Host
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "--- Installierte Programme"
	Write-Host

	Get-Package -Provider Programs -IncludeWindowsInstaller | sort-object -Property name | Format-Table -Property Name, Version

	Write-Host
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "############################################################"
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "############################################################"










	Write-Host -BackgroundColor Black -ForegroundColor Cyan "****"
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "#####################"
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "# "
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "# ----- Fertig"
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "# "
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "#####################"
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "****"

	Write-Host
	Write-Host
	
	[console]::beep(2000,250)
    [console]::beep(2000,250)
	






	# Logging beenden
    Stop-logging 






	
	# Reboot
	Write-Host -BackgroundColor Red -ForegroundColor White "##### --- REBOOT STATUS"
	Write-Host
	Write-Host -ForegroundColor Red ">>> Muss ein Neustart durchgeführt werden?"
    Write-Host -ForegroundColor DarkGray "            Nach Neustart muss das Menü aus dem Pfad $setupPath gestartet werden"
	$Reboot = Get-WURebootStatus
	if ($Reboot -like "*localhost: Reboot is not required*") {
		Write-Host -ForegroundColor Green ">>> Es ist kein Neustart des Systems nötig"
        ""





        #zurück zum Menü

        Read-Host "Zurück zum Menü? [ENTER]"
        & $menuPS1
	} 
