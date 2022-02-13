#clear      #Debugging

#Version
#2022-02-12


#Settings

#$setupPath = "C:/!_Checkup_Install/"
$setupPath = "D:/Coding/01_GitHub/PC-Check/"       #Debugging
$skriptPath = $setupPath + "00_Skripte/"


#Adminprozess
""
#gsudo


#Skript


#Menuetexte

$Opt1 = "Informationen zum PC-Zustand erstellen"
$Opt2 = "Einen Standard-PC einrichten"
$Opt3 = "Einen Admin-PC einrichten"
$Opt4 = "Eine PC für eine Prüfung vorbereiten"
$Opt5 = "PC-Prüfung durchführen ---> Bitte zuvor Menüpunkt 4 zur Vorbereitung ausführen"
$Opt6 = "Abschlussbericht erstellen und bereinigen"
$Opt7 = "Installierte Software in Chocolatey importieren"
$Opt8 = ""
$Opt9 = ""
$Opt0 = "PC-Check neu installieren / updaten"

#.ps1 Dateien je Option

$Skript1 = "01_Startinfos.ps1"
$Skript2 = ""
$Skript3 = ""
$Skript4 = ""
$Skript5 = ""
$Skript6 = ""
$Skript7 = "11_SWtoChoco.ps1"
$Skript8 = ""
$Skript9 = ""
$Skript0 = ""

Write-Host ""
Write-Host ""
Write-Host ""
Write-Host "###############"
Write-Host ""
Write-Host "PC-Check Menue"
Write-Host ""
Write-Host "###############"
Write-Host ""
Write-Host ""
Write-Host ""

Write-Host "Übersicht"
Write-Host ""
Write-Host "1 = " $Opt1
Write-Host "2 = " $Opt2
Write-Host "3 = " $Opt3
Write-Host "4 = " $Opt4
Write-Host "5 = " $Opt5
Write-Host "6 = " $Opt6
Write-Host "7 = " $Opt7
Write-Host "8 = " $Opt8
Write-Host "9 = " $Opt9
Write-Host "0 = " $Opt0

Write-Host ""
$opt = Read-Host "Welche Option soll ausgeführt werden?"

if ( $opt -eq 0 ) {     $result = $Opt0      
                        $Skript = $Skript0  }
elseif ( $opt -eq 1 ) { $result = $Opt1
                        $Skript = $Skript1  }
elseif ( $opt -eq 2 ) { $result = $Opt2  
                        $Skript = $Skript2  }
elseif ( $opt -eq 3 ) { $result = $Opt3  
                        $Skript = $Skript3  }
elseif ( $opt -eq 4 ) { $result = $Opt4  
                        $Skript = $Skript4  }
elseif ( $opt -eq 5 ) { $result = $Opt5  
                        $Skript = $Skript5  }
elseif ( $opt -eq 6 ) { $result = $Opt6  
                        $Skript = $Skript6  }
elseif ( $opt -eq 7 ) { $result = $Opt7  
                        $Skript = $Skript7  }
elseif ( $opt -eq 8 ) { $result = $Opt8  
                        $Skript = $Skript8  }
elseif ( $opt -eq 9 ) { $result = $Opt9  
                        $Skript = $Skript9  }

""
$result
$result = $skriptPath + $Skript         
$result                                #Debugging


#Verlauf leeren

clear


#Starte das Skript

& $result