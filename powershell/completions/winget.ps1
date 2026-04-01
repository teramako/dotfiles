<#
.SYNOPSIS
    Regsiter `winget` command completer
.DESCRIPTION
    This script will be loaded by `NativeCommandCompleter.psm` poershell module.
.LINK
    Enabling tab completion with the winget tool | Microsoft Learn
    https://learn.microsoft.com/en-us/windows/package-manager/winget/tab-completion
#>
param($wordToComplete, $commandAst, $cursorPosition)

if (-not $IsWindows) {
    return $null
}

Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
    [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
    $Local:word = $wordToComplete.Replace('"', '""')
    $Local:ast = $commandAst.ToString().Replace('"', '""')
    winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

# The first time, generate the completion list manually
TabExpansion2 -inputScript $commandAst.ToString().PadRight($cursorPosition) `
              -cursorColumn $cursorPosition `
    | Select-Object -ExpandProperty CompletionMatches

