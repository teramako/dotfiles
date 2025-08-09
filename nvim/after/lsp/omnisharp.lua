return {
    -- cmd = { "/usr/bin/dotnet", vim.fn.stdpath("data") .. "/mason/packages/omnisharp/libexec/OmniSharp.dll" },
    -- cmd = { "/home/linuxbrew/.linuxbrew/bin/dotnet", vim.fn.stdpath("data") .. "/mason/packages/omnisharp/libexec/OmniSharp.dll" },
    cmd = {
        "OmniSharp", "-z", "--hostPID", tostring(vim.fn.getpid()), "DotNet:enablePackageRestore=false", "--encoding", "utf-8", "--languageserver", "--locale", "ja-JP"
    },
    -- Command Options:
    --   -?|-h|--help             Show help information.
    --   -s|--source              Solution or directory for OmniSharp to point at (defaults to current directory).
    --   -l|--loglevel            Level of logging (defaults to 'Information').
    --   -v|--verbose             Explicitly set 'Debug' log level.
    --   -hpid|--hostPID          Host process ID.
    --   -z|--zero-based-indices  Use zero based indices in request/responses (defaults to 'false').
    --   -pl|--plugin             Plugin name(s).
    --   -d|--debug               Wait for debugger to attach
    --   --locale                 Locale to use for localization (defaults to system locale).
    --   -lsp|--languageserver    Use Language Server Protocol.
    --   -e|--encoding            Input / output encoding for STDIO protocol.

    settings = {
        FormattingOptions = {
            -- Enables support for reading code style, naming convention and analyzer
            -- settings from .editorconfig.
            EnableEditorConfigSupport = true,
            -- Specifies whether 'using' directives should be grouped and sorted during
            -- document formatting.
            OrganizeImports = nil,
        },
        MsBuild = {
            -- If true, MSBuild project system will only load projects for files that
            -- were opened in the editor. This setting is useful for big C# codebases
            -- and allows for faster initialization of code navigation features only
            -- for projects that are relevant to code that is being edited. With this
            -- setting enabled OmniSharp may load fewer projects and may thus display
            -- incomplete reference lists for symbols.
            LoadProjectsOnDemand = nil,
        },
        RoslynExtensionsOptions = {
            -- Enables support for roslyn analyzers, code fixes and rulesets.
            EnableAnalyzersSupport = true,
            -- Enables support for showing unimported types and unimported extension
            -- methods in completion lists. When committed, the appropriate using
            -- directive will be added at the top of the current file. This option can
            -- have a negative impact on initial completion responsiveness,
            -- particularly for the first few completion sessions after opening a
            -- solution.
            EnableImportCompletion = nil,
            -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
            -- true
            AnalyzeOpenDocumentsOnly = true,
        },
        Sdk = {
            -- Specifies whether to include preview versions of the .NET SDK when
            -- determining which version to use for project loading.
            IncludePrereleases = false,
        },
    },
    filetypes = { 'cs' },
    -- root_dir = require('lspconfig.util').root_pattern('*.sln', '*.csproj', 'omnisharp.json'),
}
