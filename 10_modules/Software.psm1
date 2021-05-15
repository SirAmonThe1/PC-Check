function New-MakeDirectoryForce([string]$path) {
    # Thanks to raydric, this function should be used instead of `mkdir -force`.
    #
    # While `mkdir -force` works fine when dealing with regular folders, it behaves
    # strange when using it at registry level. If the target registry key is
    # already present, all values within that key are purged.
    if (!(Test-Path $path)) {
        #Write-Host "-- Creating full path to: " $path -ForegroundColor White -BackgroundColor DarkGreen
        New-Item -ItemType Directory -Force -Path $path
    }
}

function Uninstall-StoreApps {
	$apps = @(
        # default Windows 10 apps
    #"Microsoft.549981C3F5F10" #Cortana
    "Microsoft.3DBuilder"
    "Microsoft.Appconnector"
    "Microsoft.BingFinance"
    "Microsoft.BingNews"
    "Microsoft.BingSports"
    "Microsoft.BingTranslator"
    "Microsoft.BingWeather"
    #"Microsoft.FreshPaint"
    "Microsoft.GamingServices"
    "Microsoft.Microsoft3DViewer"
    "Microsoft.MicrosoftOfficeHub"
    "Microsoft.MicrosoftPowerBIForWindows"
    "Microsoft.MicrosoftSolitaireCollection"
    #"Microsoft.MicrosoftStickyNotes"
    "Microsoft.MinecraftUWP"
    "Microsoft.NetworkSpeedTest"
    "Microsoft.Office.OneNote"
    "Microsoft.People"
    "Microsoft.Print3D"
    "Microsoft.SkypeApp"
    "Microsoft.Wallet"
    #"Microsoft.Windows.Photos"
    "Microsoft.WindowsAlarms"
    #"Microsoft.WindowsCalculator"
    #"Microsoft.WindowsCamera"
    "microsoft.windowscommunicationsapps"
    "Microsoft.WindowsMaps"
    "Microsoft.WindowsPhone"
    "Microsoft.WindowsSoundRecorder"
    #"Microsoft.WindowsStore"   # can't be re-installed
    "Microsoft.Xbox.TCUI"
    "Microsoft.XboxApp"
    "Microsoft.XboxGameOverlay"
    "Microsoft.XboxGamingOverlay"
    "Microsoft.XboxSpeechToTextOverlay"
    "Microsoft.YourPhone"
    "Microsoft.ZuneMusic"
    "Microsoft.ZuneVideo"

    # Threshold 2 apps
    "Microsoft.CommsPhone"
    "Microsoft.ConnectivityStore"
    "Microsoft.GetHelp"
    "Microsoft.Getstarted"
    "Microsoft.Messaging"
    "Microsoft.Office.Sway"
    "Microsoft.OneConnect"
    "Microsoft.WindowsFeedbackHub"

    # Creators Update apps
    "Microsoft.Microsoft3DViewer"
    #"Microsoft.MSPaint"

    #Redstone apps
    "Microsoft.BingFoodAndDrink"
    "Microsoft.BingHealthAndFitness"
    "Microsoft.BingTravel"
    "Microsoft.WindowsReadingList"

    # Redstone 5 apps
    "Microsoft.MixedReality.Portal"
    "Microsoft.ScreenSketch"
    "Microsoft.XboxGamingOverlay"
    "Microsoft.YourPhone"

    # non-Microsoft
    "2FE3CB00.PicsArt-PhotoStudio"
    "46928bounde.EclipseManager"
    "4DF9E0F8.Netflix"
    "613EBCEA.PolarrPhotoEditorAcademicEdition"
    "6Wunderkinder.Wunderlist"
    "7EE7776C.LinkedInforWindows"
    "89006A2E.AutodeskSketchBook"
    "9E2F88E3.Twitter"
    "A278AB0D.DisneyMagicKingdoms"
    "A278AB0D.MarchofEmpires"
    "ActiproSoftwareLLC.562882FEEB491" # next one is for the Code Writer from Actipro Software LLC
    "CAF9E577.Plex"  
    "ClearChannelRadioDigital.iHeartRadio"
    "D52A8D61.FarmVille2CountryEscape"
    "D5EA27B7.Duolingo-LearnLanguagesforFree"
    "DB6EA5DB.CyberLinkMediaSuiteEssentials"
    "DolbyLaboratories.DolbyAccess"
    "DolbyLaboratories.DolbyAccess"
    "Drawboard.DrawboardPDF"
    "Facebook.Facebook"
    "Fitbit.FitbitCoach"
    "Flipboard.Flipboard"
    "GAMELOFTSA.Asphalt8Airborne"
    "KeeperSecurityInc.Keeper"
    "NORDCURRENT.COOKINGFEVER"
    "PandoraMediaInc.29680B314EFC2"
    "Playtika.CaesarsSlotsFreeCasino"
    "ShazamEntertainmentLtd.Shazam"
    "SlingTVLLC.SlingTV"
    "SpotifyAB.SpotifyMusic"
    "TheNewYorkTimes.NYTCrossword"
    "ThumbmunkeysLtd.PhototasticCollage"
    "TuneIn.TuneInRadio"
    "WinZipComputing.WinZipUniversal"
    "XINGAG.XING"
    "flaregamesGmbH.RoyalRevolt2"
    "king.com.*"
    "king.com.BubbleWitch3Saga"
    "king.com.CandyCrushSaga"
    "king.com.CandyCrushSodaSaga"

    # apps which cannot be removed using Remove-AppxPackage
    #"Microsoft.BioEnrollment"
    #"Microsoft.MicrosoftEdge"
    #"Microsoft.Windows.Cortana"
    #"Microsoft.WindowsFeedback"
    #"Microsoft.XboxGameCallableUI"
    #"Microsoft.XboxIdentityProvider"
    #"Windows.ContactSupport"

    # apps which other apps depend on
    "Microsoft.Advertising.Xaml"

    ) 
	
	foreach ($app in $apps) {
    Write-Output "Trying to remove $app"
	
	Get-AppxPackage -ErrorAction SilentlyContinue -Name $app| Remove-AppxPackage -ErrorAction SilentlyContinue
    Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Where-Object DisplayName -like $app | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
    #Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
    #Get-AppXProvisionedPackage -Online | Where-Object DisplayName -EQ $app | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
}

    # Prevents Apps from re-installing
    New-MakeDirectoryForce "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
    Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "FeatureManagementEnabled" 0
    Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "OemPreInstalledAppsEnabled" 0
    Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "PreInstalledAppsEnabled" 0
    Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SilentInstalledAppsEnabled" 0
    Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "ContentDeliveryAllowed" 0
    Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "PreInstalledAppsEverEnabled" 0
    Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContentEnabled" 0
    Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338388Enabled" 0
    Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338389Enabled" 0
    Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-314559Enabled" 0
    Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338387Enabled" 0
    Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338393Enabled" 0
    Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SystemPaneSuggestionsEnabled" 0

    # Prevents "Suggested Applications" returning
    New-MakeDirectoryForce "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
    Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableWindowsConsumerFeatures" 1
}