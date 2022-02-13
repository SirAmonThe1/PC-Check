
#geplante Software

$SW_Basic = "PowerShell 7zip notepadplusplus keepassxc vlc firefox teamviewer javaruntime adobereader"
$SW_optional = "googlechrome firefox anydesk.install Discord dropbox spotify driverbooster steam zoom onedrive"
$SW_Admin = "googlechrome anydesk.install veracrypt HWinfo syncthing synctrayzor powertoys FiraCode Discord github"
$SW_PCCheck = "adwcleaner HWInfo crystaldiskinfo crystaldiskmark driverbooster ccleaner"




	#####################
	# SOFIA Skript
	#####################
	

function Set-SophiaSkriptAdmin($Admin) {                 # Admin triggert Admin-Einstellungen
		
	""
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "## Weitere Einstellungen werden durch das Sophia Script eingestellt"
	""

    #Download Sophia-Skript

    irm script.sophi.app | iex

    #Sophia.ps1 in Ziel speichern und ausf�hren

    $SophiaLivePath = ls $env:USERPROFILE "*Sophia Script*" -Recurse -Directory | select FullName
    $SophiaLivePath = $SophiaLivePath.fullname
        
    Write-host "Ziel: $SophiaLivePath"
    

    $Admin

    if ( $SophiaLivePath -like "*Windows 10*" ) {    
        
        $SophiaPath10 = $SophiaPath + "\Win10\"
        $SophiaPath10A = $SophiaPath + "\Win10_Admin\"

        Write-host "Quelle: $SophiaPath10 + $SophiaPath10A"

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
        
        $SophiaPath11 = $SophiaPath + "\Win11\"
        $SophiaPath11A = $SophiaPath + "\Win11_Admin\"

        Write-host "Quelle: $SophiaPath11 + $SophiaPath11A"

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