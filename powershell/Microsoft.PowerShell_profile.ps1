
# Prompt
# brew install oh-my-posh
# (@(& '/home/linuxbrew/.linuxbrew/Cellar/oh-my-posh/23.6.2/bin/oh-my-posh' init pwsh --config='' --print) -join "`n") | Invoke-Expression
if ($IsWindows) {
    $global:POSH_DIR = "D:\Program\oh-my-posh"
    $posh = "${global:POSH_DIR}\bin\oh-my-posh.exe"
    $env:POSH_THEMES_PATH = "$POSH_DIR\themes"
} elseif ($IsLinux) {
    $global:POSH_DIR = (Get-ChildItem "$env:HOMEBREW_PREFIX/Cellar/oh-my-posh" | Select-Object -First 1).FullName
    $posh = "${global:POSH_DIR}/bin/oh-my-posh"
    $env:POSH_THEMES_PATH = "$POSH_DIR/themes"
}
function Reset-Prompt {
    $function:Prompt = {
        $private:lastExitStatus = $?
        $sep = [System.IO.Path]::DirectorySeparatorChar
        $location = $executionContext.SessionState.Path.CurrentLocation.Path -replace "^$env:HOME(?=[$sep]?)",'~'
        $paths = $location.Split($sep)
        if ($paths.Length -gt 4) {
            $location = "$($paths[0,1] -join $sep)$sep...$sep$($paths[-2,-1] -join $sep)"
        }
        return 'PS ' +
               $PSStyle.Foreground.Cyan + $location + $PSStyle.Reset +
               $(if ($private:lastExitStatus) { $PSStyle.Foreground.Green } else { $PSStyle.Foreground.Red }) +
               ('>' * ($NestedPromptLevel + 1)) + $PSStyle.Reset +
               ' '
    }
}
function Set-PoshTheme {
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({
            param($cmdName, $paramName, [string] $word, $cmdAst, $fakeParams)
            Get-ChildItem -Path $env:POSH_THEMES_PATH -File -Filter "*.omp.json" |
                ForEach-Object { $name = $_.BaseName -replace "\.omp"; if ($name.StartsWith($word)) { $name } }
        })]
        [string] $Name
    )
    $env:POSH_THEME_NAME = $Name
    $themeFile = Join-Path $env:POSH_THEMES_PATH ("{0}.omp.json" -F $Name)
    & $posh init pwsh --config "$themeFile" | Invoke-Expression
}
Set-PoshTheme -Name spaceship

Set-PSReadLineOption -EditMode Emacs -BellStyle Visual -PredictionSource HistoryAndPlugin -PredictionViewStyle ListView
Set-PSReadLineKeyHandler -Chord 'Ctrl+o' MenuComplete
Set-PSReadLineKeyHandler -Chord 'Ctrl+x,Ctrl+o' MenuComplete
Set-PSReadLineKeyHandler -Chord 'Ctrl+x,Ctrl+]' -Function GotoBrace

## don't exit
Set-PSReadLineKeyhandler -Chord Ctrl+d -Function DeleteChar
## swap Ctrl+w , Alt+Backspace
Set-PsReadLineKeyhandler -Chord Ctrl+w -Function BackwardDeleteWord
Set-PsReadLineKeyhandler -Chord Alt+Backspace -Function UnixWordRubout

# Completion for
# See: https://github.com/PowerShell/CompletionPredictor
# Install Install-Module -Name CompletionPredictor -Repository PSGallery
# Settings: Set-PSReadLineOption -PredctionSource HistoryAndPlugin -PredictionViewStyle ListView
Import-Module CompletionPredictor

# Native(OS) Command Completer
# https://github.com/teramako/NativeCommandCompleter.psm
Import-Module NativeCommandCompleter.psm
Import-Module NativeCommandCompleter.completions

Set-PSReadLineOption -Colors @{
    Selection = $PSStyle.Reverse;
}

if (Test-Path -Path $PSScriptRoot/primary.formats.ps1xml) {
    Update-FormatData -PrependPath $PSScriptRoot/primary.formats.ps1xml
}
