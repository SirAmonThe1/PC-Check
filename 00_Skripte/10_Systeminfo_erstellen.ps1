#clear                      #Debugging

#Version
#2022-02-18


#Settings

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


write-host -BackgroundColor Green -ForegroundColor White "Willkommen beim PC-Check - Startinfos"
write-host

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








# Leistungsindex 
Write-Host -BackgroundColor Black -ForegroundColor Cyan "##### --- Leistungsindex erstellen"
Write-Host
Write-Host -BackgroundColor Blue -ForegroundColor White ">>> Leistungsindex wird gestartet"

winsat formal

clear



show-TrennerHeader1 "PC-Check Menü"

#####################
# Vorbereitung
#####################

show-TrennerHeader2 "Vorbereitung"

show-TrennerInfo "Logging starten"

Start-logging "Log_10_fuer_$PCname"         #   "LogName"

show-TrennerKlein
show-TrennerInfo "Systemwiederherstellungspunkt erstellen"

Set-SystemCheckpoint "PC-Check initial"         # "Text"



#####################
# Erhebung
#####################

show-TrennerHeader2 "Erhebung der Systeminformationen"

show-TrennerInfo "Windows"

get-sysWindows
get-sysWindowsLicense

show-TrennerKlein
show-TrennerInfo "Office"

get-sysOfficeLicense

show-TrennerKlein
show-TrennerInfo "Pruefe PSWindowsUpdate Installation"

get-sysPSWindowsUpdateVersion

show-TrennerKlein
show-TrennerInfo "ausstehende Windows Updates"

Get-WUList | Format-Table

Write-Host

show-TrennerKlein
show-TrennerInfo "Benutzerkonten"

Get-LocalUser | Format-Table

Write-Host

show-TrennerKlein
show-TrennerInfo "BIOS"

Get-ComputerInfo | Format-List -Property BiosManufacturer,BiosName,BiosVersion,BiosReleaseDate,BiosFirmwareType,SerialNumber

Write-Host

show-TrennerKlein
show-TrennerInfo "Mainboard"

Get-WmiObject Win32_BaseBoard | Format-List -Property Manufacturer,Product,SerialNumber

show-TrennerKlein
show-TrennerInfo "Prozessor"

Get-WmiObject win32_processor | Format-List -Property Name,NumberOfCores,NumberOfLogicalProcessors,MaxClockSpeed,SocketDesignation

show-TrennerKlein
show-TrennerInfo "Grafikkarte"

Get-Wmiobject Win32_VideoController | Format-List -Property DeviceID,Caption,@{n='AdapterRAM (Gb)' ;e={"{0:n2}" -f ($_.AdapterRAM/1gb)}},VideoModeDescription,AdapterCompatibility,DriverVersion

show-TrennerKlein
show-TrennerInfo "Arbeitsspeicher (RAM)"

show-TrennerKlein
show-TrennerInfo "Festplatten"


get-festplatte

show-TrennerKlein
show-TrennerInfo "Netzwerk"

Get-CimInstance -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=$true | Format-List Description, MACAddress,IPSubnet,DefaultIPGateway,DNSServerSearchOrder, IPAddress

show-TrennerKlein
show-TrennerInfo "Treiber"

Get-WmiObject Win32_PnPSignedDriver | Where-Object {$_.DeviceClass -ne $null} | Where-Object {$_.Manufacturer -notlike '*USB*'} | Where-Object {$_.DeviceName -ne 'Volume'} | Where-Object {!(($_.DeviceClass -eq 'System') -and ($_.Manufacturer -eq 'Microsoft'))} | Where-Object {$_.DeviceName -notlike 'HID*'} | Where-Object {$_.DeviceName -notlike 'WAN Miniport*'} | Where-Object {$_.Manufacturer -ne '(Standard system devices)'} | Where-Object {$_.DeviceName -ne 'Generic software device'} | Where-Object {$_.DeviceName -ne 'Generic volume shadow copy'} | Sort-Object -Property DeviceClass,DeviceName,FriendlyName | Format-Table -groupby DeviceClass -autosize -Property DeviceName,FriendlyName,Manufacturer

show-TrennerKlein
show-TrennerInfo "Virenschutz"

Get-sysVirenschutz

show-TrennerKlein
show-TrennerInfo "Installierte Programme"

Get-Package -Provider Programs -IncludeWindowsInstaller | sort-object -Property name | Format-Table -Property Name, Version

show-TrennerKlein
show-TrennerInfo "Systempower Bericht"

powercfg /systempowerreport /output "C:\!_Checkup\02_Systempowerreport_1_fuer_$PCname.html"

show-TrennerKlein
show-TrennerInfo "Leistungsindex abrufen"

gwmi win32_winsat | fl *score


#####################
# Fertig
#####################

show-TrennerFertig
	
out-beep

Stop-logging 

show-TrennerKlein
show-TrennerInfo "Zurück zum Menü?"

confirm-menu

