local M = {}

-- All rules should switch to the window if they succeed in creating/finding an appropriate window.
-- Pass opts with `focus = false` if this is not desired.
function M.open(buf, rules, opts)
    local default_opts = {
        focus = true,
        win_opts = {},
    }
    opts = opts or {}
    opts = vim.tbl_deep_extend("keep", opts, default_opts)

    local prev_win = vim.api.nvim_get_current_win()
    local loaded = false

    for _, rule in ipairs(rules) do
        if type(rule) == "function" then
            loaded = rule(buf)
        elseif type(rule) == "table" then
            loaded = rule[1](buf, rule[2])
        else
            print("Unrecognised type for rule: " .. type(rule))
            return
        end

        if loaded then
            if buf ~= nil and buf ~= 0 then
                vim.api.nvim_win_set_buf(0, buf)
            end
            break
        end
    end

    if not loaded and #rules > 0 then
        print("No rule succeeded in picking a window!")
        return false, nil
    end

    local win = vim.api.nvim_get_current_win()

    for opt, val in pairs(opts.win_opts) do
        vim.wo[win][opt] = val
    end

    -- Return created/found win in case it doesn't have focus
    return loaded, win
end

return M
