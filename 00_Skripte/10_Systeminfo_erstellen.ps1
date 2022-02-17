#clear      #Debugging

#Version
#2022-02-12


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








# Leistungsindex 
Write-Host -BackgroundColor Black -ForegroundColor Cyan "##### --- Leistungsindex erstellen"
Write-Host
Write-Host -BackgroundColor Blue -ForegroundColor White ">>> Leistungsindex wird gestartet"

winsat formal

clear




	#####################
	# Vorbereitung
	#####################


    # Logging starten
    Start-logging "Log_10_fuer_$PCname"         #   "LogName"




    # Systemwiederherstellung
    Set-SystemCheckpoint "PC-Check initial"         # "Text"








show-Trenner







Write-Host



	#####################
	# Erhebung
	#####################



    # PC-Informationen

    Write-Host -BackgroundColor Black -ForegroundColor Cyan "##### --- Systeminfos"
    Write-Host

    get-sysWindows
    get-sysWindowsLicense






show-Trenner







    get-sysOfficeLicense






show-Trenner











Write-Host
Write-Host -BackgroundColor Black -ForegroundColor Cyan "--- Pruefe PSWindowsUpdate Installation"
Write-Host

get-sysPSWindowsUpdateVersion









show-Trenner







Write-Host

Write-Host -BackgroundColor Black -ForegroundColor Cyan "--- ausstehende Windows Updates"
Write-Host

Get-WUList | Format-Table

Write-Host






show-Trenner







Write-Host
Write-Host -BackgroundColor Black -ForegroundColor Cyan "--- Benutzerkonten"
Write-Host

Get-LocalUser | Format-Table

Write-Host






show-Trenner







Write-Host
Write-Host -BackgroundColor Black -ForegroundColor Cyan "--- BIOS"
Write-Host

Get-ComputerInfo | Format-List -Property BiosManufacturer,BiosName,BiosVersion,BiosReleaseDate,BiosFirmwareType,SerialNumber

Write-Host






show-Trenner







Write-Host
Write-Host -BackgroundColor Black -ForegroundColor Cyan "--- Hardware"
Write-Host
Write-Host -BackgroundColor Blue -ForegroundColor White ">>> Mainboard"

Get-WmiObject Win32_BaseBoard | Format-List -Property Manufacturer,Product,SerialNumber
Write-Host

Write-Host -BackgroundColor Blue -ForegroundColor White ">>> Prozessor"

Get-WmiObject win32_processor | Format-List -Property Name,NumberOfCores,NumberOfLogicalProcessors,MaxClockSpeed,SocketDesignation
Write-Host

Write-Host -BackgroundColor Blue -ForegroundColor White ">>> Grafikkarte"

Get-Wmiobject Win32_VideoController | Format-List -Property DeviceID,Caption,@{n='AdapterRAM (Gb)' ;e={"{0:n2}" -f ($_.AdapterRAM/1gb)}},VideoModeDescription,AdapterCompatibility,DriverVersion
Write-Host

Write-Host -BackgroundColor Blue -ForegroundColor White ">>> Arbeitsspeicher (RAM)"
Write-Host

Write-Host -BackgroundColor Blue -ForegroundColor White ">>> Festplatten"
Write-Host

$FullSize = 
@{
  Expression = {[int]($_.Size/1GB)}
  Name = 'Space (GB)'
}

$Freespace = 
@{
  Expression = {[int]($_.Freespace/1GB)}
  Name = 'Free Space (GB)'
}

$PercentFree = 
@{
  Expression = {[int]($_.Freespace*100/$_.Size)}
  Name = 'Free (%)'
}

Get-WmiObject -Class Win32_LogicalDisk | Where-Object {$_.VolumeName -ne 'Remke IT-Service'} | Format-Table -autosize -Property DeviceID, VolumeName, FileSystem, Description, $FullSize, $Freespace, $PercentFree

Write-Host
Write-Host -BackgroundColor Blue -ForegroundColor White ">>> Netzwerk"
Write-Host

Get-CimInstance -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=$true | Format-List Description, MACAddress,IPSubnet,DefaultIPGateway,DNSServerSearchOrder, IPAddress

Write-Host






show-Trenner







Write-Host
Write-Host -BackgroundColor Black -ForegroundColor Cyan "--- Treiber"
Write-Host

Get-WmiObject Win32_PnPSignedDriver | Where-Object {$_.DeviceClass -ne $null} | Where-Object {$_.Manufacturer -notlike '*USB*'} | Where-Object {$_.DeviceName -ne 'Volume'} | Where-Object {!(($_.DeviceClass -eq 'System') -and ($_.Manufacturer -eq 'Microsoft'))} | Where-Object {$_.DeviceName -notlike 'HID*'} | Where-Object {$_.DeviceName -notlike 'WAN Miniport*'} | Where-Object {$_.Manufacturer -ne '(Standard system devices)'} | Where-Object {$_.DeviceName -ne 'Generic software device'} | Where-Object {$_.DeviceName -ne 'Generic volume shadow copy'} | Sort-Object -Property DeviceClass,DeviceName,FriendlyName | Format-Table -groupby DeviceClass -autosize -Property DeviceName,FriendlyName,Manufacturer


Write-Host






show-Trenner








Get-sysVirenschutz

Write-Host






show-Trenner







Write-Host
Write-Host -BackgroundColor Black -ForegroundColor Cyan "--- Installierte Programme"
Write-Host

Get-Package -Provider Programs -IncludeWindowsInstaller | sort-object -Property name | Format-Table -Property Name, Version

Write-Host





show-Trenner







Write-Host
Write-Host -BackgroundColor Black -ForegroundColor Cyan "--- Systempower Bericht"
Write-Host

powercfg /systempowerreport /output "C:\!_Checkup\02_Systempowerreport_1_fuer_$PCname.html"
Write-Host






show-Trenner







Write-Host


# Leistungsindex abrufen
Write-Host -BackgroundColor Black -ForegroundColor Cyan "##### --- Leistungsindex"
Write-Host
Write-Host -BackgroundColor Blue -ForegroundColor White ">>> Leistungsindex Ergebnis"

gwmi win32_winsat | fl *score
Write-Host






show-Trenner







Write-Host



    [console]::beep(2000,250)
    [console]::beep(2000,250)


    




show-TrennerFertig









# Logging beenden
Stop-logging 




#zurück zum Menü

Read-Host "Zurück zum Menü? [ENTER]"
& $menuPS1