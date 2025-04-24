local M = {}

---@alias win.SmartRule fun(buf?: integer, opts?: table): boolean
---@alias win.SmartRuleWithOpts { [1]: win.SmartRule, [2]: table }
---@alias _smart_rule win.SmartRule|win.SmartRuleWithOpts

---@alias win.SmartRules _smart_rule[]

-- All rules should switch to the window if they succeed in creating/finding an appropriate window.
-- Pass opts with `focus = false` if this is not desired.
---@param buf integer|nil buffer to search for and load (if provided)
---@param rules win.SmartRules rules for opening windows
---@param opts? table
---@return boolean loaded, integer|nil win
function M.open(buf, rules, opts)
    local default_opts = {
        focus = true,
        win_opts = {},
    }
    opts = opts or {}
    opts = vim.tbl_deep_extend("keep", opts, default_opts)

    local loaded = false
    for _, rule in ipairs(rules) do
        if type(rule) == "function" then
            loaded = rule(buf)
        elseif type(rule) == "table" then
            loaded = rule[1](buf, rule[2])
        else
            print("Unrecognised type for rule: " .. type(rule))
            return false, nil
        end

        if loaded then
            if buf ~= nil and buf > 0 then
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
