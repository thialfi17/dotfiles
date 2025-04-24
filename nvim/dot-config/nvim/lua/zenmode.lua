local M = {}

---@class zenmode.TabVars
---@field blank_win? integer
---@field main_win? integer
---@field orig_win? integer
---@field opts? table
---@field augroup? integer

---@class zenmode.Config
local defaults = {
    min_width = 80,
    max_width = 240,
    scaling = 0.8,
}

---@type zenmode.Config
local options = defaults

---@type integer
local blank_id

---@type zenmode.TabVars[]
local zenmode_sessions = {}

---@param win integer Window handle
local fix_hl = function(win)
    local tab_vars = zenmode_sessions[vim.api.nvim_win_get_tabpage(win)]
    -- TODO: Make these customisable
    vim.api.nvim_set_option_value("winhl", "NormalFloat:Normal,SignColumn:Normal", { win = tab_vars.main_win })
    vim.api.nvim_set_option_value("winhl", "NormalFloat:Normal,EndOfBuffer:Normal", { win = tab_vars.blank_win })
end

local on_win_close = function(win)
    return function()
        local tabpage = vim.api.nvim_win_get_tabpage(win)
        local tab_vars = zenmode_sessions[tabpage]

        local zenmode_buf = vim.api.nvim_win_get_buf(tab_vars.main_win)
        -- If changed buffer in zenmode win, change in original win
        if zenmode_buf ~= vim.api.nvim_win_get_buf(tab_vars.orig_win) then
            vim.api.nvim_win_set_buf(tab_vars.orig_win, zenmode_buf)
        end

        -- Match cursor positions
        vim.api.nvim_win_set_cursor(tab_vars.orig_win, vim.api.nvim_win_get_cursor(tab_vars.main_win))

        vim.api.nvim_win_close(tab_vars.blank_win, false)
        vim.api.nvim_del_augroup_by_id(tab_vars.augroup)
        vim.t.zenmode = 0
        zenmode_sessions[tabpage] = nil
    end
end

local on_win_resize = function(win)
    return function()
        local tabpage = vim.api.nvim_win_get_tabpage(win)
        local tab_vars = zenmode_sessions[tabpage]
        local opts = tab_vars.opts

        local blank_opts = vim.api.nvim_win_get_config(tab_vars.blank_win)
        blank_opts.width = vim.o.columns
        blank_opts.height = vim.o.lines - 1
        blank_opts.row = 0
        blank_opts.col = 0

        ---@diagnostic disable-next-line:need-check-nil
        if opts.show_tabline then
            blank_opts.height = blank_opts.height - 1
            blank_opts.row = blank_opts.row + 1
        end

        ---@diagnostic disable-next-line:need-check-nil
        if opts.show_statusline then
            blank_opts.height = blank_opts.height - 1
        end

        tab_vars.opts = vim.tbl_extend("force", options, vim.t.zenmode_opts or {})

        local main_opts = vim.api.nvim_win_get_config(tab_vars.main_win)
        local width = math.min(
            math.max(tab_vars.opts.min_width, math.floor(blank_opts.width * tab_vars.opts.scaling)),
            tab_vars.opts.max_width
        )
        main_opts.width = width
        main_opts.height = blank_opts.height
        main_opts.row = blank_opts.row
        main_opts.col = (blank_opts.width - width) / 2

        vim.api.nvim_win_set_config(tab_vars.main_win, main_opts)
        vim.api.nvim_win_set_config(tab_vars.blank_win, blank_opts)
    end
end

local on_win_create = function(win)
    local tab_vars = zenmode_sessions[vim.api.nvim_win_get_tabpage(win)]
    tab_vars.main_win = win

    tab_vars.augroup = vim.api.nvim_create_augroup("Zenmode" .. win, { clear = true })

    vim.api.nvim_create_autocmd({ "WinClosed" }, {
        group = tab_vars.augroup,
        desc = "Close the background window",
        pattern = tostring(win),
        callback = on_win_close(win),
    })

    vim.api.nvim_create_autocmd({ "VimResized" }, {
        group = tab_vars.augroup,
        desc = "Resize Zenmode windows",
        callback = on_win_resize(win),
    })

    vim.api.nvim_create_autocmd({ "BufEnter" }, {
        group = tab_vars.augroup,
        desc = "Fix the highlight groups for new buffer",
        callback = function()
            if vim.api.nvim_get_current_win() == win then
                fix_hl(win)
            end
        end,
    })
end

---@param opts? zenmode.Config
M.setup = function(opts)
    options = vim.tbl_deep_extend('keep', opts or {}, options)
end

---@class zenmode.OpenOpts
---@field show_tabline? boolean Defaults to false
---@field show_statusline? boolean Defaults to false

---@param opts? zenmode.OpenOpts
M.open = function(opts)
    opts = opts or {}

    local tabpage = vim.api.nvim_get_current_tabpage()

    local tab_vars = zenmode_sessions[tabpage]

    if tab_vars == nil then
        tab_vars = { }
        zenmode_sessions[tabpage] = tab_vars
    end

    tab_vars.orig_win = vim.api.nvim_get_current_win()

    ---@type vim.api.keyset.win_config
    local win_opts = {
        relative = "editor",
    }

    -- Create background window buffer if not exists
    blank_id = blank_id or vim.api.nvim_create_buf(false, true)

    -- Get tabpage specific options
    -- TODO: is this still the interface I want to use?
    tab_vars.opts = vim.tbl_extend("force", options, vim.t.zenmode_opts or {})

    --- Background window
    ---@type vim.api.keyset.win_config
    local blank_opts = {
        width = vim.o.columns,
        height = vim.o.lines - 1,
        focusable = false,
        zindex = 49,
        row = 0,
        col = 0,
        style = "minimal",
    }

    if opts.show_tabline then
        blank_opts.height = blank_opts.height - 1
        blank_opts.row = blank_opts.row + 1
    end

    if opts.show_statusline then
        blank_opts.height = blank_opts.height - 1
    end

    blank_opts = vim.tbl_extend("keep", blank_opts, win_opts)

    tab_vars.blank_win = vim.api.nvim_open_win(blank_id, false, blank_opts)

    -- Foreground window
    local width = math.min(
        math.max(tab_vars.opts.min_width, math.floor(blank_opts.width * tab_vars.opts.scaling)),
        tab_vars.opts.max_width
    )
    ---@type vim.api.keyset.win_config
    local main_opts = {
        width = width,
        height = blank_opts.height,
        focusable = true,
        row = blank_opts.row,
        col = (blank_opts.width - width) / 2,
    }
    main_opts = vim.tbl_extend("keep", main_opts, win_opts)

    local win = require("win.blocking").open_floating(vim.api.nvim_win_get_buf(tab_vars.orig_win), main_opts, on_win_create)

    fix_hl(win)

    if opts.show_tabline or opts.show_statusline then
        vim.t.zenmode = 1
    else
        vim.t.zenmode = 2
    end
end

M.close = function()
    local tabpage = vim.api.nvim_get_current_tabpage()
    local tab_vars = zenmode_sessions[tabpage]

    if tab_vars ~= nil then
        vim.api.nvim_win_close(tab_vars.main_win, false)
    end
end

---@param opts? zenmode.OpenOpts
M.toggle = function(opts)
    local tabpage = vim.api.nvim_get_current_tabpage()
    local status = vim.t[tabpage].zenmode

    if status ~= nil then
        if status ~= 0 then
            M.close()
            return
        end
    end
    M.open(opts)
end

return M
