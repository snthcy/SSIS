<#
   _     _      _     _      _     _      _     _   
  (c).-.(c)    (c).-.(c)    (c).-.(c)    (c).-.(c)  
   / ._. \      / ._. \      / ._. \      / ._. \   
 __\( Y )/__  __\( Y )/__  __\( Y )/__  __\( Y )/__ 
(_.-/'-'\-._)(_.-/'-'\-._)(_.-/'-'\-._)(_.-/'-'\-._)
   || S ||      || S ||      || I ||      || S ||   
 _.' `-' '._  _.' `-' '._  _.' `-' '._  _.' `-' '._ 
(.-./`-`\.-.)(.-./`-`\.-.)(.-./`-'\.-.)(.-./`-`\.-.)
 `-'     `-'  `-'     `-'  `-'     `-'  `-'     `-' 
SSIS - SYNTHI'S STUPID SETUP SCRIPT (c) 202222222222
BLAH BLAH BLAH LICENSE IS GPL3 OR SOMETHING I DON'T KNOW
#>

$essentials = @{
    'git'  = ('main/git')
    'aria' = ('main/aria2')
    '7z'   = ('main/7zip')
}

$buckets = @{
    # dev
    'extras'  = ('')
    'games'   = ('')
    'spotify' = ('https://github.com/TheRandomLabs/Scoop-Spotify.git')
    'utils'   = ('https://github.com/couleur-tweak-tips/utils.git')
}

$packages = @{
    # dev
    #'go'             = ('main/go')
    #'node'           = ('main/nodejs')
    #'python'         = ('main/python')
    #'rust'           = ('main/rust')

    # utils
    'everything' = ('extras/everything')
    'ffmpeg'     = ('main/ffmpeg')
    'helix'      = ('main/helix')
    'mpv'        = ('extras/mpv')
    'notepad++'  = ('extras/notepadplusplus')
    'paint.net'  = ('extras/paint.net')
    'rufus'      = ('extras/rufus')
    'terminal'   = ('windows-terminal')
    'winscp'     = ('extras/winscp')
    #'wiztree'        = ('extras/wiztree')
    #'yt-dlp'         = ('main/yt-dlp')

    # socials
    #'telegram'       = ('extras/telegram')
    
    # games
    #'moony'          = ('utils/moony')
    #'rbxfpsunlocker' = ('games/rbxfpsunlocker')
}

$1 = $($args[0])
$2 = $($args[1])
$3 = $($args[2])
$4 = $($args[3])
$5 = $($args[4])
$6 = $($args[5])
$7 = $($args[6])
$8 = $($args[8])
$9 = $($args[9])

$source = "https://github.com/snthcy/ssis/raw/main/ssis.ps1"
$destination = "$WindowsAppsDir\ssis.ps1"

# setup ssis
if ($PSScriptRoot -eq '') {

    Remove-Item "$WindowsAppsDir\ssis.ps1"-Force -ErrorAction SilentlyContinue
    Remove-Item "$WindowsAppsDir\ssis.bat"-Force -ErrorAction SilentlyContinue
    Remove-Item "$WindowsAppsDir\ssis.lnk"-Force -ErrorAction SilentlyContinue

    curl $source -outFile $destination

    "title ssis.bat
powershell Set-ExecutionPolicy Unrestricted -Scope Process -Force;%localappdata%\Microsoft\WindowsApps\CustomizableLauncher.ps1 %1 %2 %3 %4 %5 %6 %7 %8 %9
exit" | Set-Content $WindowsAppsDir\ssis.bat

    Start-Process ssis.bat
    exit
}


# menu
function Menu {
    Clear-Host
    $host.UI.RawUI.WindowTitle = "Synthi's Stupid Install Script (SSIS)"
    if ($args -in '', $null, '-verbose') {

        Write-Host @"
   _     _      _     _      _     _      _     _   
  (c).-.(c)    (c).-.(c)    (c).-.(c)    (c).-.(c)  
   / ._. \      / ._. \      / ._. \      / ._. \   
 __\( Y )/__  __\( Y )/__  __\( Y )/__  __\( Y )/__ 
(_.-/'-'\-._)(_.-/'-'\-._)(_.-/'-'\-._)(_.-/'-'\-._)
   || S ||      || S ||      || I ||      || S ||   
 _.' `-' '._  _.' `-' '._  _.' `-' '._  _.' `-' '._ 
(.-./`-`\.-.)(.-./`-`\.-.)(.-./`-'\.-.)(.-./`-`\.-.)
`-'     `-'  `-'     `-'  `-'     `-'  `-'     `-' 
        WELCOME TO SYNTHI'S STUPID SETUP SCRIPT
            SELECT AN OPTION TO CONTINUE...
"@
        Write-Host @"
[ssis ps]  Install PowerShell 7
[ssis si]  Install and Configure Scoop
[ssis sg]  Get Scoop Packages
"@
    }
}


# go to menu if no args
if ($args -in '', $null, '-verbose') { Menu }
    
# if args match key, run function
if ($1 -eq "ps") {
    Write-Host "Downloading Powershell..." -ForegroundColor Yellow
    Powershell
}

if ($1 -eq "si") {
    Write-Host "Downloading Scoop..." -ForegroundColor Yellow
    DownloadScoop
}

if ($1 -eq "sg") {
    Write-Host "Downloading Scoop Packages..." -ForegroundColor Yellow
    ScoopPackages
}


# install powershell
function Powershell {
    $host.UI.RawUI.WindowTitle = "SSIS - Updating to Powershell 7"
    Invoke-Expression "& { $(Invoke-RestMethod 'https://aka.ms/install-powershell.ps1') } -daily"
    Menu
}

# install scoop
function DownloadScoop {
    if (-Not(Get-Command scoop -Ea Ignore)) {

        $host.UI.RawUI.WindowTitle = "SSIS - Setup Scoop"

        $SelectedPath = Read-Host -Prompt "Path of Scoop install: (excluding scoop)"

        $env:SCOOP = Join-Path $SelectedPath Scoop
        [Environment]::SetEnvironmentVariable('SCOOP', $env:SCOOP, 'User')

        Set-ExecutionPolicy Bypass -Scope Process -Force

        Invoke-Expression "& {$(Invoke-RestMethod get.scoop.sh)} -RunAsAdmin"

        ForEach ($pkg in ($essentials.keys)) {

            $name = $($pkg -split '/' | Select-Object -Last 1)
            $manifestname = $essentials.$pkg
            $Host.UI.RawUI.WindowTitle = "SSIS - Downloading [$count/$($totalCount)] ~ $name"
            Write-Host "Installing $name" -ForegroundColor Green
            scoop install $manifestname
            $count++
        }

        # add buckets
        ForEach ($bucket in $buckets.keys) {
            $Host.UI.RawUI.WindowTitle = "SSIS - Adding $bucket"
            Write-Host "Adding $bucket ~ $($buckets.$bucket)" -ForegroundColor Green
            scoop bucket add $bucket $($buckets.$bucket) 
        }

        # update repository
        Write-Host "Updating Manifest..." -ForegroundColor DarkGreen
        scoop update
    }
    Menu
}

# install scoop packages
function ScoopPackages {
    if (Get-Command scoop -Ea Ignore) {
        $host.UI.RawUI.WindowTitle = "SSIS - Installing Scoop Packages"

        $count
        $totalCount = $essentials.Count + $packages.count

        # install packages
        ForEach ($pkg in ($packages.keys)) {

            $name = $($pkg -split '/' | Select-Object -Last 1)
            $manifestname = $packages.$pkg
            $Host.UI.RawUI.WindowTitle = "SSIS - Downloading [$count/$($totalCount)] ~ $name"
            Write-Host "Installing $name" -ForegroundColor Green
            scoop install $manifestname
            $count++
        }
    }
    Menu
}