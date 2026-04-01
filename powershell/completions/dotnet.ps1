<#
.SYNOPSIS
    Regsiter `dotnet` command completer
.DESCRIPTION
    This script will be loaded by `NativeCommandCompleter.psm` poershell module.
.LINK
    How to enable tab completion for the .NET CLI
    https://learn.microsoft.com/en-us/dotnet/core/tools/enable-tab-autocomplete
#>
param($wordToComplete, $commandAst, $cursorPosition)

Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
    dotnet complete --position $cursorPosition $commandAst.ToString() | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}
# The first time, generate the completion list manually
TabExpansion2 -inputScript $commandAst.ToString().PadRight($cursorPosition) `
              -cursorColumn $cursorPosition `
    | Select-Object -ExpandProperty CompletionMatches

