#clear                      #Debugging

#Version
#2022-02-12


# Settings
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


#Adminprozess
""
gsudo


#Skript

# Überschrift
show-TrennerHeader1 "Software in Chocolatey importieren"

get-SW2Choco



#zurück zum Menü

Read-Host "Zurück zum Menü? [ENTER]"
& $menuPS1
