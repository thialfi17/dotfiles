local scopes = {o = vim.o, b = vim.bo, w = vim.wo}

local function opt(scope, key, value)
	scopes[scope][key] = value
	if scope ~= 'o' then
		scopes['o'][key] = value
	end
end

vim.cmd('syntax on')

-- Global Options
opt('o', 'hidden', true)
opt('o', 'scrolloff', 10)
--o.ruler = true
--o.hlsearch = true
--o.wildmenu = true
opt('o', 'wildmode', 'longest:full,full')
opt('o', 'history', 1000)
--o.laststatus = 2
--o.backspace = 'indent,start,eol'
--o.showcmd = true
opt('o', 'foldlevelstart', 99)
opt('o', 'splitright', true)
opt('o', 'splitbelow', true)
opt('o', 'mouse', 'a')
--o.background = 'dark'
opt('o', 'showbreak', ' ↳')
opt('o', 'listchars', 'tab:→ ,nbsp:⍽,trail:␣,extends:⇒,precedes:⇐')
opt('o', 'completeopt', 'menuone,noselect')
opt('o', 'statusline', '%<%f %h%m%r%=%-14.{get(b:,"gitsigns_status","")} %-14.(%l,%c%V%) %P')

-- Window Options
opt('w', 'number', true)
opt('w', 'cursorcolumn', true)
opt('w', 'wrap', true)
opt('w', 'foldmethod', 'expr')
opt('w', 'foldexpr', 'nvim_treesitter#foldexpr()')
opt('w', 'foldenable', true)
opt('w', 'list', true)

-- Buffer Options
--bo.autoindent = true
opt('b', 'tabstop', 4)
opt('b', 'shiftwidth', 4)
opt('b', 'expandtab', true)
opt('b', 'undofile', true)
opt('b', 'modeline', true)

vim.api.nvim_set_var('python_recommended_style', 0)
