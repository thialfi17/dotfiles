local M = {}

---@param title string Popup title
---@param lines string[] Lines to add to the popup window
---@param opts? vim.api.keyset.win_config
---@return integer winid window-ID of the created popup
local function open_windows(title, lines, opts)
    opts = opts or {}

    local default_opts = {
        width = math.max( #title + 2, unpack(vim.tbl_map(function(item)
            return #item
        end, lines))),
        height = #lines,
        zindex = 50,
        focusable = true,
        style = "minimal",
        border = "double",
        relative = "editor",
    }
    default_opts.row = math.floor(math.max((vim.opt.lines:get() - default_opts.height) / 2 - 1, 0))
    default_opts.col = math.floor(math.max((vim.opt.columns:get() - default_opts.width) / 2 - 1, 0))

    local window_opts = vim.tbl_extend("keep", opts, default_opts)
    local window_bid = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_option_value("bufhidden", "wipe", { scope = "local", buf = window_bid })
    vim.api.nvim_set_option_value("buflisted", false, { scope = "local", buf = window_bid })
    vim.api.nvim_buf_set_lines(window_bid, 0, -1, true, lines)

    local title_opts = {
        width = #title,
        height = 1,
        zindex = window_opts.zindex + 1,
        focusable = false,
        border = "none",
        style = "minimal",
        col = window_opts.col + 1,
    }
    title_opts = vim.tbl_extend("keep", title_opts, window_opts)

    local title_bid = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(title_bid, 0, -1, true, {title,})
    local title_id = vim.api.nvim_open_win(title_bid, false, title_opts)

    -- Open title window first since blocking windows automatically close when a new window is opened.
    local window_id = require("win/blocking").open_floating(window_bid, window_opts)
    vim.api.nvim_set_option_value("cursorline", true, { scope = "local", win = window_id })
    vim.api.nvim_set_option_value("winhl", "Cursor:helpNote,FloatBorder:NormalFloat", { scope = "local", win = window_id })

    local augroup = vim.api.nvim_create_augroup("Popup" .. window_id, { clear = true })

    vim.api.nvim_create_autocmd("WinClosed", {
        group = augroup,
        desc = "Close the title window when the popup is closed",
        pattern = tostring(window_id),
        callback = function ()
            vim.api.nvim_win_close(title_id, false)
            vim.api.nvim_del_augroup_by_id(augroup)
        end,
    })

    vim.api.nvim_create_autocmd("BufLeave", {
        group = augroup,
        desc = "Close the popup window if the buffer leaves the window",
        nested = true,
        callback = function ()
            if vim.api.nvim_get_current_win() == window_id then
                vim.api.nvim_win_close(window_id, false)
            end
        end,
    })

    return window_id
end

M.list = function (title, items, cb, opts)
    opts = opts or {}
    if #items == 0 then return end

    local src_win = vim.api.nvim_get_current_win()
    local window_id = open_windows(title, items, opts)

    vim.cmd("stopinsert")

    local buf_id = vim.api.nvim_win_get_buf(window_id)
    vim.api.nvim_set_option_value("modifiable", false, { scope = "local", buf = buf_id })
    vim.api.nvim_buf_set_keymap(buf_id, "n", "q", "<Cmd>close<CR>", {})
    vim.api.nvim_buf_set_keymap(buf_id, "n", "<Esc>", "<Cmd>close<CR>", {})
    vim.api.nvim_buf_set_keymap(buf_id, "n", "<CR>", "", {
        callback = function ()
            local line_nr, _ = unpack(vim.api.nvim_win_get_cursor(0))
            if vim.api.nvim_win_is_valid(window_id) then
                vim.api.nvim_win_close(window_id, false)
            end
            local win
            vim.api.nvim_win_call(src_win, vim.schedule_wrap(function ()
                -- schedule needed https://github.com/neovim/neovim/issues/19614
                -- Presumably something is triggering textlock. Maybe closing the window?
                win = cb(line_nr)
            end))
            if win then
                vim.api.nvim_set_current_win(win)
            end
        end
    })

    return window_id
end

return M
