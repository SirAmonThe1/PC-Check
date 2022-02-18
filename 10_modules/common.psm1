#clear                      #Debugging

#Version
#2022-02-18


$tempDir = "./.tmp"



function show-Trenner {
    
    ""
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "############################################################"
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "############################################################"
    ""

}

function show-TrennerKlein {
    
    ""
    Write-Host -BackgroundColor Black -ForegroundColor Cyan "##############################"
    ""

}


function show-TrennerHeader1($text) {

    ""
	Write-Host -BackgroundColor Green -ForegroundColor White "********"
	Write-Host -BackgroundColor Green -ForegroundColor White "********"
	Write-Host -BackgroundColor Green -ForegroundColor White "********"
	Write-Host -BackgroundColor Green -ForegroundColor White "##############################"
    Write-Host -BackgroundColor Green -ForegroundColor White "# ----- " $text
    Write-Host -BackgroundColor Green -ForegroundColor White "##############################"
	Write-Host -BackgroundColor Green -ForegroundColor White "********"
	Write-Host -BackgroundColor Green -ForegroundColor White "********"
	Write-Host -BackgroundColor Green -ForegroundColor White "********"
	""

}


function show-TrennerHeader2($text) {

    ""
    Write-Host -BackgroundColor Black -ForegroundColor Cyan "****"
    Write-Host -BackgroundColor Black -ForegroundColor Cyan "#####################"
    Write-Host -BackgroundColor Black -ForegroundColor Cyan "# ----- " $text
    Write-Host -BackgroundColor Black -ForegroundColor Cyan "#####################"
    Write-Host -BackgroundColor Black -ForegroundColor Cyan "****"
    ""

}


function show-TrennerInfo($text) {

    ""
    Write-Host -BackgroundColor Black -ForegroundColor White "--- " $text
    ""

}


function show-Output($text) {

    Write-Host -BackgroundColor Black -ForegroundColor yellow ">>> " $text

}

function show-OutputAlert($text) {

    Write-Host -BackgroundColor Black -ForegroundColor Red "          !!! " $text

}

function show-TrennerFertig {

    ""
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "****"
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "#####################"
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "# "
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "# ----- Fertig"
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "# "
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "#####################"
	Write-Host -BackgroundColor Black -ForegroundColor Cyan "****"
	""

}































function Reset-PathEnvironment() {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 
}

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

function Get-TemporaryDownload([string]$uri) {
    $tmpFile = New-TemporaryFile
    Invoke-WebRequest -Uri $uri -OutFile $tmpFile.FullName

    return $tmpFile.FullName
}

function New-TempDirectory {
    if (!(Test-Path -Path $tempDir)) {
        New-Item -ItemType Directory -Force -Path $tempDir
    }
}

function Remove-TempDirectory {
    if (Test-Path -Path $tempDir) {
        Remove-Item $tempDir -Recurse -Force
    }
}

function Get-DownloadFile([string]$output, [string]$uri) {
    if (Test-Path -Path $output) {
        Remove-Item $output -Force
    }

    New-MakeDirectoryForce ($output | Split-Path)
    Invoke-WebRequest -Uri $uri -OutFile $output
}

function Get-DownloadTemporaryFile([string]$outFile, [string]$uri, [ScriptBlock]$action) {
    New-TempDirectory

    if (Test-Path -Path $outFile) {
        Remove-Item $outFile -Force
    }

    Push-Location $tempDir
    Invoke-WebRequest -Uri $uri -OutFile $outFile
    $action.Invoke()
    Remove-Item $outFile -Force
    Pop-Location
}

function Invoke-TemporaryZipDownload([string]$name, [string]$uri, [ScriptBlock]$action) {
    $outFile = Join-Path $tempDir ($name + ".zip")
    $outDir = Join-Path $tempDir $name

    New-TempDirectory

    if (Test-Path -Path $outDir) {
        Remove-Item $outDir -Recurse -Force
    }

    Invoke-WebRequest -Uri $uri -OutFile $outFile
    Expand-Archive $outFile -DestinationPath $outDir -Force

    Push-Location $outDir
    $action.Invoke()
    Pop-Location

    Remove-Item -Path $outFile
    Remove-Item -Path $outDir -Recurse -Force
}

function Invoke-TemporaryGitDownload([string]$name, [string]$uri, [ScriptBlock]$action) {
    $outDir = Join-Path $tempDir $name

    New-TempDirectory
    if (Test-Path -Path $outDir) {
        Remove-Item $outDir -Recurse -Force
    }

    & git clone $uri $outDir

    Push-Location $outDir
    $action.Invoke()
    Remove-Item ".git" -Recurse -Force
    Pop-Location
}

function Install-UserProfile {
    Get-ChildItem -Path "./home" |
        Select-Object -ExpandProperty Name |
        ForEach-Object { Copy-Item -Path "./home/$_" -Destination "~/" }
}
