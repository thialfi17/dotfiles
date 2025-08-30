local M = {}

local next_id = 1
M.jobs = {}

local function read_start(handle, fun)
    local cb = function(err, chunk)
        return fun(handle, err, chunk)
    end
    return handle:read_start(cb)
end

---@alias read_cb fun(handle, err: string|nil, chunk: string|nil)
---
---@class command.RunOpts
---@field callback? function
---@field on_stdout? read_cb Default handler logs errors and closes the handle.
---@field on_stderr? read_cb Default handler prints output via `error()`
---@field quiet? boolean Whether to print status messges. Defaults to `false`.
---@field args? table List of command arguments
---@field env? table
---@field cmd_str? string String to print as the command in status messages. Defaults to the command used.

---@param cmd string Command to run
---@param opts? command.RunOpts
M.run = function (cmd, opts)
    local stdout = vim.loop.new_pipe(false)
    local stderr = vim.loop.new_pipe(false)
    local handle, pid
    local job_id = next_id

    next_id = next_id + 1

    local remaining = ""
    local parts = {}
    ---@type command.RunOpts
    local default_opts = {
        quiet = false,
        cmd_str = cmd,
        env = nil,
        args = nil,
        callback = function() end,
        on_stdout = function(h, err, chunk)
            if err then
                error(err)
            elseif chunk then
            else
                h:close()
            end
        end,
        on_stderr = function(h, err, chunk)
            if err then
                error(err)
            elseif chunk then
                local str = remaining .. chunk
                -- Trailing data
                remaining = str:match("\n[%w%p ]+$") or ""

                local strend = remaining:len()
                if strend == 0 then strend = 1 end

                -- Remove trailing data from the data we're processing
                str = str:sub(1, -strend)

                table.insert(parts, str)
            else
                h:close()

                local msg = table.concat(parts)
                if msg == "" then
                    return
                end
                error(msg)
            end
        end,
    }

    ---@type command.RunOpts
    opts = vim.tbl_extend("keep", opts or {}, default_opts)

    if not opts.quiet then
        print("Running cmd (" .. opts.cmd_str .. ")")
    end

    handle, pid = vim.uv.spawn(
        cmd,
        {
            args = opts.args,
            stdio = {nil, stdout, stderr},
            env = opts.env,
        },
        function(code, signal)
            ---@diagnostic disable-next-line: need-check-nil
            handle:close()

            M.jobs[job_id].status = "pending-callback"

            if opts.callback ~= nil then
                opts.callback(code, signal)
            end

            if not opts.quiet then
                print("Finished running cmd (" .. opts.cmd_str .. ") with exit code " .. code)
            end

            M.jobs[job_id].status = "finished"
            M.jobs[job_id].exit_code = code

            -- Remove most of the job informtion 5 minutes after it finished
            vim.defer_fn(function()
                M.jobs[job_id].opts = nil
            end, 1000*60*5)
        end
    )

    if type(pid) ~= "number" then
        error(pid)
    end

    M.jobs[job_id] = {
        status = "running",
        pid = pid,
        cmd = cmd,
        opts = opts,
    }

    read_start(stdout, opts.on_stdout)
    read_start(stderr, opts.on_stderr)

    return pid
end

local gen_replace_buf_cb = function(buf)
    local remaining = ""
    local first = true

    local on_stdout = function (handle, err, chunk)
        if err then
            local print = vim.pretty_print or vim.print
            print(err)
        elseif chunk then
            local str = remaining .. chunk
            -- Trailing data
            remaining = str:match("\n[%w%p ]+$") or ""

            local strend = remaining:len()
            if strend == 0 then strend = 1 end

            -- Remove trailing data from the data we're processing
            str = str:sub(1, -strend)

            -- Remove extra trailing blank line due to how split processes "\n" combined with how
            -- lines are being inserted into the buffer
            local lines = vim.split(str, "\n")

            if lines[1] == "" then
                table.remove(lines, 1)
            end

            if lines[#lines] == "" then
                table.remove(lines, #lines)
            end

            if first then
                -- Replace existing lines with new
                vim.schedule(function()
                    vim.api.nvim_buf_set_lines(buf, 0, -1, true, lines)
                end)
            else
                -- Append new lines
                vim.schedule(function()
                    vim.api.nvim_buf_set_lines(buf, -1, -1, true, lines)
                end)
            end
            first = false
        else
            handle:close()

            if first then
                vim.schedule(function()
                    vim.api.nvim_buf_set_lines(buf, 0, -1, true, {})
                end)
            end

            first = true
            remaining = ""
        end
    end

    return on_stdout
end

---@class command.ReplaceOpts
---@field clear? boolean Whether to clear the buffer
---@field run_opts? command.RunOpts

---@param cmd string The command to run
---@param buf integer The buffer to replace the text in
---@param opts command.ReplaceOpts
local replace_in_buffer = function(cmd, buf, opts)
    ---@type command.ReplaceOpts
    local default_opts = {
        clear = true,
        run_opts = {
            on_stdout = gen_replace_buf_cb(buf),
        }
    }
    opts = vim.tbl_deep_extend("keep", opts, default_opts)

    if opts.clear then
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
    end

    M.run(cmd, opts.run_opts)

    vim.keymap.set('n', '<F5>', function()
        if opts.clear then
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
        end
        M.run(cmd, opts.run_opts)
    end, {
        desc = "Re-run last cmd run in this buffer",
    })
end

---@class command.RunSmartOpts
---@field name? string Scratch buffer name
---@field buf_opts? scratch.BufOpts Table of options to set for the scratch buffer
---@field run_opts? command.RunOpts
---@field win_rules? any
---@field win_opts? any
---@field clear? boolean

---@param cmd string
---@param opts command.RunSmartOpts
M.run_smart = function(cmd, opts)
    opts = opts or {}

    local name = opts.name or ("cmd://" .. cmd)
    local buf = require("scratch").create(name, opts.buf_opts or {})

    if buf == nil then
        error("Failed to open scratch buffer")
        return
    end

    local loaded, win = require("win.smart").open(buf, opts.win_rules, opts.win_opts)

    if loaded == false then return end

    if opts.run_opts ~= nil then
        local cb = opts.run_opts.callback
        if cb ~= nil then
            opts.run_opts.callback = function(...)
                cb(win, ...)
            end
        end

        local fun = opts.run_opts.on_stdout
        if fun ~= nil then
            opts.run_opts.on_stdout = function(...)
                fun(buf, ...)
            end
        end
    end

    replace_in_buffer(cmd, buf, { clear = opts.clear, run_opts = opts.run_opts })
end

return M
