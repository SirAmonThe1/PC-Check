#clear                      #Debugging

#Version
#2022-02-12


# Settings
#$setupPath = "C:/!_Checkup_Install/"
$setupPath = "D:\Coding\01_GitHub\PC-Check\"       #Debugging
$skriptPath = $setupPath + "00_Skripte/"
$menuPS1 = $setupPath + "01_Menu.ps1"


#Adminprozess
""
gsudo


#Skript

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
Write-Host "Diese Pakete sind ausgewählt:"
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
                        $SW1 = Read-Host  "---> Bitte in Liste prüfen und neu eingeben: "
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
Write-Host "Abgeschlossen ---> jetzt installiert:"
Write-Host ""

choco list -lo






#zurück zum Menü

Read-Host "Zurück zum Menü? [ENTER]"
& $menuPS1
