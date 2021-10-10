local M = {}
local bl = require('bufferline.state')
local tree_view = require('nvim-tree.view')
local tree = require('nvim-tree')

require('nvim-tree').setup {
    disable_netrw       = true,
    hijack_netrw        = true,
    open_on_setup       = false,
    ignore_ft_on_setup  = {},
    auto_close          = false,
    open_on_tab         = false,
    hijack_cursor       = false,
    update_cwd          = false,
    lsp_diagnostics     = false,
    update_focused_file = {
        enable      = false,
        update_cwd  = false,
        ignore_list = {}
    },
    system_open = {
        cmd  = nil,
        args = {}
    },
    view = {
        width = 30,
        side = 'left',
        auto_resize = false,
        mappings = {
            custom_only = false,
            list = {}
        }
    }
}

function M.toggle()
    if tree_view.win_open() then
        M.close()
    else
        if vim.g.nvim_tree_follow == 1 then
            tree.find_file(true)
        else
            bl.set_offset(31)
            tree.open()
        end
    end
end

function M.close()
    if tree_view.win_open() then
        bl.set_offset(0)
        tree.close()
        return true
    end
end

function M.open()
    if not tree_view.win_open() then
        bl.set_offset(31, "File Tree")
        tree.open()
    end
end

return M
