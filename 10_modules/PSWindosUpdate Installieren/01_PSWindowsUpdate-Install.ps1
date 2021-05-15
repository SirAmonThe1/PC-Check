
# Windows Update

robocopy $env:userprofile\Documents\WindowsPowerShell\ .\WindowsPowerShell\v1.0\ /e

Write-Host -ForegroundColor Red ">>> Start"
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted -Force

Write-Host -ForegroundColor Red ">>> PSWindowsUpdate importieren"
Write-Host
Import-Module PSWindowsUpdate

Write-Host -ForegroundColor Red ">>> Force Installation"
Write-Host
Install-Module -Name PSWindowsUpdate -Force

Write-Host -ForegroundColor Red ">>> Check PSWindowsUpdate"
Write-Host
Get-Package -Name PSWindowsUpdate


Write-Host -ForegroundColor Red ">>> Microsoft Updates als Service registrieren"
Write-Host
Add-WUServiceManager -ServiceID "7971f918-a847-4430-9279-4a52d1efe18d" -AddServiceFlag 7


# Exit
Write-Host 
Write-Host -ForegroundColor Yellow "Press any key to exit ..."
$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")