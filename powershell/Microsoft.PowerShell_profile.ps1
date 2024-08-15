
# Prompt
# brew install oh-my-posh
# (@(& '/home/linuxbrew/.linuxbrew/Cellar/oh-my-posh/23.6.2/bin/oh-my-posh' init pwsh --config='' --print) -join "`n") | Invoke-Expression
if ($IsWindows) {
    $global:POSH_DIR = "D:\Program\oh-my-posh"
    $posh = "${global:POSH_DIR}\bin\oh-my-posh.exe"
} elseif ($IsLinux) {
    $global:POSH_DIR = "$env:HOMEBREW_PREFIX/Cellar/oh-my-posh/23.6.2"
    $posh = "${global:POSH_DIR}/bin/oh-my-posh"
}
& $posh init pwsh --config "$POSH_DIR/themes/aliens.omp.json" | Invoke-Expression

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

## winget completion
if ($IsWindows) {
    Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
        param($wordToComplete, $commandAst, $cursorPosition)
        [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
        $Local:word = $wordToComplete.Replace('"', '""')
        $Local:ast = $commandAst.ToString().Replace('"', '""')
        winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
    }
}

## dotnet completion
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
    dotnet complete --position $cursorPosition "$commandAst" | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

# git completion
# Install-Module -Name posh-git -Repository PSGallery
Import-Module posh-git

