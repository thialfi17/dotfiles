-- TODO: Change how the default options are configured for these rules.

---@type win.SmartRule
--- Replace the buffer in the current window. Always succeeds.
function Replace()
    return true
end

---@type win.SmartRule
--- Split the window vertically. Always succeeds.
function VertSplit()
    vim.cmd("vert split")
    return true
end


---@type win.SmartRule
--- Look for a window containing the buffer in the current tab.
function CurrentTab(buf)
    local wins = vim.api.nvim_tabpage_list_wins(0)

    for _, win in ipairs(wins) do
        if vim.api.nvim_win_get_buf(win) == buf then
            vim.api.nvim_set_current_win(win)
            return true
        end
    end

    return false
end

---@type win.SmartRule
--- Find the first tab with a window containing the buffer.
function FirstTab(buf)
    local wins = vim.api.nvim_list_wins()
    for _, win in ipairs(wins) do
        if vim.api.nvim_win_get_buf(win) == buf then
            vim.api.nvim_set_current_win(win)
            return true
        end
    end

    return false
end

---@type win.SmartRule
--- Open the window in a new tab.
function NewTab()
    vim.cmd("tab split")
    return true
end

---@class SplitIfBiggerThanOpts
---@field width? integer
---@field height? integer
---@field pref_dir? "vertical"|"horizontal"

---@type win.SmartRule
---@param opts SplitIfBiggerThanOpts
function SplitIfBiggerThan(_, opts)
    local default_opts = {
        width = 180,
        height = 67,
        pref_dir = "vertical",
    }
    opts = opts or {}
    opts = vim.tbl_extend("keep", opts, default_opts)

    -- If floating then skip since floating windows can't be split
    if vim.api.nvim_win_get_config(0).relative ~= "" then
        return false
    end

    local function try_vert()
        if vim.api.nvim_win_get_width(0) >= opts.width then
            vim.cmd("vert split")
            return true
        end
        return false
    end

    local function try_horiz()
        if vim.api.nvim_win_get_height(0) >= opts.height then
            vim.cmd("split")
            return true
        end
        return false
    end

    -- Make use of short-cut evaluation (only first expression is called if it is true)
    if opts.pref_dir == "vertical" then
        return try_vert() or try_horiz()
    else
        return try_horiz() or try_vert()
    end
end

---@type win.SmartRule
function ReplaceRightSplit()
    -- Will be made cleaner with #24507 hopefully
    local layout = vim.fn.winlayout()

    if layout[1] == "row" then
        local indx = #layout[2]
        while indx > 0 do
            local winl = layout[2][indx]
            if winl[1] == "leaf" then
                vim.api.nvim_set_current_win(winl[2])
                return true
            end
            indx = indx - 1
        end
    end
    return false
end
