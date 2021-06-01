local M = {}
local bl = require('bufferline.state')
local tree_view = require('nvim-tree.view')
local tree = require('nvim-tree')

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
