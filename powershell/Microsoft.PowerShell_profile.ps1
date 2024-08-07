
function Prompt() {
    $dir = [System.IO.DirectoryInfo]$PWD.Path
    return "PS{0} {1}> " -f $PSVersionTable.PSVersion.Major, $dir.Name
}

Set-PSReadLineOption -EditMode Emacs -BellStyle Visual -PredictionSource HistoryAndPlugin -PredictionViewStyle ListView
Set-PSReadLineKeyHandler -Chord 'Ctrl+o' MenuComplete
Set-PSReadLineKeyHandler -Chord 'Ctrl+x,Ctrl+o' MenuComplete
Set-PSReadLineKeyHandler -Chord 'Ctrl+x,Ctrl+]' -Function GotoBrace

# Completion for
# See: https://github.com/PowerShell/CompletionPredictor
# Install Install-Module -Name CompletionPredictor -Repository PSGallery
# Settings: Set-PSReadLineOption -PredctionSource HistoryAndPlugin -PredictionViewStyle ListView
Import-Module CompletionPredictor
