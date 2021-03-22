local map = vim.api.nvim_set_keymap

map('t', '<Esc><Esc>', '<C-\\><C-n>', {})

map('n', 'n', 'nzz', {noremap = true})
map('n', 'N', 'Nzz', {noremap = true})

map('n', '<Leader>lm', ":lua require'telescope.builtin'.reloader()<CR>", {silent = true})
map('n', '<Leader>ff', ":lua require'telescope.builtin'.find_files()<CR>", {silent = true})
map('n', '<Leader>fnf', ":lua require'myconf.plugins.telescope'.find_dotfiles()<CR>", {silent = true})
map('n', '<Leader>fng', ":lua require'myconf.plugins.telescope'.search_dotfiles()<CR>", {silent = true})
