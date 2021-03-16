local o = vim.o
local wo = vim.wo
local bo = vim.bo

vim.cmd('syntax on')

-- Global Options
o.hidden = true
o.scrolloff = 10
--o.ruler = true
--o.hlsearch = true
--o.wildmenu = true
o.wildmode = 'longest:full,full'
o.history = 1000
--o.laststatus = 2
--o.backspace = 'indent,start,eol'
--o.showcmd = true
o.foldlevelstart = 99
o.splitright = true
o.splitbelow = true
o.mouse = 'a'
--o.background = 'dark'
o.showbreak =' ↳'
o.listchars = 'tab:→ ,nbsp:⍽,trail:␣,extends:⇒,precedes:⇐'


-- Window Options
wo.number = true
wo.cursorcolumn = true
wo.wrap = true
wo.foldcolumn = '1'
wo.foldmethod = 'manual'
wo.foldenable = true
wo.list = true

-- Buffer Options
--bo.autoindent = true
bo.tabstop = 4
bo.shiftwidth = 4
bo.expandtab = true
bo.undofile = true
