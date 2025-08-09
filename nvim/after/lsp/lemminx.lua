-- XML 系のLSP
--  * https://github.com/eclipse/lemminx
--  * https://github.com/redhat-developer/vscode-xml/blob/main/docs/Preferences.md
return {
    filetypes = { 'xml', 'xsd', 'xsl', 'xslt', 'svg', 'ps1xml' },
    settings = {
        xml = {
            server = {
                workDir = '~/.cache/lemminx',
            },
            fileAssociations = {
                {
                    pattern = '**/*formats.ps1xml',
                    systemId = 'https://raw.githubusercontent.com/PowerShell/PowerShell/master/src/Schemas/Format.xsd'
                },
                {
                    pattern = '**/*types.ps1xml',
                    systemId = 'https://raw.githubusercontent.com/PowerShell/PowerShell/master/src/Schemas/Types.xsd'
                },
                {
                    pattern = '**/*-Help.xml',
                    -- systemId = 'https://raw.githubusercontent.com/PowerShell/PowerShell/refs/heads/master/src/Schemas/PSMaml/Maml.xsd'
                    systemId = vim.fn.stdpath("config") .. '/../xsd/PSMaml.xsd'
                }
            },
            format = {
                enabled = true,
                spaceBeforeEmptyCloseTag = true,
            },
        }
    }
}
