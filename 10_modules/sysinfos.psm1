
function get-sysWindows {


    Write-Host -BackgroundColor Blue -ForegroundColor White ">>> Windows"
    Write-Host

    Get-ComputerInfo |
      Select-Object -Property OsName,OsArchitecture,OsBuildNumber,OsLanguage,CsPCSystemType,OsSerialNumber,WindowsInstallDateFromRegistry

    Write-Host

}



function get-sysWindowsLicense {



    Write-Host Write-Host -BackgroundColor Blue -ForegroundColor White ">>>  Windows Lizenz-Auslesen (evtl. nicht erfolgreich)"
    Write-Host

    wmic path softwarelicensingservice get OA3xOriginalProductKey

    Write-Host

}


function get-sysOfficeLicense {

    Write-Host
    Write-Host -BackgroundColor Black -ForegroundColor Cyan "--- Microsoft Office Lizenz auslesen"
    Write-Host

    Write-Host -BackgroundColor Blue -ForegroundColor White ">>> 32-Bit Systeme"
    cscript "C:\Program Files (x86)\Microsoft Office\Office16\OSPP.VBS" /dstatus
    write-host
    Write-Host -BackgroundColor Blue -ForegroundColor White ">>> 64-Bit Systeme"
    cscript "C:\Program Files\Microsoft Office\Office16\OSPP.VBS" /dstatus

    Write-Host

}




function Get-sysVirenschutz {

    Write-Host
    Write-Host -BackgroundColor Black -ForegroundColor Cyan "--- Virenschutz"
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

}





function get-sysPSWindowsUpdateVersion {

    Write-Host
    Write-Host -BackgroundColor Black -ForegroundColor Cyan "--- Pruefe PSWindowsUpdate Installation"
    Write-Host

    $PSWU = Get-Package -Name PSWindowsUpdate
    $PSWU | Format-Table -Property Name,Version

    do{
	    if ($PSWU.Version -eq "2.2.0.2") {
        Write-Host -ForegroundColor Green ">>> PSWindowsUpdate ist aktuell"
	
	    } else {
		    Write-Host -BackgroundColor Black -ForegroundColor Cyan "PSWindowsUpdate installieren"
	        Install-Module -Name PSWindowsUpdate -Force -allowclobber
            cinst PSWindowsUpdate --ignore-checksums --limit-output -y -f
            $PSWU = Get-Package -Name PSWindowsUpdate
            if ($PSWU.Version -eq "2.2.0.2") {
                Write-Host -ForegroundColor Green ">>> PSWindowsUpdate ist aktuell"
		    } else {
                Write-Host -ForegroundColor DarkGray ($PSWU | Format-Table | Out-String)
		        Write-Host -ForegroundColor Magenta ">>> Bitte PSWindowsUpdate über .bat Datei installieren"
                x = $modulesPath + "\PSWindosUpdate Installieren"
                ii x

		            [console]::beep(2000,250)
			        [console]::beep(2000,250)
		        Read-Host -Prompt "Fertig installiert? [Enter]" 
		        Write-Output "Get-WindowsUpdate"
		        $PSWU = Get-Package -Name PSWindowsUpdate
			    }
	        [console]::beep(2000,250)
		    [console]::beep(2000,250)
		    Add-WUServiceManager -ServiceID "7971f918-a847-4430-9279-4a52d1efe18d" -AddServiceFlag 7
		    }
	    }
    while	($PSWU.Version -ne "2.2.0.2")

    Write-Host

}





function get-festplatte {

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


}