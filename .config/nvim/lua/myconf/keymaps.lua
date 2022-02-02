local map = vim.keymap.set

map('t', '<Esc><Esc>', '<C-\\><C-n>', {desc="Return to normal mode"})

map('n', 'n', 'nzz', {noremap = true})
map('n', 'N', 'Nzz', {noremap = true})
