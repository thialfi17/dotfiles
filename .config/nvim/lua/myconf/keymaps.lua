local map = vim.api.nvim_set_keymap

map('t', '<Esc><Esc>', '<C-\\><C-n>', {})

map('n', 'n', 'nzz', {noremap = true})
map('n', 'N', 'Nzz', {noremap = true})

-- Telescope mappings
map('n', '<Leader>lm', ":lua require'telescope.builtin'.reloader()<CR>", {silent = true})
map('n', '<Leader>ff', ":lua require'telescope.builtin'.find_files()<CR>", {silent = true})
map('n', '<Leader>fg', ":lua require'telescope.builtin'.live_grep()<CR>", {silent = true})
map('n', '<Leader>fnf', ":lua require'myconf.plugins.telescope'.find_dotfiles()<CR>", {silent = true})
map('n', '<Leader>fng', ":lua require'myconf.plugins.telescope'.search_dotfiles()<CR>", {silent = true})

-- nvim-compe mappings
map('i', '<C-Space>', "compe#complete()", {silent = true, expr = true, noremap = true})
map('i', '<CR>', "compe#confirm('<CR>')", {silent = true, expr = true, noremap = true})
map('i', '<C-e>', "compe#close('<C-e>')", {silent = true, expr = true, noremap = true})
map('i', '<C-f>', "compe#scroll({'delta': +4})", {silent = true, expr = true, noremap = true})
map('i', '<C-d>', "compe#scroll({'delta': -4})", {silent = true, expr = true, noremap = true})
