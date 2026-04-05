local opt = vim.opt_local;
opt.expandtab = true
vim.opt_local.tabstop = 4
vim.opt_local.list = true

pcall(vim.treesitter.start)
