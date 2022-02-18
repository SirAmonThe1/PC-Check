
#geplante Software

$SW_Basic = "PowerShell,7zip,notepadplusplus,keepassxc,vlc,firefox,teamviewer,javaruntime,adobereader"
$SW_optional = "googlechrome,anydesk.install,Discord,dropbox,spotify,driverbooster,steam,zoom,onedrive"
$SW_Admin = "googlechrome,anydesk.install,veracrypt,HWinfo,syncthing,synctrayzor,powertoys,FiraCode,Discord,github"
$SW_PCCheck = "adwcleaner,HWInfo,crystaldiskinfo,crystaldiskmark,driverbooster,ccleaner,ccenhancer"

    
function install-software($SWoption) {                    # Basic, optional, admin, pccheck


	Write-Host -BackgroundColor Black -ForegroundColor Cyan "Wichtige Software wird installiert"
	Write-Host -BackgroundColor Blue -ForegroundColor White ">>> Pakete: " $SW_Basic
    Write-Host -BackgroundColor Blue -ForegroundColor White ">>> optionale Pakete mit Auswahl: " $SW_optional
    if ($SWoption -eq 'admin') { Write-Host -BackgroundColor Blue -ForegroundColor White ">>> Admin Pakete: " $SW_Admin }
    if ($SWoption -eq 'PCCheck') { Write-Host -BackgroundColor Blue -ForegroundColor White ">>> PCCheck Pakete: " $SW_PCCheck }
	Write-Host
	
	# Installationen 
	
    $SW_Basic = $SW_Basic.Split(",")

        foreach ($SW in $SW_Basic) {
            
            ""
	        cup  $SW -y --ignore-checksums --limit-output
            show-TrennerKlein
    
    }
    
    if ($SWoption -eq 'admin') { 
        
        $SW_Admin = $SW_Admin.Split(",")

        foreach ($SW in $SW_Admin) {

            ""
	        cup  $SW -y --ignore-checksums --limit-output
            show-TrennerKlein

        }
    }


    if ($SWoption -eq 'PCCheck') { 
        
        $SW_PCCheck = $SW_PCCheck.Split(",")

        foreach ($SW in $SW_PCCheck) {

            ""
	        cup  $SW -y --ignore-checksums --limit-output
            show-TrennerKlein

        }
    }

        [console]::beep(2000,250)
        [console]::beep(2000,250)





    $SW_optional = $SW_optional.Split(",")

    foreach ($SW in $SW_optional) {
        
        ""
        $confirmation = Read-Host ">>> $SW installieren? [y/n]"
		if ($confirmation -eq 'y') { cup $SW -y --limit-output --ignore-checksum  }
		if ($confirmation -eq 'n') { Write-Host ">>> $SW wurde �bersprungen" }
        show-TrennerKlein

    } 

}





function uninstall-softwarePCCheck {

Write-Host
Write-Host -BackgroundColor Black -ForegroundColor Cyan "--- Deinstalliere temporaer fuer den Checkup installierte Software"
Write-Host -BackgroundColor Blue -ForegroundColor White ">>> Pakete: " $SW_PCCheck
write-host

    if ($SWoption -eq 'PCCheck') { 
        
        $SW_PCCheck = $SW_PCCheck.Split("/")

        foreach ($SW in $SW_PCCheck) {

	        choco uninstall  $SW -y --ignore-checksums --limit-output
            show-TrennerKlein
        
        }
    }

write-host	



}







function get-SW2Choco {


    Write-Host ""
    Write-Host "Installierte Programme auflisten"
    Write-Host ""

    Get-Package -Provider Programs | sort-object -Property name | Format-Table -Property Name

    Write-Host ""
    Write-Host "Welche Programme sollen importiert werden"
    Write-Host -Foregroundcolor DarkGray ">>> Paketnamen mit Komma trennen (z.B.: 7-zip,TeamViewer,spotify)"
    Write-Host ""
    $SW0 = Read-Host 
    $SWArray = $SW0.Split(",")
    Write-Host ""
    Write-Host "Diese Pakete sind ausgew�hlt:"
    $SWArray


    Write-Host ""
    Write-Host "Vergleiche mit Chocolatey Bibliothek"
    Write-Host -Foregroundcolor DarkGray ">>> Bibliothek wird eingelesen, bitte warten..."
    Write-Host ""

    foreach ($SW in $SWArray)
        {
            Write-Host "Verarbeite:" $SW
            $SW_up = choco search $SW
            if ($SW_up -like "*0 packages found*")
                {
                    Write-Host "---> Software nicht gefunden"   
                }
            else
                {
                    $SW_up = cup $SW -y -r --ignore-checksum
                    if ($SW_up -like "*The package was not found with the source(s) listed*")
                        {
                            Write-Host "---> Software nicht genau genug"
                            ""
                            choco search $SW
                            ""
                            $SW1 = Read-Host  "---> Bitte in Liste pr�fen und neu eingeben: "
                            $SW_up = cup $SW1 -y -r --ignore-checksum
                            if ($SW_up -like "*Chocolatey upgraded 0/*")
                                {
                                    Write-host "---> Software bereits vorhanden"
                                }
                        }
                    else {Write-host "---> Software installiert"}
                }
        }

    Write-Host ""
    Write-Host "Abgeschlossen ---> aktuell installierte SW:"
    Write-Host ""

    choco list -lo


}










	#####################
	# SOFIA Skript
	#####################
	

function Set-SophiaSkript($Admin) {                 # Admin triggert Admin-Einstellungen
		
	""
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "## Weitere Einstellungen werden durch das Sophia Script eingestellt"
	""

    #Download Sophia-Skript

    irm script.sophi.app | iex

    #Sophia.ps1 in Ziel speichern und ausf�hren

    $SophiaLivePath = ls $env:USERPROFILE "*Sophia Script*" -Recurse -Directory | select FullName
    $SophiaLivePath = $SophiaLivePath.fullname
        
    Write-host "Downloadordner: " + $SophiaLivePath
    

    $Admin

    if ( $SophiaLivePath -like "*Windows 10*" ) {    
        
        $SophiaPath10 = "C:\!_Checkup_Install\12_software\Sophia_Script\Win10\"
        $SophiaPath10A = "C:\!_Checkup_Install\12_software\Sophia_Script\Win10_Admin\"

        Write-host "Quellen: " + $SophiaPath10 + $SophiaPath10A

        if ($Admin -contains 'Admin') {  robocopy $SophiaLivePath $sophiaPath10A /e /xf sophia.ps1 
                            Write-Host "Sophia.ps1 wurde von $SophiaLivePath in $sophiaPath10A kopiert "
                            ii $sophiaPath10A
                            }

        else {  robocopy $SophiaLivePath $sophiaPath10 /e /xf sophia.ps1 
                            Write-Host "Sophia.ps1 wurde von $SophiaLivePath in $sophiaPath10 kopiert "
                            ii $sophiaPath10
                            }
    
        }
    
    if ( $SophiaLivePath -like "*Windows 11*" ) {    
        
        $SophiaPath11 = "C:\!_Checkup_Install\12_software\Sophia_Script\Win11\"
        $SophiaPath11A = "C:\!_Checkup_Install\12_software\Sophia_Script\Win11_Admin\"

        Write-host "Quellen: " + $SophiaPath11 + $SophiaPath11A

        if ($Admin -contains 'Admin') {  robocopy $SophiaLivePath $sophiaPath11A /e /xf sophia.ps1 
                            Write-Host "Sophia.ps1 wurde von $SophiaLivePath in $sophiaPath11A kopiert "
                            ii $sophiaPath11A
                            } 

        else {  robocopy $SophiaLivePath $sophiaPath11 /e /xf sophia.ps1 
                            Write-Host "Sophia.ps1 wurde von $SophiaLivePath in $sophiaPath11 kopiert "
                            ii $sophiaPath11
                            }
 
        $sophiaLivePath1 = $sophiaLivePath + "\Sophia.ps1"
        Start-Process powershell.exe -ArgumentList "-file $sophiaLivePath\Sophia.ps1", "-WindowStyle Maximized", "-wait", "-Verb RunAs"
    }


    ""
    ""
    Write-host -Foregroundcolor red "Bitte das Sophia-Skript �ber die Sophia.bat Datei �ffnen"

    	[console]::beep(2000,250)
        [console]::beep(2000,250)

    Read-Host "--> nach Ausf�hrung mit ENTER best�tigen"

	write-host
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "Explorer neu starten"
	#Stop-Process -ProcessName explorer	
	Write-Host -BackgroundColor Blue -ForegroundColor White ">>> OK"

}







function install-antivir {
    
    out-beep

	$confirmation = Read-Host ">>> Kaspersky Internet Security installieren? [y/n]"
		if ($confirmation -eq 'y') {
			start-process $softwarePath\Kaspersky\kis.exe}
		if ($confirmation -eq 'n') {
			Write-Host -BackgroundColor Blue -ForegroundColor White ">>> Bitte einen anderen Virenschutz aktivieren (evtl. Windows Defender)"
		}

    Out-Beep

	Read-Host ">>> Virenschutz fertig installiert? [Enter]"
	write-host

}