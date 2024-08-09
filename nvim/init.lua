local vim = vim
local opt = vim.opt

-- Deny to load default plugins {{{
vim.g.loaded_tar             = 1
vim.g.loaded_tarPlugin       = 1
vim.g.loaded_zip             = 1
vim.g.loaded_zipPlugin       = 1
vim.g.loaded_vimball         = 1
vim.g.loaded_vimballPlugin   = 1
vim.g.loaded_getscript       = 1
vim.g.loaded_getscriptPlugin = 1
-- }}}

-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps' {{{
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    '--branch', 'stable',
    'https://github.com/echasnovski/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end
-- }}}

-- Set up 'mini.deps' (customize to your liking)
require('mini.deps').setup({ path = { package = path_package } })

-- Define helpers
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
add({ name = 'mini.nvim', checkout = 'HEAD' })

-- Basic Options {{{
opt.number = true
opt.tabstop = 4
opt.shiftwidth = 0
opt.expandtab = true
opt.backup = false
opt.swapfile = false
opt.visualbell = true

opt.listchars = 'tab:>-,trail:-,nbsp:+,eol:$'
opt.cmdheight = 2
opt.laststatus = 2
opt.autoindent = true

opt.splitbelow = true -- 下に開く (縦分割)
opt.splitright = true -- 右に開く (横分割)

opt.grepformat = '%f:%l:%c:%m'
opt.grepprg    = 'git grep --no-index --exclude-standard --no-color -n --column -I -P'

-- Clipbload
vim.keymap.set({'n', 'v'}, 'gy', '"+y', { noremap = true }) -- クリップボードへコピー
vim.keymap.set({'n', 'v'}, 'gp', '"+p', { noremap = true }) -- クリップボードからペースト

-- Tab
vim.keymap.set('n', '<C-l>', 'gt', { noremap = true })
vim.keymap.set('n', '<C-h>', 'gT', { noremap = true })

-- Buffer
vim.keymap.set('n', ']b', function()
    return '<cmd>' .. vim.v.count .. 'bnext<CR>'
end, { expr = true, desc = '次のバッファーへ' })
vim.keymap.set('n', '[b', function()
    return '<cmd>' .. vim.v.count .. 'bprevious<CR>'
end, { expr = true, desc = '前のバッファーへ' })
vim.keymap.set('n', 'gb', function()
    local c = vim.v.count; return c ~= 0 and '<cmd>b ' .. c .. '<CR>' or '<cmd>bnext<CR>'
end, { expr = true, desc = '{count}のバッファー番号へ、もしくは、次のバッファーへ' })
vim.keymap.set('n', 'gB', function()
    local c = vim.v.count; return c ~= 0 and '<cmd>b ' .. c .. '<CR>' or '<cmd>bprevious<CR>'
end, { expr = true, desc = '{count}のバッファー番号へ、もしくは、前のバッファーへ' })

-- Cmdline
vim.keymap.set('c', '<C-a>', '<Home>', { noremap = true })
vim.keymap.set('c', '<C-f>', '<Right>', { noremap = true })
vim.keymap.set('c', '<C-b>', '<Left>', { noremap = true })
vim.keymap.set('c', '<Esc>b', '<S-Left>', { noremap = true })
vim.keymap.set('c', '<Esc>f', '<S-Right>', { noremap = true })
vim.keymap.set('c', '<C-y>', function() vim.fn.setreg('', vim.fn.getcmdline()) end) -- コマンドラインをやんく

vim.keymap.set('n', '<C-w>gf', 'gf', { noremap = true })
vim.keymap.set('n', '<C-w>gF', 'gF', { noremap = true })
vim.keymap.set('n', 'gf', '<C-w>gf', { noremap = true })
vim.keymap.set('n', 'gF', '<C-w>gF', { noremap = true })
vim.keymap.set('n', 'q:', ':q', { noremap = true })

-- init.lua をな、いつでも編集できるようになりなよ
vim.keymap.set('n', '<C-\\><C-\\>',  '<cmd>tabe $MYVIMRC<CR>')
-- }}}

now(function() vim.cmd('colorscheme minicyan') end)

-- Statusline, Tabline, Winbar {{{
add({
    -- see: https://github.com/nvim-lualine/lualine.nvim
    source = 'nvim-lualine/lualine.nvim',
    -- アイコン要らない
    -- depends = {
    --     'nvim-tree/nvim-web-devicons'
    -- }
})
now(function()
    require('lualine').setup({
        options = {
            icons_enabled = false,
            theme = 'dracula',
            section_separators = { left = '', right = '' },
            component_separators = { left = '', right = '' },
        },
        sections = {
            lualine_a = {'mode'},
            lualine_b = {'branch', 'diff', 'diagnostics'},
            lualine_c = { { 'filename', path = 1 } },
            lualine_x = { { 'encoding', show_bomb = true }, 'fileformat', 'filetype'},
            lualine_y = {'progress'},
            lualine_z = {'location'}
        },
        tabline = {
            lualine_a = {
                { 'tabs', show_modified_status = false }
            },
            lualine_b = {
                { 'filename', file_status = false }
            },
            lualine_c = {
                {
                    'buffers',
                    mode = 4,
                    use_mode_colors = false,
                    filetype_names = {
                        TelescopePrompt = '🔎 Telescope',
                        ['gin-status'] = ' GitStatus',
                        ['gin-log'] = ' GitLog',
                    },
                }
            },
            lualine_x = {},
            lualine_y = {},
            lualine_z = {},
        },
        winbar = {
            -- lualine_a = {'windows'},
            -- lualine_b = {},
            -- lualine_c = {},
            -- lualine_x = {},
            -- lualine_y = {},
            -- lualine_z = {}
        }
    })
    vim.api.nvim_set_hl(0, 'lualine_c_buffers_active', { ctermfg=255, ctermbg=238, underline = true })
end)
-- }}}

-- Telescope {{{
add({
    -- see: https://github.com/nvim-telescope/telescope.nvim
    source = 'nvim-telescope/telescope.nvim',
    depends = {
        'nvim-lua/plenary.nvim'
    },
})
later(function()
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', ',ff', builtin.find_files, {})
    vim.keymap.set('n', ',fg', builtin.live_grep, {})
    vim.keymap.set('n', ',fb', builtin.buffers, {})
    vim.keymap.set('n', ',fh', builtin.help_tags, {})
end)
-- }}}

-- LSP {{{
add({
    source = 'neovim/nvim-lspconfig',
    depends = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim'
    },
})

vim.api.nvim_create_autocmd("LspAttach", {
    desc = "Attach key mappings for LSP functionalities",
    callback = function()
        vim.keymap.set('n', 'K',  '<cmd>:lua vim.lsp.buf.hover()<CR>') -- カーソル下のドキュメント等を表示
        -- vim.keymap.set('n', 'gf', '<cmd>:lua vim.lsp.buf.formatting()<CR>')
        vim.keymap.set('n', 'gr', '<cmd>:lua vim.lsp.buf.references()<CR>') -- カーソル下の symbol の参照箇所の一覧表示(QuickFix), ジャンプ
        vim.keymap.set('n', 'gd', '<cmd>:lua vim.lsp.buf.definition()<CR>') -- カーソル下の symbol の定義箇所へジャンプ
        vim.keymap.set('n', 'gD', '<cmd>:lua vim.lsp.buf.declaration()<CR>')
        vim.keymap.set('n', 'gi', '<cmd>:lua vim.lsp.buf.implementation()<CR>')
        vim.keymap.set('n', 'gt', '<cmd>:lua vim.lsp.buf.type_definition()<CR>')
        vim.keymap.set('n', 'gn', '<cmd>:lua vim.lsp.buf.rename()<CR>') -- symbol の一括リネーム
        vim.keymap.set('n', '<F2>', '<cmd>:lua vim.lsp.buf.rename()<CR>') -- 同上
        vim.keymap.set('n', 'ga', '<cmd>:lua vim.lsp.buf.code_action()<CR>')
        vim.keymap.set('n', 'ge', '<cmd>:lua vim.diagnostic.open_float()<CR>') -- 警告・エラーメッセージの表示
        vim.keymap.set('n', 'g]', '<cmd>:lua vim.diagnostic.goto_next()<CR>')
        vim.keymap.set('n', 'g[', '<cmd>:lua vim.diagnostic.goto_prev()<CR>')

        vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false }
        )
    end
})


now(function()
    require("mason").setup()
    local mason_lspconfig = require("mason-lspconfig")
    mason_lspconfig.setup({
        ensure_installed = {
            'lua_ls'
        }
    })
    local lspconfig = require('lspconfig')
    mason_lspconfig.setup_handlers({
        function(server_name)
            lspconfig[server_name].setup({})
        end,
        ['lua_ls'] = function()
            -- see: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls
            require('lspconfig').lua_ls.setup({
                on_init = function(client)
                    local path = client.workspace_folders[1].name
                    if vim.loop.fs_stat(path..'.luarc.json') or vim.loop.fs_stat(path..'.luarc.json') then
                        return
                    end
                    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                        runtime = { version = 'LuaJIT' },
                        workspace = {
                            checkThirdParty = false,
                            library = {
                                vim.env.VIMRUNTIME
                            }
                        }
                    })
                end,
                settings = {
                    Lua = {}
                }
            })
        end,
    })
end)
-- }}}

-- mini.surround {{{
-- sa<textObject><char> : Add surround
-- sd<char>             : Delete surround
-- sr<char><char>       : Replace surround
-- sf<char>             : Find surround forward (sF is backward)
-- sh<char>             : Highlight surround
later(function() require('mini.surround').setup() end)
-- }}}

-- mini.comment {{{
-- Toggle comment-out and uncomment
-- default mappging : 'gc'
later(function() require('mini.comment').setup() end)
-- }}}

-- mini.trailspace {{{
-- highlight tailing spaces
later(function() require('mini.trailspace').setup() end)
-- }}}

-- git 関連 {{{
later(function()
    add('lewis6991/gitsigns.nvim')
    require('gitsigns').setup({
        signcolumn = true, -- Toggle with :Gitsigns toggle_signs
        numhl      = true, -- Toggle with :Gitsigns toggle_numhl
        linehl     = false, -- Toggle with :Gitsigns toggle_linehl
        word_diff  = false, -- Toggle with :Gitsigns toggle_word_diff
    })
    vim.keymap.set('n', ']g', '<cmd>Gitsign nav_hunk next<CR>')
    vim.keymap.set('n', '[g', '<cmd>Gitsign nav_hunk prev<CR>')
    vim.keymap.set('n', '<C-g>p', '<cmd>Gitsign preview_hunk<CR>')
    vim.keymap.set('n', '<C-g>a', '<cmd>Gitsign stage_hunk<CR>')
    vim.keymap.set('n', '<C-g>r', '<cmd>Gitsign reset_base<CR>')

end)
later(function()
    add({
        source = 'lambdalisue/gin.vim',
        depends = { 'vim-denops/denops.vim' },
    })
    -- nvim 起動時に :GinStatus を実行する {{{
    -- vim.api.nvim_create_autocmd('User', {
    --     pattern = 'DenopsPluginPost:gin',
    --     callback = function()
    --         vim.schedule(function()
    --             vim.fn.execute('GinStatus')
    --         end)
    --     end,
    --     once = true,
    -- })
    -- }}}
end)
-- }}}

-- Auto Completion {{{
---- min.completion {{{
later(function()
    require('mini.completion').setup({
        -- delay = { completion = 100, info = 100, signature = 50 },
        -- window = {
        --     info = { height = 25, width = 80, border = 'double' },
        --     signature = { height = 25, width = 80, border = 'single' },
        -- },
        -- lsp_completion = {
        --     -- source_func = 'completefunc',
        --     source_func = 'omnifunc',
        -- },
        -- auto_setup = true,
        -- set_vim_settings = true
    })
    vim.keymap.set('i', '<Tab>',   [[pumvisible() ? "\<C-n>" : "\<Tab>"]],   { expr = true })
    vim.keymap.set('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })
    local keys = {
        ['cr'] = vim.api.nvim_replace_termcodes('<CR>', true, true, true),
        ['ctrl-y'] = vim.api.nvim_replace_termcodes('<C-y>', true, true, true),
        ['ctrl-y_cr'] = vim.api.nvim_replace_termcodes('<C-y><CR>', true, true, true),
    }
    _G.cr_action = function()
        if vim.fn.pumvisible() ~= 0 then
            local item_selected = vim.fn.complete_info()['selected'] ~= -1
            return item_selected and keys['ctrl-y'] or keys['ctrl-y_cr']
        else
            return keys['cr']
        end
    end
end) -- }}}
---- nvim-cmp {{{
-- later(function()
--     add({
--         source = 'hrsh7th/nvim-cmp',
--         depends = {
--             'hrsh7th/cmp-nvim-lsp',
--             'hrsh7th/cmp-path',
--             'hrsh7th/cmp-buffer',
--             'hrsh7th/cmp-cmdline',
--         }
--     })
--     local cmp = require('cmp')
--     cmp.setup({
--         sources = {
--             { name = 'nvim_lsp' },
--             { name = 'buffer' },
--             { name = 'path' },
--         },
--         mapping = cmp.mapping.preset.insert({
--             ['<C-p>'] = cmp.mapping.select_prev_item(),
--             ['<C-n>'] = cmp.mapping.select_next_item(),
--             ['<C-i>'] = cmp.mapping.complete(),
--             ['<C-e>'] = cmp.mapping.abort(),
--             ['<CR>'] = cmp.mapping.confirm( { select = true } ),
--         }),
--     })
--     cmp.setup.cmdline({ '/', '?' }, {
--         mapping = cmp.mapping.preset.cmdline(),
--         sources = {
--             { name = 'buffer' }
--         }
--     })
--     -- -- Gin の action: 補完とコンフリクト？ コメントアウトする
--     -- cmp.setup.cmdline(':', {
--     --     mapping = cmp.mapping.preset.cmdline(),
--     --     sources = {
--     --         { name = 'path' },
--     --         { name = 'cmdline', option = { ignore_cmds = { 'Man', '!' } } }
--     --     },
--     --     matching = { disallow_symbol_nonprefix_matching = false },
--     -- })
-- end) -- }}}
---- ddc {{{
-- later(function()
--     add({
--         source = 'Shougo/ddc.vim',
--         depends = {
--             'vim-denops/denops.vim',
--             'Shougo/ddc-ui-native',
--             'Shougo/ddc-source-around',
--             'tani/ddc-fuzzy'
--         }
--     })
--     vim.fn['ddc#custom#patch_global']('ui', 'native')
--     vim.fn['ddc#custom#patch_global']('sources', { 'around' })
--     vim.fn['ddc#custom#patch_global']('sourceOptions', {
--         _ = {
--             matchers = {'matcher_fuzzy'},
--             sorters = {'sorter_fuzzy'},
--             converters = {'converter_fuzzy'}
--         }
--     })
--     vim.fn['ddc#enable']()
-- end) -- }}}
-- }}}

-- dial {{{
-- see: https://github.com/monaqa/dial.nvim/blob/master/README_ja.md
add({ source = 'monaqa/dial.nvim' })
later(function()
    local dial = require('dial.map')
    local augend = require('dial.augend')
    require('dial.config').augends:register_group({
        default = {
            augend.integer.alias.decimal,
            augend.integer.alias.hex,
            augend.date.alias['%Y/%m/%d'],
            augend.constant.alias.bool,
        },
        visual = {
            augend.integer.alias.decimal,
            augend.integer.alias.hex,
            augend.date.alias['%Y/%m/%d'],
            augend.constant.alias.alpha,
            augend.constant.alias.Alpha
        }
    })
    vim.keymap.set('n', '<C-a>', function() dial.manipulate('increment', 'normal') end)
    vim.keymap.set('n', '<C-x>', function() dial.manipulate('decrement', 'normal') end)
    vim.keymap.set('n', 'g<C-a>', function() dial.manipulate('increment', 'gnormal') end)
    vim.keymap.set('n', 'g<C-x>', function() dial.manipulate('decrement', 'gnormal') end)
    vim.keymap.set('v', '<C-a>', dial.inc_visual('visual'), { noremap = true })
    vim.keymap.set('v', '<C-x>', dial.dec_visual('visual'), { noremap = true })
    vim.keymap.set('v', 'g<C-a>', function() dial.manipulate('increment', 'gvisual') end)
    vim.keymap.set('v', 'g<C-x>', function() dial.manipulate('decrement', 'gvisual') end)
end)
-- }}}

-- Cmdline Abbreviation {{{
later(function()
    -- By: https://github.com/monaqa/dotfiles/blob/2f9797a41903cad4b7d35f9c2bdef70e97e2a33e/.config/nvim/lua/rc/abbr.lua

    vim.cmd([[
    function! RemoveAbbrTrigger(arg)
        if a:arg
            call getchar()
        endif
        return ""
    endfunction
    ]])

    ---@alias abbrrule {from: string, to: string, prepose?: string, prepose_nospace?: string, remove_trigger?: boolean}

    ---@param rules abbrrule[]
    local function make_abbrev(rules)
        -- 文字列のキーに対して常に0のvalue を格納することで、文字列の hashset を実現。
        ---@type table<string, abbrrule[]>
        local abbr_dict_rule = {}

        for _, rule in ipairs(rules) do
            local key = rule.from
            if abbr_dict_rule[key] == nil then
                abbr_dict_rule[key] = {}
            end
            table.insert(abbr_dict_rule[key], rule)
        end

        for key, rules_with_key in pairs(abbr_dict_rule) do
            ---コマンドラインが特定の内容だったら、それに対応する値を返す。
            ---@type table<string, string>
            local d_str = {}
            local d_remove = {}

            for _, rule in ipairs(rules_with_key) do
                local required_pattern = rule.from
                if rule.prepose_nospace ~= nil then
                    required_pattern = rule.prepose_nospace .. required_pattern
                elseif rule.prepose ~= nil then
                    required_pattern = rule.prepose .. " " .. required_pattern
                end
                d_str[required_pattern] = rule.to
                if rule.remove_trigger then
                    d_remove[required_pattern] = true
                else
                    d_remove[required_pattern] = false
                end
            end

            vim.cmd(
                ([[
                    cnoreabbrev <expr> %s (getcmdtype()==# ":" && has_key(%s, getcmdline())) ? get(%s, getcmdline()) .. RemoveAbbrTrigger(get(%s, getcmdline())) : %s
                ]]):format(
                    key,
                    vim.fn.string(d_str),
                    vim.fn.string(d_str),
                    vim.fn.string(d_remove),
                    vim.fn.string(key)
                )
            )
        end
    end

    make_abbrev({
        { from = "gc", to = "Gin commit" },
        { from = "gl", to = "GinLog" },
        { from = "gs", to = "GinStatus" },
        { from = "git", to = "Gin" },
        { from = "ts", to = "horizontal belowright terminal" },
        { from = "tv", to = "virtical botright terminal" },
        { from = "tt", to = "tab terminal" },
        { from = "open", to = "!open" },
        { from = "rg", to = "silent grep" },
        { from = "s", to = "%s///g<Left><Left>", remove_trigger = true },
        { from = "vims", to = "vimgrep // %" },
        { from = "gd", to = "g//d" },
        { from = "vd", to = "v//d" },
        { prepose = "Gin commit", from = "a", to = "--amend" },
        { prepose = "GinLog", from = "s", to = "++opener=split" },
        { prepose = "GinLog", from = "v", to = "++opener=vsplit" },
        { prepose = "GinLog", from = "t", to = "++opener=newtab" },
        { prepose = "GinStatus", from = "s", to = "++opener=split" },
        { prepose = "GinStatus", from = "v", to = "++opener=vsplit" },
        { prepose = "GinStatus", from = "t", to = "++opener=newtab" },
        { prepose_nospace = "'<,'>", from = "s", to = "s///g<Left><Left>", remove_trigger = true },
        { prepose_nospace = "'<,'>", from = "gd", to = "g//d" },
        { prepose_nospace = "'<,'>", from = "vd", to = "v//d" },
    })
end) -- }}}

-- Terminal 設定 {{{
vim.api.nvim_create_autocmd('TermOpen', { -- ターミナルを起動したら挿入モードになる
    callback = function() vim.cmd([[startinsert]]) end
})
vim.api.nvim_create_autocmd('TermEnter', { -- Terminalモード時は行番号を表示しない
    callback = function() vim.opt_local.number = false end
})
vim.api.nvim_create_autocmd('TermLeave', { -- Terminalモードから抜けたら行番号を表示する
    callback = function() vim.opt_local.number = true end
})
-- <C-q>, <C-]> で Terminalモードから抜ける
vim.keymap.set('t', '<C-q>', '<C-\\><C-n>', { noremap = true })
vim.keymap.set('t', '<C-]>', '<C-\\><C-n>', { noremap = true })
-- }}}

-- vim: set fdm=marker:
