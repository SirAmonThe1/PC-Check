Clear-Host
$Host.UI.RawUI.WindowTitle = 'Windows 10 Sophia Script | Copyright farag & oZ-Zo, 2015 to 2021'
Remove-Module -Name Sophia -Force -ErrorAction Ignore
Import-Module -Name $PSScriptRoot\Sophia.psd1 -PassThru -Force
Import-LocalizedData -BindingVariable Global:Localization -FileName Sophia -BaseDirectory $PSScriptRoot\Localizations
Checkings -Warning

#region Protection

Logging
CreateRestorePoint

#endregion Protection

#region Privacy & Telemetry

DiagnosticDataLevel -Minimal
ErrorReporting -Disable
WindowsFeedback -Disable
ScheduledTasks -Disable
SigninInfo -Disable
LanguageListAccess -Disable
AdvertisingID -Disable
ShareAcrossDevices -Disable
WindowsWelcomeExperience -Hide
WindowsTips -Enable
SettingsSuggestedContent -Hide
AppsSilentInstalling -Disable
WhatsNewInWindows -Disable
TailoredExperiences -Disable
BingSearch -Disable

#endregion Privacy & Telemetry

#region UI & Personalization

ThisPC -Show
CheckBoxes -Disable
HiddenItems -Disable
FileExtensions -Show
MergeConflicts -Show
OpenFileExplorerTo -ThisPC
CortanaButton -Hide
OneDriveFileExplorerAd -Hide
TaskViewButton -Hide
PeopleTaskbar -Hide
SecondsInSystemClock -Show
SnapAssist -Disable
FileTransferDialog -Detailed
FileExplorerRibbon -Expanded
RecycleBinDeleteConfirmation -Enable
3DObjects -Hide
QuickAccessFrequentFolders -Hide
QuickAccessRecentFiles -Hide
TaskbarSearch -Hide
WindowsInkWorkspace -Hide
TrayIcons -Show
MeetNow -Hide
NewsInterests -Hide
ControlPanelView -LargeIcons
WindowsColorScheme -Dark
AppMode -Dark
NewAppInstalledNotification -Hide
FirstLogonAnimation -Disable
JPEGWallpapersQuality -Max
TaskManagerWindow -Expanded
RestartNotification -Show
ShortcutsSuffix -Disable
PrtScnSnippingTool -Enable
AppsLanguageSwitch -Disable
UnpinTaskbarEdgeStore

#endregion UI & Personalization

#region OneDrive


#endregion OneDrive

#region System

StorageSense -Enable
StorageSenseFrequency -Month
StorageSenseTempFiles -Enable
StorageSenseRecycleBin -Enable
Hibernate -Enable
TempFolder -Default
Win32LongPathLimit -Disable
BSoDStopError -Enable
AdminApprovalMode -Disable
MappedDrivesAppElevatedAccess -Enable
DeliveryOptimization -Disable
WaitNetworkStartup -Enable
WindowsManageDefaultPrinter -Disable
WindowsFeatures -Enable
WindowsCapabilities -Uninstall
UpdateMicrosoftProducts -Enable
PowerManagementScheme -High
LatestInstalled.NET -Enable
PCTurnOffDevice -Disable
SetUserShellFolderLocation -Root
WinPrtScrFolder -Desktop
RecommendedTroubleshooting -Default
FoldersLaunchSeparateProcess -Enable
ReservedStorage -Disable
F1HelpPage -Disable
NumLock -Enable
StickyShift -Disable
Autoplay -Disable
ThumbnailCacheRemoval -Disable
SaveRestartableApps -Enable
NetworkDiscovery -Enable
SmartActiveHours -Enable
DeviceRestartAfterUpdate -Disable

#endregion System

#region WSL


#endregion WSL

#region Start menu

RecentlyAddedApps -Hide
AppSuggestions -Hide
RunPowerShellShortcut -Elevated
PinToStart -UnpinAll
PinToStart -Tiles ControlPanel, DevicesPrinters, PowerShell

#endregion Start menu

#region UWP apps

HEIF -Install
CortanaAutostart -Disable
BackgroundUWPApps -Disable
UninstallUWPApps -ForAllUsers
CheckUWPAppsUpdates

#endregion UWP apps

#region Gaming

XboxGameBar -Disable
XboxGameTips -Disable
GPUScheduling -Enable
SetAppGraphicsPerformance

#endregion Gaming

#region Scheduled tasks

CleanupTask -Register
SoftwareDistributionTask -Register
TempTask -Register

#endregion Scheduled tasks

#region Microsoft Defender & Security

NetworkProtection -Enable
PUAppsDetection -Enable
DefenderSandbox -Enable
AuditProcess -Enable
AuditCommandLineProcess -Enable
EventViewerCustomView -Enable
PowerShellModulesLogging -Enable
PowerShellScriptsLogging -Enable
AppsSmartScreen -Disable
SaveZoneInformation -Disable
WindowsScriptHost -Disable
WindowsSandbox -Enable
DismissMSAccount
DismissSmartScreenFilter

#endregion Microsoft Defender & Security

#region Context menu

MSIExtractContext -Add
CABInstallContext -Add
RunAsDifferentUserContext -Add
CastToDeviceContext -Hide
ShareContext -Hide
EditWithPaint3DContext -Hide
EditWithPhotosContext -Hide
CreateANewVideoContext -Hide
ImagesEditContext -Hide
PrintCMDContext -Hide
IncludeInLibraryContext -Hide
SendToContext -Show
BitLockerContext -Hide
BitmapImageNewContext -Remove
RichTextDocumentNewContext -Remove
CompressedFolderNewContext -Remove
MultipleInvokeContext -Enable
UseStoreOpenWith -Hide
PreviousVersionsPage -Show

#endregion Context menu

Refresh
Errors