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

return M
