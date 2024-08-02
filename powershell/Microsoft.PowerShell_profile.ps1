
<#
function prompt {
    return 'PS1 > '
}
#>

Set-PSReadLineKeyHandler -Chord Ctrl+@ MenuComplete
Set-PSReadLineKeyHandler -Chord Ctrl+o MenuComplete

