local M = {}

---@return integer|nil BufferID
local find_buf_by_name = function(name)
    local escaped_name = vim.fn.fnameescape(name)
    local buf = vim.fn.bufnr(escaped_name)

    if buf == -1 then
        return nil
    end
    return buf
end

---@alias scratch.BufOpts table<string, any>

---@param name string Scratch buffer name
---@param opts scratch.BufOpts Table of options to set for the scratch buffer
---@return integer|nil BufferID
M.create = function(name, opts)
    local buf = find_buf_by_name(name) or vim.api.nvim_create_buf(false, true)

    if buf == 0 then
        print("Could not create scratch buffer")
        return nil
    end

    for opt, val in pairs(opts) do
        vim.bo[buf][opt] = val
    end

    vim.api.nvim_buf_set_name(buf, name)
    return buf
end

---@class scratch.OpenOpts
---@field buf_opts scratch.BufOpts Table of options to set for the scratch buffer
---@field open_fun fun(buf: integer) Function to call to open the buffer in a window. Defaults to opening in current win.

---@param name? string Scratch buffer name
---@param opts? scratch.OpenOpts Options for opening the scratch buffer
---@return boolean success Success or fail
M.open = function(name, opts)
    local default_opts = {
        buf_opts = nil,
        open_fun = vim.api.nvim_set_current_buf,
    }
    opts = vim.tbl_extend("keep", opts or {}, default_opts)

    if name == nil then
        vim.ui.input({ prompt = "Call scratch buffer: " }, function(input)
            name = input
        end)
    end

    ---@diagnostic disable-next-line: param-type-mismatch
    local buf = M.create(name, opts.buf_opts)

    if buf ~= nil then
        opts.open_fun(buf)
        return true
    end

    return false
end

return M
