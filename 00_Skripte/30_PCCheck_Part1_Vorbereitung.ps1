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
    Start-logging "Log_30_fuer_$PCname"         #   "LogName"


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

	Start-WindowsUpdatex
	
	







show-Trenner







	
	#####################
	# Windows-Einstellungen
	#####################
	
    Set-WindowsSettings
	
	[console]::beep(2000,250)
    [console]::beep(2000,250)
	







show-Trenner








	#####################
	# SOFIA Skript
	#####################
	
	
    Set-SophiaSkript "Basic"               # Admin triggert Admin-Einstellungen
	
	






show-Trenner









	
#####################
# SOFTWARE
#####################

	Write-Host -BackgroundColor Black -ForegroundColor Cyan "****"
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "#####################"
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "# ----- SOFTWARE"
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "#####################"
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "****"

Write-Host
Write-Host -BackgroundColor Black -ForegroundColor Cyan "--- Installierte Programme vor der Bereinigung"
Write-Host

Get-Package -Provider Programs -IncludeWindowsInstaller | sort-object -Property name | Format-Table -Property Name, Version

Write-Host





show-Trenner





	


install-software "Basic"                    # Basic, optional, admin, pccheck



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

Write-Host





show-Trenner






Write-Host 
Write-Host -BackgroundColor Black -ForegroundColor Cyan "Unnoetige Software manuell deinstallieren"
Write-Host 
Write-Host -BackgroundColor Blue -ForegroundColor White ">>> BCUninstaller wird gestartet"

start-process $softwarePath\BCUninstaller\BCUninstaller.exe -windowstyle Maximized

write-host
Write-Host -BackgroundColor Blue -ForegroundColor White ">>>  Unnoetige Software bitte jetzt deinstallieren"
    [console]::beep(2000,250)
    [console]::beep(2000,250)
Read-Host "Fertig deinstalliert? [Enter]"
write-host






show-Trenner







Write-Host
Write-Host -BackgroundColor Black -ForegroundColor Cyan "--- Installierte Programme nach Bereinigung"
Write-Host

Get-Package -Provider Programs -IncludeWindowsInstaller | sort-object -Property name | Format-Table -Property Name, Version






show-TrennerFertig






	
	[console]::beep(2000,250)
    [console]::beep(2000,250)
	
	# Logging beenden
    Stop-logging 

	
	# Reboot
	Write-Host -BackgroundColor Red -ForegroundColor White "##### --- NEUSTARTEN"
	Write-Host
	Write-Host -ForegroundColor Red ">>> Bitte auf jeden Fall jetzt neu Starten"
    ""

	$confirmation = Read-Host ">>> jetzt Neustart mit RAM-Test durchfuehren? [y/n]"

	if ($confirmation -eq 'y') {  mdsched  }
	 
	Write-Host


	$confirmation = Read-Host ">>> jetzt nur Neustart durchfuehren? [y/n]"

    if ($confirmation -eq 'y') {  Restart-Computer  }





    #zurück zum Menü

    ""
    Read-Host "Zurück zum Menü? [ENTER]"
    & $menuPS1