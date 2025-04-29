local M = {}

local utils = require("utils")

local concat = function(...)
    local ret = {}
    for _, v in ipairs({ ... }) do
        if type(v) == "table" then
            for _, v1 in ipairs( v ) do
                -- Remove empty strings and nil elements because they cause
                -- issues with the command argument interpretation
                if v1 ~= nil and (type(v1) ~= "string" or v1 ~= "") then
                    ret[#ret+1] = v1
                end
            end
        else
            -- Remove empty strings and nil elements because they cause
            -- issues with the command argument interpretation
            if v ~= nil and (type(v) ~= "string" or v ~= "") then
                ret[#ret+1] = v
            end
        end
    end
    return ret
end

---@param result string
---@param opts table
M.grep_filter = function (title, result, opts)
    -- TODO: Add context for better updating of lists?
    -- TODO: Can/should this use the json mode for ripgrep?

    opts.set_list({}, " ", {
        efm = opts.efm,
        lines = vim.split(result, "\n", {trimempty = true}),
        title = title,
    })

    vim.cmd[[ copen ]]

    vim.keymap.set("n", "<F5>", function ()
        M.grep(opts)
    end, {buffer = true})
end

M.grep = function(args, opts)
    -- TODO: Add module options so these can be overridden once and not on each
    -- call.
    -- TODO: Smart detection of whether to use loc vs qf list?
    local default_opts = {
        cmd = "grep",
        efm = "%f:%l:%m",
        default_flags = {"-nEIH"}, -- n: line number, H: filename, E: extended regex, I: ignore binary files
        default_recurse_flag = "-R",
        dir = vim.uv.cwd(),
        filter = M.grep_filter,
        set_list = vim.fn.setqflist,
    }
    opts = vim.tbl_extend('keep', opts or {}, default_opts)

    local split_args = utils.split_command(args.args)
    local nargs = #split_args
    local flags, grep, dir, cmd_str_parts

    if nargs < 1 then
        print("Not enough arguments!")
    elseif nargs == 1 then
        -- Default to recursing through current dir when only given a search string.
        flags = { opts.default_recurse_flag }
        grep = split_args[1]
        dir = opts.dir
        cmd_str_parts = concat(opts.cmd, opts.default_flags, opts.default_recurse_flag, args.args, opts.dir)
    else
        flags = { unpack(split_args, 1, #split_args - 2) }
        grep = split_args[#split_args - 1]
        dir = split_args[#split_args]
        cmd_str_parts = concat(opts.cmd, opts.default_flags, args.args)
    end

    dir = vim.fn.fnamemodify(vim.fn.expand(dir), ":.")

    local chunks = {}
    local err_chunks = {}
    local cmd_str = table.concat(cmd_str_parts, " ")
    local cmd_args = concat( opts.default_flags, flags, grep, dir )

    require("command").run(opts.cmd, {
        cmd_str = cmd_str,
        args = cmd_args,
        on_stdout = function (handle, err, chunk)
            if err then
                error(err)
            elseif chunk then
                chunks[#chunks+1] = chunk
            else
                vim.schedule(function ()
                    opts.set_list({}, " ", {
                        efm = opts.efm,
                        lines = vim.split(table.concat(chunks), "\n", {trimempty = true}),
                        title = cmd_str,
                    })

                    vim.cmd[[ copen ]]

                    vim.keymap.set("n", "<F5>", function ()
                        M.grep(args, opts)
                    end, {buffer = true})
                end)
                handle:close()
            end
        end,
        on_stderr = function (handle, err, chunk)
            if err then
                error(err)
            elseif chunk then
                err_chunks[#err_chunks+1] = chunk
            else
                vim.schedule(function ()
                    vim.notify(table.concat(err_chunks), vim.log.levels.INFO)
                end)
                handle:close()
            end
        end,
    })
end

return M
