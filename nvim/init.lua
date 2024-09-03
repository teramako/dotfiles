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

-- TreeSitter {{{
add({ source = 'nvim-treesitter/nvim-treesitter' })
later(function()
    require('nvim-treesitter.configs').setup({
        highlight = { enable = true, },
        indent = { enable = true },
    })
end)
-- }}}

-- ColorScheme {{{
-- now(function() vim.cmd('colorscheme minicyan') end)
add({ source = 'Mofiqul/dracula.nvim' })
later(function()
    vim.cmd('colorscheme dracula')
end)
-- }}}

-- Statusline, Tabline, Winbar {{{
add({
    -- see: https://github.com/nvim-lualine/lualine.nvim
    source = 'nvim-lualine/lualine.nvim',
    -- アイコン要らない
    -- depends = {
    --     'nvim-tree/nvim-web-devicons'
    -- }
})
later(function()
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
                        ['gin-branch'] = ' GitBranch',
                        ['gin-diff'] = ' GitDiff',
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
        vim.keymap.set({ 'n', 'i' }, '<C-k>',  '<cmd>:lua vim.lsp.buf.signature_help()<CR>') -- シグニチャーヘルプ(関数の引数情報など)を表示
        -- vim.keymap.set('n', 'gf', '<cmd>:lua vim.lsp.buf.formatting()<CR>')
        vim.keymap.set('n', 'gr', '<cmd>:lua vim.lsp.buf.references()<CR>') -- カーソル下の symbol の参照箇所の一覧表示(QuickFix), ジャンプ
        vim.keymap.set('n', 'gd', '<cmd>:lua vim.lsp.buf.definition()<CR>') -- カーソル下の symbol の定義箇所へジャンプ
        vim.keymap.set('n', 'gD', '<cmd>:lua vim.lsp.buf.declaration()<CR>')
        vim.keymap.set('n', 'gi', '<cmd>:lua vim.lsp.buf.implementation()<CR>')
        vim.keymap.set('n', 'gt', '<cmd>:lua vim.lsp.buf.type_definition()<CR>')
        vim.keymap.set('n', 'gn', '<cmd>:lua vim.lsp.buf.rename()<CR>') -- symbol の一括リネーム
        vim.keymap.set('n', '<F2>', '<cmd>:lua vim.lsp.buf.rename()<CR>') -- 同上
        vim.keymap.set('n', 'ga', '<cmd>:lua vim.lsp.buf.code_action()<CR>')
        -- vim.keymap.set('n', 'ge', '<cmd>:lua vim.diagnostic.open_float()<CR>') -- 警告・エラーメッセージの表示
        vim.keymap.set('n', 'ge', '<cmd>:lua vim.diagnostic.custom_open_float()<CR>') -- 警告・エラーメッセージの表示
        -- vim.keymap.set('n', 'g]', '<cmd>:lua vim.diagnostic.goto_next()<CR>')
        vim.keymap.set('n', 'g]', '<cmd>:lua vim.diagnostic.custom_goto("next")<CR>')
        -- vim.keymap.set('n', 'g[', '<cmd>:lua vim.diagnostic.goto_prev()<CR>')
        vim.keymap.set('n', 'g[', '<cmd>:lua vim.diagnostic.custom_goto("prev")<CR>')
        vim.keymap.set('n', 'gl', '<cmd>:lua vim.diagnostic.setloclist()<CR>') -- diagnostics を location list に出す

        vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false }
        )

        -- ウィンドウの透過をしたい場合は以下のようにすると良い
        -- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        --     function(...)
        --         local _, winnr = vim.lsp.handlers.hover(...)
        --         if winnr then
        --             vim.api.nvim_set_option_value('winblend', 20, { win = winnr })
        --         end
        --     end,
        --     { border = 'rounded' }
        -- )
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
            vim.lsp.handlers.hover, { border = 'rounded' }
        )
        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
            vim.lsp.handlers.signature_help, { border = 'single' }
        )
        -- diagnostic のウィンドウ表示
        -- border を使えたいので適当に関数を定義する
        vim.diagnostic.custom_open_float = function()
            vim.diagnostic.open_float({ border = 'double' })
            -- 透過したい場合は以下
            -- local _, winnr = vim.diagnostic.open_float({ border = 'double' })
            -- if winnr then
            --     vim.api.nvim_set_option_value('winblend', 40, { win = winnr })
            -- end
        end
        vim.diagnostic.custom_goto = function(name)
            vim.diagnostic['goto_' .. name]({ float = true })
            vim.schedule(function()
                vim.diagnostic.custom_open_float()
            end)
        end
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
    -- :GinStatus するとDiff Previewが出る拡張
    add({
        source = 'ogaken-1/nvim-gin-preview',
        depends = { 'lambdalisue/gin.vim' }
    })
    vim.g.gin_branch_persistent_args = { '-a' }
    vim.g.gin_log_persistent_args = { '++emojify' }
    -- nvim 起動時に :GinStatus を実行する {{{
    vim.api.nvim_create_autocmd('User', {
        pattern = 'DenopsPluginPost:gin',
        callback = function()
            local buf_name = vim.api.nvim_buf_get_name(0)
            if #buf_name > 0 then
                return
            end
            -- lualine のブランチ名取得でも良いけど、依存が増えるでボツ
            -- local branch = require('lualine.components.branch.git_branch').get_branch()
            -- if #branch > 0 then
            --     vim.schedule(function() vim.fn.execute('GinStatus') end)
            -- end
            vim.api.nvim_create_autocmd('User', {
                pattern = 'GinComponentPost',
                callback = function()
                    vim.schedule(function()
                        -- local worktree_name = vim.fn['gin#internal#component#get']('component:worktree:name')
                        local worktree_name = vim.fn['gin#component#worktree#name']()
                        if #worktree_name ~= 0 then
                            vim.fn.execute('GinStatus')
                        end
                    end)
                end,
                once = true
            })
            -- 空バッファだとUser GinComponentPost イベントが発行されない！？ので無理やり更新させる
            -- (遅延ロードさせているのが原因かも)
            vim.fn["gin#internal#component#update"]('component:worktree:name')
            vim.fn["gin#internal#component#update"]('component:branch:unicode')
        end,
        once = true,
    })
    -- }}}
end)
-- }}}

-- Auto Completion {{{
-- nvim-cmp {{{
later(function()
    add({
        source = 'hrsh7th/nvim-cmp',
        depends = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-nvim-lsp-signature-help',
            'hrsh7th/cmp-emoji',
            'onsails/lspkind.nvim',
            'teramako/cmp-cmdline-prompt.nvim',
        }
    })
    local cmp = require('cmp')
    local lspkind = require('lspkind')
    lspkind.setup({ preset = 'codicons' })
    cmp.setup({
        sources = {
            { name = 'nvim_lsp' },
            { name = 'nvim_lsp_signature_help' },
            { name = 'buffer' },
            { name = 'path' },
            { name = 'emoji' },
        },
        mapping = cmp.mapping.preset.insert({
            ['<C-d>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-p>'] = cmp.mapping.select_prev_item(),
            ['<C-n>'] = cmp.mapping.select_next_item(),
            ['<C-i>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm( { select = true } ),
        }),
        window = {
            completion = {
                winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None',
                col_offset = -3,
                side_padding = 0
            },
            documentation = {
                border = 'rounded'
            }
        },
        formatting = {
            fields = { 'kind', 'abbr', 'menu' },
            format = function(entry, item)
                local kind = lspkind.cmp_format({ mode = 'symbol_text', maxwidth = 50 })(entry, item)
                local strings = vim.split(kind.kind, '%s', { trimempty = true })
                kind.kind = ' ' .. (strings[1] or '') .. ' '
                kind.menu = '    (' .. (strings[2] or '') .. ')'
                return kind
            end
        }
    })
    cmp.setup.filetype('gitcommit', {
        sources = {
            { name = 'emoji' },
            { name = 'buffer' },
        }
    })
    cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = 'buffer' }
        }
    })
    cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = 'path' },
        }, {
            { name = 'cmdline', option = { ignore_cmds = { 'Man', '!' } } }
        }),
        matching = { disallow_symbol_nonprefix_matching = false },
    })
    require('cmp-gin-action')
    -- See: cmp.lsp.CompletionItemKind
    -- See: :help getcmdtype()
    cmp.setup.cmdline('@', { -- vim.fn.input() 時の補完
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            {
                name = 'cmdline-prompt',
                ---@type prompt.Option
                option = {
                    excludes = { 'customlist' },
                }
            },
            { name = 'gin-action' }
        }),
        formatting = {
            fields = { 'kind', 'abbr', 'menu' },
            format = function(entry, vim_item)
                local item = entry:get_completion_item()
                if entry.source.name == 'cmdline-prompt' then
                    vim_item.kind = cmp.lsp.CompletionItemKind[item.kind]
                    local kind = lspkind.cmp_format({ mode = 'symbol_text' })(entry, vim_item)
                    local strings = vim.split(kind.kind, '%s', { trimempty = true })
                    kind.kind = ' ' .. (strings[1] or '')
                    kind.menu = ' (' .. (item.data.completion_type or '') .. ')'
                    kind.menu_hl_group = kind.kind_hl_group
                    return kind
                elseif entry.source.name == 'gin-action' then
                    vim_item.kind = ' '
                    return vim_item
                else
                    return vim_item
                end
            end
        },
        sorting = {
            comparators = { cmp.config.compare.sort_text }
        },
        window = {
            completion = {
                col_offset = 6, -- "action: " の8文字分 - アイコン2文字
            },
        },
    })
end) -- }}}
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
        { from = "gb", to = "GinBranch" },
        { from = "gd", to = "GinDiff" },
        { from = "git", to = "Gin" },
        { from = "ts", to = "horizontal belowright terminal" },
        { from = "tv", to = "virtical botright terminal" },
        { from = "tt", to = "tab terminal" },
        { from = "open", to = "!open" },
        { from = "rg", to = "silent grep" },
        { from = "s", to = "%s///g<Left><Left>", remove_trigger = true },
        { from = "vims", to = "vimgrep // %" },
        { from = "diffsplit", to = "vertical diffsplit" },
        { prepose = "Gin commit", from = "a", to = "--amend" },
        { prepose = "GinLog", from = "s", to = "++opener=split" },
        { prepose = "GinLog", from = "v", to = "++opener=vsplit" },
        { prepose = "GinLog", from = "t", to = "++opener=tabedit" },
        { prepose = "GinStatus", from = "s", to = "++opener=split" },
        { prepose = "GinStatus", from = "v", to = "++opener=vsplit" },
        { prepose = "GinStatus", from = "t", to = "++opener=tabedit" },
        { prepose = "GinBranch", from = "s", to = "++opener=split" },
        { prepose = "GinBranch", from = "v", to = "++opener=vsplit" },
        { prepose = "GinBranch", from = "t", to = "++opener=newtab" },
        { prepose = "GinDiff", from = "s", to = "++opener=split" },
        { prepose = "GinDiff", from = "v", to = "++opener=vsplit" },
        { prepose = "GinDiff", from = "t", to = "++opener=newtab" },
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

-- DeepL {{{
add({ source = 'ryicoh/deepl.vim' })
later(function()
    require('deepl');
    vim.cmd([[packadd deepl.nvim]])
    vim.keymap.set('v', 't<C-j>', '<Cmd>call deepl#v("JA")<CR>', { noremap = true, desc = '選択行を日本語に変換' })
    vim.keymap.set('v', 't<C-e>', '<Cmd>call deepl#v("EN")<CR>', { noremap = true, desc = '選択行を英語に変換' })
    vim.keymap.set('n', 't<C-j>', 'yypV<Cmd>call deepl#v("JA")<CR>', { noremap = true, desc = 'カーソル行の下に日本語変換して追加' })
    vim.keymap.set('n', 't<C-e>', 'yypV<Cmd>call deepl#v("EN")<CR>', { noremap = true, desc = 'カーソル行の下に英語変換して追加' })
end)
-- }}}

-- vim: set fdm=marker:
