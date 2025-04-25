local M = {}

---@class user_command.Opts
---@field cmd? string Command to run to generate completions
---@field cmd_fun? fun(cmd: string, opts?: command.RunOpts) Function used to run completion script

---@type user_command.Opts
local options = {
    cmd = "get_complete",
    cmd_fun = require("command").run,
}

M.setup = function (opts)
    options = vim.tbl_deep_extend("keep", opts or {}, options)
end

-- NOTE: Unfotunately Bash completions have several quirks that require hard-coded workarounds.
-- Other terminals may be the same.
-- TODO: Pull out the Bash-specific code here to make it more configurable
M.bash_complete = function (arglead, cmdline, cursorpos)
    local results = {}
    local done = false

    local pid = options.cmd_fun(options.cmd, {
        args = { string.sub(cmdline, 1, cursorpos) },
        quiet = true,
        on_stdout = function (handle, err, chunk)
            if err then
                vim.notify(err, vim.log.levels.ERROR)
            elseif chunk then
                table.insert(results, chunk)
            else
                handle:close()
                done = true
            end
        end,
        -- Default stderr handler prints to message log
    })

    -- Completion is synchronous so make sure we don't take too long.
    if not vim.wait(1000, function() return done end, 10) then
        vim.notify("Completion timed out", vim.log.levels.INFO)
        vim.uv.kill(pid, 15)
    end

    results = vim.split(table.concat(results), "\n", { trimempty = true })

    -- Need to extract leading part of completion based on where cursor is placed
    local diff = #cmdline - #arglead
    if cursorpos < diff then
        arglead = string.sub(arglead, 1, cursorpos)
    else
        arglead = string.sub(arglead, 1, cursorpos - diff)
    end

    -- Remove duplicates
    local keys = {}
    local hash = {}
    for _, v in ipairs(results) do
        if hash[v] == nil then
            if #results > 1 then
                -- when multiple results, each result contains the leading text after "/"
                local parts = vim.split(arglead, "/")
                parts[#parts] = ""
                arglead= table.concat(parts, "/")
            end
            table.insert(keys, arglead .. v)
            hash[v] = true
        end
    end

    return keys
end

M.gen_command_complete = function (command, defaults)
    local complete_fun = function (arglead, cmdline, cursorpos)
        -- Remove the command name from the cmdline
        local parts = vim.split(cmdline, " ")
        local first = parts[1]
        local diff = #first

        assert(command == first, "Provided command name did not match the first argument")

        if defaults then
            parts[1] = defaults
            diff = diff - #defaults
        else
            table.remove(parts, 1)
            diff = diff + 1
        end

        cmdline = table.concat(parts, " ")
        cursorpos = cursorpos - diff

        -- Continue with completion
        return M.bash_complete(arglead, cmdline, cursorpos)
    end

    return complete_fun
end

return M
