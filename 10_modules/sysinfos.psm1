#clear                      #Debugging

#Version
#2022-02-18



function get-sysWindows {

    Get-ComputerInfo | Select-Object -Property OsName,OsArchitecture,OsBuildNumber,OsLanguage,CsPCSystemType,OsSerialNumber,WindowsInstallDateFromRegistry

}



function get-sysWindowsLicense {



    show-Output "Windows Lizenz-Auslesen"
    show-OutputGray "Abfrage ist evtl. nicht erfolgreich"
    
    wmic path softwarelicensingservice get OA3xOriginalProductKey

    Write-Host

}


function get-sysOfficeLicense {

    show-Output "32-Bit Systeme"
    cscript "C:\Program Files (x86)\Microsoft Office\Office16\OSPP.VBS" /dstatus
    
    show-TrennerKlein

    show-Output "64-Bit Systeme"
    cscript "C:\Program Files\Microsoft Office\Office16\OSPP.VBS" /dstatus

}




function Get-sysVirenschutz {

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

    $PSWU = Get-Package -Name PSWindowsUpdate
    $PSWU | Format-Table -Property Name,Version

    do{
	    if ($PSWU.Version -eq "2.2.0.2") {  Write-Host -ForegroundColor Green ">>> PSWindowsUpdate ist aktuell"  } 
            else {
                update-PSWindowsUpdatex

                $PSWU = Get-Package -Name PSWindowsUpdate

                if ($PSWU.Version -eq "2.2.0.2") {  Write-Host -ForegroundColor Green ">>> PSWindowsUpdate ist aktuell" } 
                    else {
                        Write-Host -ForegroundColor DarkGray ($PSWU | Format-Table | Out-String)
		                Write-Host -ForegroundColor Magenta ">>> Bitte PSWindowsUpdate über .bat Datei installieren"
                        x = $modulesPath + "\PSWindosUpdate Installieren"
                        ii x

                        out-beep

		                Read-Host -Prompt "Fertig installiert? [Enter]" 
		                Write-Output "Get-WindowsUpdate"
		                $PSWU = Get-Package -Name PSWindowsUpdate
			        }

                out-beep
		        Add-WUServiceManager -ServiceID "7971f918-a847-4430-9279-4a52d1efe18d" -AddServiceFlag 7
		    }
	    }

    while	($PSWU.Version -ne "2.2.0.2")

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