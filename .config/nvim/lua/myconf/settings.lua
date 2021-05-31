vim.cmd('syntax on')

-- Global Options
--o.ruler = true
--o.hlsearch = true
--o.wildmenu = true
--o.laststatus = 2
--o.backspace = 'indent,start,eol'
--o.showcmd = true
--o.background = 'dark'

-- Buffer Options
--bo.autoindent = true

vim.opt.hidden = true
vim.opt.scrolloff = 10
vim.opt.wildmode = "longest:full,full"
vim.opt.history = 1000
vim.opt.foldlevelstart = 99
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.mouse = 'a'
vim.opt.showbreak = ' ↳'
vim.opt.listchars = { space = " ", tab = ">>", nbsp = "~", trail = "_", extends = "⇒", precedes = "⇐", }
vim.opt.completeopt = 'menuone,noselect'
vim.opt.statusline = '%<%f %h%m%r%=%-14.{get(b:,"gitsigns_status","")} %-14.(%l,%c%V%) %P'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorcolumn = true
vim.opt.wrap = true
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldenable = true
vim.opt.list = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.undofile = true
vim.opt.modeline = true
vim.opt.termguicolors = true


vim.api.nvim_set_var('python_recommended_style', 0)
