local M = {}

M.load_workarea = function (workarea)
    workarea.opts = workarea.opts or {}

    vim.cmd("cd " .. workarea.dir)

    -- Open file if provided in open_file or default to dir browser
    vim.cmd("e " .. (workarea.opts.open_file or workarea.dir))
end

return M
