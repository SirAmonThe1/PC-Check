#clear                      #Debugging

#Version
#2022-03-01


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



write-host -BackgroundColor Green -ForegroundColor White "Software Install und Uninstall"
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




show-TrennerHeader1 "Abschlussbericht erstellen und PC bereinigen"

#####################
# Vorbereitung
#####################

show-TrennerHeader2 "Vorbereitung"

show-TrennerInfo "Logging starten"

Start-logging "Log_41_fuer_$PCname"         #   "LogName"





#####################
# SOFTWARE
#####################

show-TrennerHeader2 "Software prüfen"

confirm-software


show-TrennerKlein
show-TrennerInfo "Installierte Programme"

Get-Package -Provider Programs -IncludeWindowsInstaller | sort-object -Property name | Format-Table -Property Name, Version




#####################
# Fertig
#####################

show-TrennerFertig

out-beep

Stop-logging 

show-TrennerKlein
show-TrennerInfo "Zurück zum Menü?"

""
Read-Host "Zurück zum Menü? [ENTER]"
& $menuPS1
