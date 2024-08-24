-- gin.vim の action: 用補完

local source = {}

source.kinds = {
    _               = { symbol = ' ', },
    rm              = { symbol = '🗑️', },
    add             = { symbol = '🚀', },
    browse          = { symbol = '🌏', },
    chaperon        = { symbol = '💥' },
    choice          = { symbol = '🈁' },
    delete          = { symbol = '🗑️' },
    diff            = { symbol = '🔛' },
    echo            = { symbol = '📣' },
    edit            = { symbol = '📝' },
    help            = { symbol = '❓' },
    log             = { symbol = '📄' },
    move            = { symbol = '🏃' },
    new             = { symbol = '🆕' },
    patch           = { symbol = '🪡' },
    ['repeat']      = { symbol = '🔁' },
    reset           = { symbol = '♻️' },
    restore         = { symbol = '♻️' },
    stage           = { symbol = '⏩' },
    stash           = { symbol = '📌' },
    unstage         = { symbol = '⏪' },
    yank            = { symbol = '📋' },
    ['cherry-pick'] = { symbol = '🍒' },
    fixup           = { symbol = '🆙' },
    merge           = { symbol = '⚗️' },
    rebase          = { symbol = '🛠️' },
    revert          = { symbol = '⏮️' },
    show            = { symbol = '👀' },
    switch          = { symbol = '🪵' },
    tag             = { symbol = '🔖' },
}
source.get_symbol = function(action_name)
    local kind = source.kinds[action_name]
    return kind and kind.symbol or kind._.symbol
end

source.is_available = function() -- filetype がgin-* の時のみ有効に
    local ft = vim.opt_local.filetype:get()
    if string.match(ft, '^gin%-') then
        return true
    end
    return false
end

source.get_keyword_pattern = function()
    return '[^[:blank:]]*'
end

---@param params cmp.SourceConfigEx
---@param callback fun(response: lsp.CompletionList|lsp.CompletionItem[]|nil)
source.complete = function(self, params, callback)
    local filetype = params.context.filetype
    if not string.match(filetype, '^gin%-') then
        return callback()
    end
    local completion_type = vim.fn.getcmdcompltype()
    if not string.match(completion_type, '^customlist,') then
        return callback()
    end
    local items = {}
    local mapped = {}
    local line = vim.fn.getline('.')
    local worktree = vim.fn['gin#component#worktree#name']()
    local branch = vim.fn['gin#component#branch#unicode']()
    -- nmap の lhs が '<Plug>(gin-action*)' のものを抽出
    -- see: https://github.com/lambdalisue/vim-gin/blob/main/denops/gin/action/core.ts#L50-L70
    for _, nmap in ipairs(vim.api.nvim_buf_get_keymap(0, 'n')) do
        local mappedAction = string.match(nmap.rhs, '<Plug>%(gin%-action%-(%S+)%)')
        local action = string.match(nmap.lhs, '<Plug>%(gin%-action%-(%S+)%)')
        if mappedAction then
            if not action then
                mapped[mappedAction] = nmap.lhs
            end
        elseif action then
            table.insert(items, {
                label = action,
                labelDetails = { detail = mapped[action] or '' },
                kind = 1,
                sortText = action,
                documentation = {
                    kind = 'markdown',
                    value = '# (' .. filetype .. ') ' .. action .. '\n\n' ..
                            '```yaml\n' ..
                            'Target  : "' .. line .. '"\n' ..
                            'Action  : "' .. nmap.lhs .. '"\n\n' ..
                            'Worktree:  ' .. worktree .. '\n' ..
                            'Branch  :  ' .. branch .. '\n' ..
                            '```'
                },
                data = { names = vim.split(action, ':') }
            })
        end
    end
    callback(items)
end

require('cmp').register_source('gin-action', source)

return source
