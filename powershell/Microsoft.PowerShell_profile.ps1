
# (@(& '/home/linuxbrew/.linuxbrew/Cellar/oh-my-posh/23.6.2/bin/oh-my-posh' init pwsh --config='' --print) -join "`n") | Invoke-Expression
$global:POSH_DIR = "$env:HOMEBREW_PREFIX/Cellar/oh-my-posh/23.6.2"
oh-my-posh init pwsh --config "$POSH_DIR/themes/avit.omp.json" | Invoke-Expression

Set-PSReadLineOption -EditMode Emacs -BellStyle Visual -PredictionSource HistoryAndPlugin -PredictionViewStyle ListView
Set-PSReadLineKeyHandler -Chord 'Ctrl+o' MenuComplete
Set-PSReadLineKeyHandler -Chord 'Ctrl+x,Ctrl+o' MenuComplete
Set-PSReadLineKeyHandler -Chord 'Ctrl+x,Ctrl+]' -Function GotoBrace

# Completion for
# See: https://github.com/PowerShell/CompletionPredictor
# Install Install-Module -Name CompletionPredictor -Repository PSGallery
# Settings: Set-PSReadLineOption -PredctionSource HistoryAndPlugin -PredictionViewStyle ListView
Import-Module CompletionPredictor

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

