local M = {}

---@class win.blocking.Config
---@field mappings_to_overwrite? win.Mappings Contains the default mappings that will be blocked. To add extra mappings, use `additional_mappings_to_overwrite`.
---@field additional_mappings_to_overwrite? win.Mappings Additional mappings to block for blocking windows.
local defaults = {
    ---@class win.Mappings
    ---@field [" "]? table
    ---@field n? table
    ---@field v? table
    ---@field s? table
    ---@field x? table
    ---@field o? table
    ---@field ["!"]? table
    ---@field i? table
    ---@field l? table
    ---@field c? table
    ---@field t? table
    mappings_to_overwrite = {
        [" "] = {},
        n = {},
        v = {},
        s = {},
        x = {},
        o = {},
        ["!"] = {},
        i = {},
        l = {},
        c = {},
        t = {},
    },

    ---@type win.Mappings
    additional_mappings_to_overwrite = {}
}

--- Keys that have both CTRL-W_# mappings and CTRL-W_CTRL-# mappings
local wincmd_keys_to_clear = {
    'h', 'j', 'k', 'l', 'w', 't', 'b', 'p',
}
--- Keys that only have CTRL-W_# mappings
local wincmd_maps_to_clear = {
    '<up>', '<down>', '<left>', '<right>', 'P', 'W', '<BS>',
}

for _, key in pairs(wincmd_keys_to_clear) do
    table.insert(defaults.mappings_to_overwrite.n, '<C-W>' .. key)
    table.insert(defaults.mappings_to_overwrite.n, '<C-W><C-' .. key .. '>')
end

for _, key in pairs(wincmd_maps_to_clear) do
    table.insert(defaults.mappings_to_overwrite.n, '<C-W>' .. key)
end

---@type win.blocking.Config
local options = defaults

-- Track created mappings
--- Mappings created to block leaving the window
local created_mappings = {}
--- Buffer-local mapping which would have been overwritten
local overwritten_mappings = {}

---@type function
local close

local make_mappings = function(win)
    -- Don't recreate mappings if called again - can happen when re-entering
    -- window or calling :e
    if created_mappings[win] ~= nil then
        return
    end

    local buf = vim.api.nvim_win_get_buf(win)

    created_mappings[win] = {}
    overwritten_mappings[win] = {}

    ---@type win.Mappings
    local buf_keymaps = {}

    local function get_buffer_keymap(mode)
        local res = {}
        ---@type table<string, any>[]
        local keymap_list = vim.api.nvim_buf_get_keymap(buf, mode)
        for _, keymap in pairs(keymap_list) do
            res[keymap.lhs] = keymap
        end
        return res
    end

    local function iterate_table(tbl)
        for mode, keymaps in pairs(tbl) do
            -- Get existing buffer-local mappings and create a list which is
            -- indexed by LHS
            buf_keymaps[mode] = buf_keymaps[mode] or get_buffer_keymap(mode)
            created_mappings[win][mode] = created_mappings[win][mode] or {}

            -- See if a buffer-local mapping exists for the mappings we want to
            -- replace
            for _, keymap in pairs(keymaps) do
                if buf_keymaps[mode][keymap] ~= nil then
                    -- Mapping exists so save it to restore later
                    overwritten_mappings[win][mode] = created_mappings[win][mode] or {}
                    overwritten_mappings[win][mode][keymap] = buf_keymaps[mode][keymap]
                end

                -- Create the mapping
                vim.api.nvim_buf_set_keymap(buf, mode, keymap, "<Nop>", {})
                -- Save it to delete it later
                created_mappings[win][mode][keymap] = true
            end
        end
    end

    iterate_table(options.mappings_to_overwrite)
    iterate_table(options.additional_mappings_to_overwrite)
end

local clear_mappings = function(win)
    local buf = vim.api.nvim_win_get_buf(win)

    for mode, mode_item in pairs(created_mappings[win]) do
        for lhs, _ in pairs(mode_item) do
            vim.api.nvim_buf_del_keymap(buf, mode, lhs)
        end
    end

    for _, mode_item in pairs(overwritten_mappings[win]) do
        for _, keymap in pairs(mode_item) do
            vim.api.nvim_buf_set_keymap(
                buf,
                keymap.mode,
                keymap.lhs,
                keymap.rhs.gsub("<SID>", "<SNR>" .. keymap.sid .. "_"),
                {
                    expr = keymap.expr,
                    nowait = keymap.nowait,
                    silent = keymap.silent,
                }
            )
        end
    end

    created_mappings[win] = {}
    overwritten_mappings[win] = {}
end

local make_autocmds = function(win)
    local augroup = vim.api.nvim_create_augroup("Window" .. win, { clear = true })

    vim.api.nvim_create_autocmd({ "WinClosed" }, {
        group = augroup,
        desc = "Perform cleanup jobs associated with the opened window",
        pattern = tostring(win),
        callback = function () close(win) end,
        nested = true,
    })

    vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
        group = augroup,
        desc = "Make the mappings",
        callback = function()
            if vim.api.nvim_get_current_win() == win then
                make_mappings(win)
            end
        end,
        nested = false,
    })

    vim.api.nvim_create_autocmd({ "WinEnter" }, {
        group = augroup,
        desc = "Close window if entering another window on the same tabpage",
        callback = function()
            if vim.api.nvim_get_current_tabpage() == vim.api.nvim_win_get_tabpage(win)
                and vim.api.nvim_get_current_win() ~= win then
                close(win)
            end
        end,
        nested = true,
    })

    vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
        group = augroup,
        desc = "Clear the mappings",
        callback = function()
            if vim.api.nvim_get_current_win() == win then
                clear_mappings(win)
            end
        end,
        nested = false,
    })

    vim.api.nvim_create_autocmd({ "WinNew" }, {
        group = augroup,
        desc = "Close the window when a new window is opened in the tabpage",
        callback = function()
            if vim.api.nvim_get_current_tabpage() == vim.api.nvim_win_get_tabpage(win) then
                close(win)
            end
        end,
        nested = true,
    })
end

function close(win)
    clear_mappings(win)
    vim.api.nvim_del_augroup_by_name("Window" .. win)
    vim.api.nvim_win_close(win, false)
end

---@param opts? win.blocking.Config
M.setup = function(opts)
    options = vim.tbl_extend("keep", opts or {}, options, defaults)
end

---@param buf integer Buffer to open in created window
---@param opts vim.api.keyset.win_config Window options for opened window
---@param callback? fun(win: integer) Callback function that is passed the created window ID
M.open_floating = function(buf, opts, callback)
    callback = callback or function(_) end

    local win = vim.api.nvim_open_win(buf, true, opts)

    if win ~= 0 then
        callback(win)
        make_mappings(win)
        make_autocmds(win)
    end

    return win
end

return M
