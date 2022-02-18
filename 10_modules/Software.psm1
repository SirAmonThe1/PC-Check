#clear                      #Debugging

#Version
#2022-02-18



#geplante Software

$SW_Basic = "PowerShell,7zip,notepadplusplus,keepassxc,vlc,firefox,teamviewer,javaruntime,adobereader"
$SW_optional = "googlechrome,anydesk.install,Discord,dropbox,spotify,driverbooster,steam,zoom,onedrive"
$SW_Admin = "googlechrome,anydesk.install,veracrypt,HWinfo,syncthing,synctrayzor,powertoys,FiraCode,Discord,github"
$SW_PCCheck = "adwcleaner,HWInfo,crystaldiskinfo.portable,crystaldiskmark,driverbooster,ccleaner,ccenhancer,treesizefree"

    
function install-software($SWoption) {                    # Basic, optional, admin, pccheck


	Write-Host -BackgroundColor Black -ForegroundColor Cyan "Wichtige Software wird installiert"
	Write-Host -BackgroundColor Blue -ForegroundColor White ">>> Pakete: " $SW_Basic
    Write-Host -BackgroundColor Blue -ForegroundColor White ">>> optionale Pakete mit Auswahl: " $SW_optional
    if ($SWoption -eq 'admin') { Write-Host -BackgroundColor Blue -ForegroundColor White ">>> Admin Pakete: " $SW_Admin }
    if ($SWoption -eq 'PCCheck') { Write-Host -BackgroundColor Blue -ForegroundColor White ">>> PCCheck Pakete: " $SW_PCCheck }
	Write-Host
	
	# Installationen 
	
    #### BASIC
    
    $SW_Basic = $SW_Basic.Split(",")

        foreach ($SW in $SW_Basic) {
            
            ""
	        cup  $SW -y --ignore-checksums --limit-output
            show-TrennerKlein
    
    }

    #### ADMIN
    
    if ($SWoption -eq 'admin') { 
        
        $SW_Admin = $SW_Admin.Split(",")

        foreach ($SW in $SW_Admin) {

            ""
	        cup  $SW -y --ignore-checksums --limit-output
            show-TrennerKlein

        }
    }

    #### PCCHECK

    if ($SWoption -eq 'PCCheck') { 
        
        $SW_PCCheck = $SW_PCCheck.Split(",")

        foreach ($SW in $SW_PCCheck) {

            ""
	        cup  $SW -y --ignore-checksums --limit-output
            show-TrennerKlein

        }
    }

    out-beep

    #### OPTIONAL

    $SW_optional = $SW_optional.Split(",")

    foreach ($SW in $SW_optional) {
        
        ""
        $confirmation = Read-Host ">>> $SW installieren? [y/n]"
		if ($confirmation -eq 'y') { cup $SW -y --limit-output --ignore-checksum  }
		if ($confirmation -eq 'n') { show-Output "$SW wurde �bersprungen" }
        show-TrennerKlein

    } 

}





function uninstall-softwarePCCheck {

    $SW_PCCheck = $SW_PCCheck.Split(",")

    foreach ($SW in $SW_PCCheck) {
        
        ""
	    choco uninstall  $SW -y --ignore-checksums --limit-output
        show-TrennerKlein
        
    }
}







function get-SW2Choco {

    show-Output "Installierte Programme auflisten"
    ""

    Get-Package -Provider Programs | sort-object -Property name | Format-Table -Property Name

    ""
    show-Output "Welche Programme sollen importiert werden?      [Leer lassen zum �berspringen]"
    Write-Host -Foregroundcolor DarkGray ">>> Paketnamen mit Komma trennen (z.B.: 7-zip,TeamViewer,spotify)"
    ""
    $SW0 = Read-Host 

    If ( $SW0 -eq "" ) {  show-Output "Keine Pakete importieren"  }

    Else {

        $SWArray = $SW0.Split(",")
        ""
        show-Output "Diese Pakete sind ausgew�hlt:"
        $SWArray
        
        ""
        show-Output "Vergleiche mit Chocolatey Bibliothek"
        Write-Host -Foregroundcolor DarkGray ">>> Bibliothek wird eingelesen, bitte warten..."
        ""

        foreach ($SW in $SWArray)
            {
                show-Output "Verarbeite:" $SW

                $SW_up = cup $SW -y --ignore-checksums --limit-output

                if ( $SW_up -like "*The package was not found with the source(s) listed*" ) {
                
                    show-Output "Software nicht genau genug"
                    ""
                    choco search $SW
                    ""
                    $SW1 = Read-Host  "---> Bitte in Liste pr�fen und neu eingeben: "
                    
                    cup $SW1 -y --ignore-checksums --limit-output
                    show-TrennerKlein
                    
                } else { 

                    $SW_up 
                    show-TrennerKlein

                }

            }

        ""
        show-Output "Abgeschlossen ---> aktuell installierte SW:"
        ""

        choco list -lo

    }

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

    out-beep

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