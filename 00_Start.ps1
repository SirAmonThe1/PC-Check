#Version
#2022-02-12


# Settings
$repoUri = 'https://github.com/SirAmonThe1/PC-Check.git'
#$setupPath = "C:/!_Checkup_Install/"
$setupPath = "D:\Coding\01_GitHub\PC-Check\"       #Debugging
$menuPS1 = "C:/!_Checkup_Install/01_Menu.ps1"



#Adminprozess
gsudo


#Skript


# Begrueßung

write-host -BackgroundColor Green -ForegroundColor White "Willkommen beim PC-Check"
write-host
Write-Host -BackgroundColor Black -ForegroundColor Cyan "Pruefe Grundlagen fuer weitere Bearbeitung"
write-host

Set-ExecutionPolicy Bypass -Scope Process -Force


Write-Host -BackgroundColor Black -ForegroundColor Cyan "Teste Internetverbindung"

if (-not (Test-Connection -ComputerName www.google.com -Quiet)){
 Write-Host -BackgroundColor Blue -ForegroundColor red "Keine Internetverbindung!"
 read-host "Hier manuelle Kopie vom Stick einfuegen per robocopy"
} else {
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "Internetverbindung steht!"
}



Write-Host -BackgroundColor Black -ForegroundColor Cyan "$setupPath fuer die benoetigten Dateien bereinigen"

Push-Location "/"
# Clean if necessary
if (Test-Path -Path $setupPath) {
    Remove-Item $setupPath -Recurse -Force
}

write-host
Write-Host -BackgroundColor Black -ForegroundColor Cyan "############################################################"
Write-Host -BackgroundColor Black -ForegroundColor Cyan "############################################################"

Write-Host
Write-Host -BackgroundColor Black -ForegroundColor Cyan "Repository auf das Laufwerk C:\ downloaden"
write-host
Write-Host -BackgroundColor Blue -ForegroundColor White ">>> Installiere chocolately"
Write-Host 

Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

write-host
Write-Host -BackgroundColor Blue -ForegroundColor White ">>> Installiere gsudo (Tool zum privilegieren von PowerShell-Instanzen)"
Write-Host 

cup gsudo -y -limit-output
# Install git
Write-Host -BackgroundColor Blue -ForegroundColor White ">>> Installiere git"
Write-Host 

& choco install git --confirm --limit-output

# Reset the path environment
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 

Write-Host 
Write-Host -BackgroundColor Blue -ForegroundColor White ">>> Repository Clonen"
Write-Host 

# Clone the setup repository
& git clone $repoUri $setupPath

# Enter inside the repository and invoke the real set-up process
write-host
Write-Host -BackgroundColor Black -ForegroundColor Cyan "Wechsle in Setup-Pfad"
Write-Host 

Push-Location $setupPath
write-host $setupPath

Write-Host -BackgroundColor Black -ForegroundColor Cyan "Importiere Module"
Write-Host 
Get-ChildItem .\10_modules\*.psm1 | Import-Module -Force

Write-Host


# Skript auswaehlen

ii $setupPath

& '$menuPS1'