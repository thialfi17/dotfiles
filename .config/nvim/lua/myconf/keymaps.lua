local map = vim.api.nvim_set_keymap

map('t', '<Esc><Esc>', '<C-\\><C-n>', {})

map('n', 'n', 'nzz', {noremap = true})
map('n', 'N', 'Nzz', {noremap = true})
