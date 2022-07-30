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

$host.UI.RawUI.WindowTitle = "Synthi's Stupid Install Script (SSIS)"

Start-Sleep -Seconds 3



$host.UI.RawUI.WindowTitle = "SSIS - Updating to Powershell 7"
#Invoke-RestMethod "https://raw.githubusercontent.com/PowerShell/PowerShell/master/tools/install-powershell.ps1" | Invoke-Expression

if (-Not(Get-Command scoop -Ea Ignore)) {

    $host.UI.RawUI.WindowTitle = "SSIS - Configuring Scoop"

    $SelectedPath = Read-Host -Prompt "Path of Scoop install: (excluding scoop)"

    $env:SCOOP = Join-Path $SelectedPath Scoop
    [Environment]::SetEnvironmentVariable('SCOOP', $env:SCOOP, 'User')

    Set-ExecutionPolicy Bypass -Scope Process -Force

    Invoke-Expression "& {$(Invoke-RestMethod get.scoop.sh)} -RunAsAdmin" 
}

$essentials = @{
    'aria' = ('main/aria2')
    'git'  = ('main/git')
    '7z'   = ('main/7zip')
}

$buckets = @{
    # dev
    'spotify' = ('https://github.com/TheRandomLabs/Scoop-Spotify.git')
    'utils'   = ('https://github.com/couleur-tweak-tips/utils.git')
    'extras'  = ('')
}

$packages = @{
    # dev
    #'node'       = ('main/nodejs')
    #'python'     = ('main/python')
    #'go'         = ('main/go')
    #'rust'       = ('main/rust')

    # utils
    'terminal'   = ('windows-terminal')
    'everything' = ('extras/everything')
    'mpv'        = ('extras/mpv')
    'notepad++'  = ('extras/notepadplusplus')
    'helix'      = ('main/helix')
    'winscp'     = ('extras/winscp')
    'wiztree'    = ('extras/wiztree')
    'rufus'      = ('extras/rufus')
    'yt-dlp'     = ('main/yt-dlp')
    'paint.net'  = ('extras/paint.net')

    # games
    'moony'      = ('utils/moony')
}

if (Get-Command scoop -Ea Ignore) {
    $host.UI.RawUI.WindowTitle = "SSIS - Installing Scoop Packages"

    $count
    $totalCount = $essentials.Count + $packages.count

    # install essentials
    ForEach ($pkg in ($essentials.keys)) {

        $name = $($pkg -split '/' | Select-Object -Last 1)
        $manifestname = $essentials.$pkg
        $Host.UI.RawUI.WindowTitle = "SSIS - Downloading [$count/$($totalCount)] ~ $name"
        Write-Warning "Installing $name"
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
    Write-Warning "Updating Manifest..."
    scoop update

    # install packages
    ForEach ($pkg in ($packages.keys)) {

        $name = $($pkg -split '/' | Select-Object -Last 1)
        $manifestname = $packages.$pkg
        $Host.UI.RawUI.WindowTitle = "SSIS - Downloading [$count/$($totalCount)] ~ $name"
        Write-Warning "Installing $name"
        scoop install $manifestname
        $count++
    }
}
