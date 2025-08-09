-- vim.notify_once('load lua_ls.lua', vim.log.levels.INFO)
return {
    -- on_init = function(client)
    --     local path = client.workspace_folders[1].name
    --     if vim.uv.fs_stat(path..'.luarc.json') then
    --         return
    --     end
    --     client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
    --         workspace = {
    --             library = {
    --                 vim.env.VIMRUNTIME .. '/lua',
    --                 vim.fn.stdpath('config') .. '/lua',
    --                 mini_path .. '/lua',
    --                 path_package .. '/pack/deps/opt/nvim-cmp/lua',
    --             }
    --         }
    --     })
    -- end,
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT', pathStrict = true, path = { '?.lua', '?/init.lua' }, },
            workspace = {
                checkThirdParty = false,
                ignoreDir = { '/locale/', '/libs/', '/3rd', '.vscode', '/meta', '_plugins' },
                library = {
                    vim.env.VIMRUNTIME .. '/lua',
                    vim.fn.stdpath('config') .. '/lua',
                }
            },
            diagnostics = {
                disable = { 'missing-fields', 'incomplete-signature-doc' },
                unusedLocaleExclude = { '_*' }
            },
        }
    }
}
