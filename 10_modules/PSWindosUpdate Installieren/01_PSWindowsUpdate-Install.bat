@echo off
@setlocal enableextensions  
@cd /d "%~dp0"
robocopy .\PSWindowsUpdate_2.2.0.2\ %USERPROFILE%\Documents\WindowsPowerShell\ /e
PowerShell.exe -Command "& {Start-Process PowerShell.exe -ArgumentList '-ExecutionPolicy Bypass -File ""%~dpn0.ps1""' -Verb RunAs}"