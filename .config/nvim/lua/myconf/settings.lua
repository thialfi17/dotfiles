local scopes = {g = vim.o, b = vim.bo, w = vim.wo}

local function opt(scope, key, value)
	scopes[scope][key] = value
	if scope ~= 'g' then
		scopes['g'][key] = value
	end
end

vim.cmd('syntax on')

-- Global Options
opt('g', 'hidden', true)
opt('g', 'scrolloff', 10)
--o.ruler = true
--o.hlsearch = true
--o.wildmenu = true
opt('g', 'wildmode', 'longest:full,full')
opt('g', 'history', 1000)
--o.laststatus = 2
--o.backspace = 'indent,start,eol'
--o.showcmd = true
opt('g', 'foldlevelstart', 99)
opt('g', 'splitright', true)
opt('g', 'splitbelow', true)
opt('g', 'mouse', 'a')
--o.background = 'dark'
opt('g', 'showbreak', ' ↳')
opt('g', 'listchars', 'tab:→ ,nbsp:⍽,trail:␣,extends:⇒,precedes:⇐')


-- Window Options
opt('w', 'number', true)
opt('w', 'cursorcolumn', true)
opt('w', 'wrap', true)
opt('w', 'foldcolumn', '1')
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
