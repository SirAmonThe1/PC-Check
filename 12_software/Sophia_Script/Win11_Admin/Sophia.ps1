#Requires -RunAsAdministrator
#Requires -Version 5.1

[CmdletBinding()]
param
(
	[Parameter(Mandatory = $false)]
	[string[]]
	$Functions
)

Clear-Host

$Host.UI.RawUI.WindowTitle = "Sophia Script for Windows 11 v6.2.0 | Made with $([char]::ConvertFromUtf32(0x1F497)) of Windows | $([char]0x00A9) farag & Inestic, 2014$([char]0x2013)2022"

Remove-Module -Name Sophia -Force -ErrorAction Ignore
Import-Module -Name $PSScriptRoot\Manifest\Sophia.psd1 -PassThru -Force

Import-LocalizedData -BindingVariable Global:Localization -BaseDirectory $PSScriptRoot\Localizations -FileName Sophia

<#
	.SYNOPSIS
	Run the script by specifying functions as an argument
	Запустить скрипт, указав в качестве аргумента функции

	.EXAMPLE
	.\Sophia.ps1 -Functions "DiagTrackService -Disable", "DiagnosticDataLevel -Minimal", UninstallUWPApps

	.NOTES
	Use commas to separate funtions
	Разделяйте функции запятыми
#>
if ($Functions)
{
	Invoke-Command -ScriptBlock {Checks}

	foreach ($Function in $Functions)
	{
		Invoke-Expression -Command $Function
	}

	# The "RefreshEnvironment" and "Errors" functions will be executed at the end
	Invoke-Command -ScriptBlock {RefreshEnvironment; Errors}

	exit
}


#region Protection

Checks -Warning
Logging
CreateRestorePoint

#endregion Protection

#region Privacy & Telemetry

DiagTrackService -Disable
DiagnosticDataLevel -Minimal
ErrorReporting -Disable
FeedbackFrequency -Never
ScheduledTasks -Disable
SigninInfo -Disable
LanguageListAccess -Disable
AdvertisingID -Disable
WindowsWelcomeExperience -Hide
WindowsTips -Disable
SettingsSuggestedContent -Hide
AppsSilentInstalling -Disable
WhatsNewInWindows -Disable
TailoredExperiences -Disable
BingSearch -Disable

#endregion Privacy & Telemetry

#region UI & Personalization

ThisPC -Show
CheckBoxes -Disable
HiddenItems -Enable
FileExtensions -Show
MergeConflicts -Show
OpenFileExplorerTo -ThisPC
FileExplorerCompactMode -Enable
OneDriveFileExplorerAd -Hide
SnapAssistFlyout -Enable
SnapAssist -Disable
FileTransferDialog -Detailed
RecycleBinDeleteConfirmation -Enable
QuickAccessRecentFiles -Hide
QuickAccessFrequentFolders -Hide
TaskbarAlignment -Left
TaskbarSearch -Hide
TaskViewButton -Hide
TaskbarWidgets -Hide
TaskbarChat -Hide
ControlPanelView -LargeIcons
WindowsColorMode -Dark
AppColorMode -Dark
FirstLogonAnimation -Disable
JPEGWallpapersQuality -Max
RestartNotification -Show
ShortcutsSuffix -Disable
PrtScnSnippingTool -Enable
AppsLanguageSwitch -Enable
AeroShaking -Disable
Cursors -Dark
UnpinTaskbarShortcuts -Shortcuts Edge, Store

#endregion UI & Personalization

#region OneDrive


#endregion OneDrive

#region System

StorageSense -Enable
StorageSenseFrequency -Month
StorageSenseTempFiles -Enable
Hibernation -Disable
Win32LongPathLimit -Disable
BSoDStopError -Enable
AdminApprovalMode -Never
MappedDrivesAppElevatedAccess -Enable
DeliveryOptimization -Enable
WaitNetworkStartup -Enable
WindowsManageDefaultPrinter -Disable
WindowsFeatures -Disable
WindowsCapabilities -Uninstall
UpdateMicrosoftProducts -Enable
PowerPlan -High
LatestInstalled.NET -Enable
NetworkAdaptersSavePower -Disable
IPv6Component -Disable
SetUserShellFolderLocation -Root
WinPrtScrFolder -Desktop
RecommendedTroubleshooting -Automatically
FoldersLaunchSeparateProcess -Enable
ReservedStorage -Disable
F1HelpPage -Disable
NumLock -Enable
StickyShift -Disable
Autoplay -Disable
ThumbnailCacheRemoval -Disable
SaveRestartableApps -Enable
NetworkDiscovery -Enable
ActiveHours -Automatically
RestartDeviceAfterUpdate -Disable
DefaultTerminalApp -WindowsTerminal
InstallVCRedist
InstallDotNetRuntime6

#endregion System

#region WSL


#endregion WSL

#region Start menu

RunPowerShellShortcut -Elevated
StartLayout -Default
UnpinAllStartApps

#endregion Start menu

#region UWP apps

HEIF -Install
CortanaAutostart -Disable
TeamsAutostart -Disable
UninstallUWPApps -ForAllUsers
CheckUWPAppsUpdates

#endregion UWP apps

#region Gaming

XboxGameBar -Disable
XboxGameTips -Disable
GPUScheduling -Enable

#endregion Gaming

#region Scheduled tasks

CleanupTask -Register
SoftwareDistributionTask -Register
TempTask -Register

#endregion Scheduled tasks

#region Microsoft Defender & Security

NetworkProtection -Enable
PUAppsDetection -Enable
AuditProcess -Enable
CommandLineProcessAudit -Enable
EventViewerCustomView -Enable
PowerShellModulesLogging -Enable
PowerShellScriptsLogging -Enable
AppsSmartScreen -Disable
SaveZoneInformation -Disable
DismissMSAccount
DismissSmartScreenFilter
DNSoverHTTPS -Enable -PrimaryDNS 1.0.0.1 -SecondaryDNS 1.1.1.1

#endregion Microsoft Defender & Security

#region Context menu

MSIExtractContext -Show
CABInstallContext -Show
RunAsDifferentUserContext -Show
CastToDeviceContext -Hide
ShareContext -Hide
EditWithPhotosContext -Hide
CreateANewVideoContext -Hide
PrintCMDContext -Hide
IncludeInLibraryContext -Hide
SendToContext -Hide
CompressedFolderNewContext -Hide
MultipleInvokeContext -Disable
UseStoreOpenWith -Hide
OpenWindowsTerminalContext -Show
OpenWindowsTerminalAdminContext -Enable
Windows10ContextMenu -Enable

#endregion Context menu

#region Update Policies

UpdateLGPEPolicies

#endregion Update Policies

RefreshEnvironment
Errors
