# Settings
Set-ExecutionPolicy Bypass -Scope Process -Force


write-host "PowerShell-Prozess mit Admin-Rechten ausfuehren"
[console]::beep(2000,250)
[console]::beep(2000,250)
gsudo
write-host

$setupPath = "C:/!_Checkup_Install"
$modulesPath = "C:/!_Checkup_Install/10_modules"
$registryPath = "C:/!_Checkup_Install/11_registry"
$softwarePath = "C:/!_Checkup_Install/12_software"

Write-Host -ForegroundColor Red "Aktueller Pfad"
$scriptFolder   = Split-Path -Parent $MyInvocation.MyCommand.Path
Write-Host $scriptFolder

Write-Host -ForegroundColor Red "Install Pfad"
Write-Host $setupPath

if (Test-Path -Path $setupPath) {
    Get-ChildItem $setupPath\10_modules\*.psm1 | Import-Module -Force
	write-host
	write-host "Importiert aus Install Pfad"
} else {
	Get-ChildItem $scriptFolder\10_modules\*.psm1 | Import-Module -Force
	write-host
	write-host "Importiert aus Aktuellem Pfad (Keine Dateien unter Laufwerk C:\)"
}


#### Virenscan

write-host
Write-Host "Bitte jetzt den Virenscan starten"
Write-Host
Read-Host -Prompt "Läuft der Scan? [Enter]"

write-host	
Write-Host "############################################################"
Write-Host "############################################################"	
write-host

# Leistungsindex 
Write-Host -BackgroundColor Magenta -ForegroundColor White "##### --- Leistungsindex erstellen"
Write-Host
Write-Host -ForegroundColor Red ">>> Leistungsindex wird gestartet"

winsat formal

clear

# Logging starten
Write-Host -BackgroundColor Magenta -ForegroundColor White "##### --- Logging wird gestartet"

$PCname = hostname
$date0 = Get-Date
$LogName = "Infoblatt_fuer_$PCname"

start-transcript C:\!_Checkup\$LogName.txt
Write-Host

Write-Host "############################################################"
Write-Host
write-host $LogName
Write-Host
Write-Host "############################################################"

Write-Host



# PC-Informationen
Write-Host -BackgroundColor Magenta -ForegroundColor White "##### --- Systeminfos"
Write-Host
Write-Host -ForegroundColor Red ">>> Windows"
Write-Host

Get-ComputerInfo |
  Select-Object -Property OsName,OsArchitecture,OsBuildNumber,OsLanguage,CsPCSystemType,OsSerialNumber,WindowsInstallDateFromRegistry

Write-Host
Write-Host -ForegroundColor Yellow "--- Windows Lizenz-Auslesen (evtl. nicht erfolgreich)"
Write-Host

wmic path softwarelicensingservice get OA3xOriginalProductKey

Write-Host

Write-Host "############################################################"
Write-Host "############################################################"

Write-Host
Write-Host -ForegroundColor Yellow "--- Microsoft Office Lizenz auslesen"
Write-Host

Write-Host "32-Bit Systeme"
cscript "C:\Program Files (x86)\Microsoft Office\Office16\OSPP.VBS" /dstatus
Write-Host "64-Bit Systeme"
cscript "C:\Program Files\Microsoft Office\Office16\OSPP.VBS" /dstatus

Write-Host

Write-Host "############################################################"
Write-Host "############################################################"

Write-Host
Write-Host -ForegroundColor Yellow "--- ausstehende Windows Updates"
Write-Host

Get-WUList | Format-Table -autosize

Write-Host

Write-Host "############################################################"
Write-Host "############################################################"

Write-Host
Write-Host -ForegroundColor Yellow "--- Benutzerkonten"
Write-Host

Get-LocalUser | Format-Table

Write-Host

Write-Host "############################################################"
Write-Host "############################################################"

Write-Host
Write-Host -ForegroundColor Red ">>> BIOS"
Write-Host

Get-ComputerInfo | Format-List -Property BiosManufacturer,BiosName,BiosVersion,BiosReleaseDate,BiosFirmwareType,SerialNumber

Write-Host

Write-Host "############################################################"
Write-Host "############################################################"

Write-Host
Write-Host -ForegroundColor Red ">>> Hardware"
Write-Host
Write-Host -ForegroundColor Yellow "--- Mainboard"

Get-WmiObject Win32_BaseBoard | Format-List -Property Manufacturer,Product,SerialNumber
Write-Host

Write-Host -ForegroundColor Yellow "--- Prozessor"

Get-WmiObject win32_processor | Format-List -Property Name,NumberOfCores,NumberOfLogicalProcessors,MaxClockSpeed,SocketDesignation
Write-Host

Write-Host -ForegroundColor Yellow "--- Grafikkarte"

Get-Wmiobject Win32_VideoController | Format-List -Property DeviceID,Caption,@{n='AdapterRAM (Gb)' ;e={"{0:n2}" -f ($_.AdapterRAM/1gb)}},VideoModeDescription,AdapterCompatibility,DriverVersion
Write-Host

Write-Host -ForegroundColor Yellow "--- Arbeitsspeicher (RAM)"
Write-Host

Get-WMIObject -class Win32_Physicalmemory | Format-Table -Property PartNumber, @{n='Capacity (Gb)' ;e={"{0:n2}" -f ($_.capacity/1gb)}}, Speed, ConfiguredVoltage, DeviceLocator, Tag
Write-Host

$date = Get-Date; $date=$date.AddDays(-1)
get-eventlog system -erroraction silentlycontinue -after $date -source Microsoft-Windows-MemoryDiagnostics-Results | Select EntryType,InstanceID,Message | format-list 

Write-Host -ForegroundColor Yellow "--- Festplatten"
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
Write-Host -ForegroundColor Red ">>> Netzwerk"
Write-Host

Get-CimInstance -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=$true | Format-List Description, MACAddress,IPSubnet,DefaultIPGateway,DNSServerSearchOrder, IPAddress

Write-Host

Write-Host "############################################################"
Write-Host "############################################################"

Write-Host
Write-Host -ForegroundColor Red ">>> Treiber"
Write-Host

Get-WmiObject Win32_PnPSignedDriver | Where-Object {$_.DeviceClass -ne $null} | Where-Object {$_.Manufacturer -notlike '*USB*'} | Where-Object {$_.DeviceName -ne 'Volume'} | Where-Object {!(($_.DeviceClass -eq 'System') -and ($_.Manufacturer -eq 'Microsoft'))} | Where-Object {$_.DeviceName -notlike 'HID*'} | Where-Object {$_.DeviceName -notlike 'WAN Miniport*'} | Where-Object {$_.Manufacturer -ne '(Standard system devices)'} | Where-Object {$_.DeviceName -ne 'Generic software device'} | Where-Object {$_.DeviceName -ne 'Generic volume shadow copy'} | Sort-Object -Property DeviceClass,DeviceName,FriendlyName | Format-Table -groupby DeviceClass -autosize -Property DeviceName,FriendlyName,Manufacturer


Write-Host

Write-Host "############################################################"
Write-Host "############################################################"

Write-Host
Write-Host -ForegroundColor Red ">>> Virenschutz"
Write-Host


    function Get-AntiVirusProduct {
    [CmdletBinding()]
    param (
    [parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [Alias('name')]
    $computername=$env:computername


    )

    #$AntivirusProducts = Get-WmiObject -Namespace "root\SecurityCenter2" -Query $wmiQuery  @psboundparameters # -ErrorVariable myError -ErrorAction 'SilentlyContinue' # did not work            
     $AntiVirusProducts = Get-WmiObject -Namespace "root\SecurityCenter2" -Class AntiVirusProduct  -ComputerName $computername

    $ret = @()
    foreach($AntiVirusProduct in $AntiVirusProducts){
        #Switch to determine the status of antivirus definitions and real-time protection.
        #The values in this switch-statement are retrieved from the following website: http://community.kaseya.com/resources/m/knowexch/1020.aspx
        switch ($AntiVirusProduct.productState) {
        "262144" {$defstatus = "Up to date" ;$rtstatus = "Disabled"}
            "262160" {$defstatus = "Out of date" ;$rtstatus = "Disabled"}
            "266240" {$defstatus = "Up to date" ;$rtstatus = "Enabled"}
            "266256" {$defstatus = "Out of date" ;$rtstatus = "Enabled"}
            "393216" {$defstatus = "Up to date" ;$rtstatus = "Disabled"}
            "393232" {$defstatus = "Out of date" ;$rtstatus = "Disabled"}
            "393488" {$defstatus = "Out of date" ;$rtstatus = "Disabled"}
            "397312" {$defstatus = "Up to date" ;$rtstatus = "Enabled"}
            "397328" {$defstatus = "Out of date" ;$rtstatus = "Enabled"}
            "397584" {$defstatus = "Out of date" ;$rtstatus = "Enabled"}
        default {$defstatus = "Unknown" ;$rtstatus = "Unknown"}
            }

        #Create hash-table for each computer
        $ht = @{}
        $ht.Computername = $computername
        $ht.Name = $AntiVirusProduct.displayName
        $ht.'Product GUID' = $AntiVirusProduct.instanceGuid
        $ht.'Product Executable' = $AntiVirusProduct.pathToSignedProductExe
        $ht.'Reporting Exe' = $AntiVirusProduct.pathToSignedReportingExe
        $ht.'Definition Status' = $defstatus
        $ht.'Real-time Protection Status' = $rtstatus


        #Create a new object for each computer
        $ret += New-Object -TypeName PSObject -Property $ht 
    }
    Return $ret
} 
Get-AntiVirusProduct | Format-List


Write-Host

Write-Host "############################################################"
Write-Host "############################################################"

Write-Host
Write-Host -ForegroundColor Red ">>> Installierte Programme"
Write-Host

Get-Package -Provider Programs -IncludeWindowsInstaller | sort-object -Property name | Format-Table -Property Name, Version

Write-Host
Write-Host "############################################################"
Write-Host "############################################################"

Write-Host
Write-Host -ForegroundColor Red ">>> Systempower Bericht"
Write-Host

powercfg /systempowerreport /output "C:\!_Checkup\02_Systempowerreport_fuer_$PCname.html"
Write-Host

Write-Host "############################################################"
Write-Host "############################################################"

Write-Host




# Leistungsindex abrufen
Write-Host -BackgroundColor Magenta -ForegroundColor White "##### --- Leistungsindex"
Write-Host
Write-Host -ForegroundColor Yellow "---  Erstellung wurde ohne Logging ausgefuehrt"
Write-Host
Write-Host -ForegroundColor Red ">>> Leistungsindex Ergebnis"

gwmi win32_winsat | fl *score
Write-Host

Write-Host "############################################################"
Write-Host "############################################################"

Write-Host


    [console]::beep(2000,250)
    [console]::beep(2000,250)

# Logging beenden
Write-Host -BackgroundColor Magenta -ForegroundColor White "##### --- Logging wird beendet"

stop-transcript
Write-Host


# Exit
Write-Host 
Write-Host -ForegroundColor Yellow "Press any key to exit ..."
$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")