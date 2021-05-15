# Begrüßung

write-host -BackgroundColor Magenta -ForegroundColor White "Willkommen beim PC-Check"
write-host
write-host "Pruefe Grundlagen fuer weitere Bearbeitung"
write-host

Set-ExecutionPolicy Bypass -Scope Process -Force


write-host "Teste Internetverbindung"

if (-not (Test-Connection -ComputerName www.google.com -Quiet)){
 Write-Host -ForegroundColor red "Keine Internetverbindung!"
 read-host "Hier manuelle Kopie vom Stick einfügen per robocopy"
} else {
	write-host -ForegroundColor green "Internetverbindung steht!"
}

# Settings
$repoUri = 'https://github.com/SirAmonThe1/PC-Check.git'
$setupPath = "C:/!_Checkup_Install"

write-host "$setupPath fuer die benoetigten Dateien bereinigen"

Push-Location "/"
# Clean if necessary
if (Test-Path -Path $setupPath) {
    Remove-Item $setupPath -Recurse -Force
}

write-host
Write-Host "############################################################"
Write-Host "############################################################"

Write-Host
Write-Host -BackgroundColor Magenta -ForegroundColor White "Repository auf das Laufwerk C:\ downloaden"
write-host
Write-Host "Installiere chocolately"
Write-Host 

Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install git
Write-Host "Installiere git"
Write-Host 

& choco install git --confirm --limit-output

# Reset the path environment
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 

Write-Host 
Write-Host "Repository Clonen"
Write-Host 

# Clone the setup repository
& git clone $repoUri $setupPath

# Enter inside the repository and invoke the real set-up process
write-host
Write-Host "Wechsle in Setup-Pfad"
Write-Host 

Push-Location $setupPath
write-host $setupPath

Write-Host "Importiere Module"
Write-Host 
Get-ChildItem .\10_modules\*.psm1 | Import-Module -Force

Write-Host

Write-Host "Installiere gsudo (Tool zum privilegieren von PowerShell-Instanzen)"
Write-Host 

cup gsudo -y -limit-output

# Skript auswählen

# $sel = "01_Startinfos", "10_Instal-Skript", "20_Checkup-Skript_BASIC", "21_Checkup-Skript_CHECK", "30_Abschluss", "TESTSKRIPT" | Out-GridView -PassThru -Title "Arbeitsschritt wählen"

do{

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Waehle einen Arbeitsschritt'
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = 'CenterScreen'

$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(75,120)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(150,120)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'Abbrechen'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Bitte waehle einen Arbeitsschrittr:'
$form.Controls.Add($label)

$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(10,40)
$listBox.Size = New-Object System.Drawing.Size(260,20)
$listBox.Height = 90

[void] $listBox.Items.Add('01_Startinfos')
[void] $listBox.Items.Add('10_Instal-Skript')
[void] $listBox.Items.Add('20_Checkup-Skript_BASIC')
[void] $listBox.Items.Add('21_Checkup-Skript_CHECK')
[void] $listBox.Items.Add('30_Abschluss')
[void] $listBox.Items.Add('TESTSKRIPT')

$form.Controls.Add($listBox)

$form.Topmost = $true

$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $x = $listBox.SelectedItem
}

write-host "Gewaehlt: $x"
write-host

write-host "Arbeitsverzeichnis: $setupPath"
write-host "Starte .bat-Datei: $setupPath\$x.ps1"
start-process $setupPath\$x.bat -WindowStyle Maximized

write-host
$confirmation = Read-Host ">>> Weiteres Skript waehlen? [y/n]"

} while ($confirmation -eq 'y')