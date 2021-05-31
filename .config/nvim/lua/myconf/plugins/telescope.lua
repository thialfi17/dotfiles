local map = vim.api.nvim_set_keymap
local actions=require('telescope.actions')

require('telescope').setup {
	defaults = {
        color_devicons = true,
	}
}

local M = {}
M.find_dotfiles = function()
    require'telescope.builtin'.find_files({
        prompt_title = " NVIM Files ",
        cwd = "~/.config/nvim",
    })
end
M.search_dotfiles = function()
    require'telescope.builtin'.live_grep({
        prompt_title = " NVIM Files ",
        cwd = "~/.config/nvim",
    })
end

-- Telescope mappings
map('n', '<Leader>lm', ":lua require'telescope.builtin'.reloader()<CR>", {silent = true})
map('n', '<Leader>ff', ":lua require'telescope.builtin'.find_files()<CR>", {silent = true})
map('n', '<Leader>fg', ":lua require'telescope.builtin'.live_grep()<CR>", {silent = true})
map('n', '<Leader>fnf', ":lua require'myconf.plugins.telescope'.find_dotfiles()<CR>", {silent = true})
map('n', '<Leader>fng', ":lua require'myconf.plugins.telescope'.search_dotfiles()<CR>", {silent = true})

return M
