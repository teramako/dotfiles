<#
.SYNOPSIS
    Regsiter `git` command completer with `posh-git`
.DESCRIPTION
    This script will be loaded by `NativeCommandCompleter.psm` poershell module.
.LINK
    dahlbyk/posh-git: A PowerShell environment for Git
    https://github.com/dahlbyk/posh-git
#>
param($wordToComplete, $commandAst, $cursorPosition)
Import-Module posh-git

# Reset the variable in the global scope
$global:GitPromptScriptBlock = $GitPromptScriptBlock

# The first time, generate the completion list manually
TabExpansion2 -inputScript $commandAst.ToString().PadRight($cursorPosition) `
              -cursorColumn $cursorPosition `
    | Select-Object -ExpandProperty CompletionMatches
