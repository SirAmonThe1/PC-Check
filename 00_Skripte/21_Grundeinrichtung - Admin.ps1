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


write-host -BackgroundColor Green -ForegroundColor White "Willkommen bei der Grundeinrichtung f�r Admins"
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

    #Zur�ck zum Men�

	write-host
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "Bitte zuerst das Skript installieren im Men�"
	& $menuPS1
}
write-host




	#####################
	# Vorbereitung
	#####################


    # Logging starten
    Start-logging "Log_21_fuer_$PCname"         #   "LogName"


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

    Start-Windows-Update
	






	
	
	#####################
	# Windows-Einstellungen
	#####################
	
    Set-WindowsSettings
	
	[console]::beep(2000,250)
    [console]::beep(2000,250)
	
	







	#####################
	# SOFIA Skript
	#####################
	


    Set-SophiaSkript "Admin"                 # Admin triggert Admin-Einstellungen






	
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
	
    install-software "Admin"                    # Basic, optional, admin, pccheck




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
	Write-Host -ForegroundColor Red ">>> Muss ein Neustart durchgef�hrt werden?"
    Write-Host -ForegroundColor DarkGray "            Nach Neustart muss das Men� aus dem Pfad $setupPath gestartet werden"
	$Reboot = Get-WURebootStatus
	if ($Reboot -like "*localhost: Reboot is not required*") {
		Write-Host -ForegroundColor Green ">>> Es ist kein Neustart des Systems n�tig"
        ""





        #zur�ck zum Men�

        Read-Host "Zur�ck zum Men�? [ENTER]"
        & $menuPS1
	} 