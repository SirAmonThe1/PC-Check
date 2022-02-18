﻿#clear                      #Debugging

#Version
#2022-02-18


# Settings
$setupPath = "C:/!_Checkup_Install/"
$repoUrl = "https://raw.githubusercontent.com/SirAmonThe1/PC-Check/master/00_Start.ps1"
#$setupPath = "D:/Coding/01_GitHub/PC-Check/"       #Debugging
$skriptPath = $setupPath + "00_Skripte/"
$menuPS1 = $setupPath + "01_Menu.ps1"

$modulesPath = $setupPath + "10_modules"
$registryPath = $setupPath + "11_registry"
$softwarePath = $setupPath + "12_software"
$sophiaPath = $softwarePath + "/Sophia_Script"

$PCname = hostname



#Skript


write-host -BackgroundColor Green -ForegroundColor White "Software 2 Chocolatey"
write-host

# Settings
Set-ExecutionPolicy Bypass -Scope Process -Force


Write-Host -BackgroundColor Black -ForegroundColor Cyan "PowerShell-Prozess mit Admin-Rechten ausfuehren"
gsudo
write-host


show-Output "Aktueller Pfad"
$scriptFolder   = Split-Path -Parent $MyInvocation.MyCommand.Path
Write-Host $scriptFolder

show-Output "Installationspfad"
Write-Host $setupPath

if (Test-Path -Path $setupPath\10_modules) {
    Get-ChildItem $setupPath\10_modules\*.psm1 | Import-Module -Force
	write-host
	show-Output "Module importiert aus Install Pfad"
} else {

    #Zurück zum Menü

	write-host
	show-Output "Bitte zuerst das Skript installieren im Menü"
	& $menuPS1
}
write-host



show-TrennerHeader1 "Software in Chocolatey importieren"



get-SW2Choco




show-TrennerKlein
show-TrennerInfo "Zurück zum Menü?"

confirm-menu