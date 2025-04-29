local M = {}

--- Check if module is available in the search paths.
---
--- Taken from: https://stackoverflow.com/a/15434737
--- License: https://creativecommons.org/licenses/by-sa/3.0/
--- See https://www.lua.org/manual/5.1/manual.html#pdf-require
---@param module string
---@return boolean
M.is_module_available = function (module)
    if package.loaded[module] then
        return true
    else
        for _, searcher in ipairs(package.loaders) do
            local loader = searcher(module)
            if type(loader) == "function" then
                package.preload[module] = loader
                return true
            end
        end
        return false
    end
end

--- Function to parse args passed to a user command and split them based on
--- quotes
---@param cmd string Command as received on the commandline
---@return string[] parts Command split into reasonable chunks based on whitespace and quotes
M.split_command = function (cmd)
    -- Output chunks
    local parts = {}
    -- Which output chunk
    local i = 1
    -- Previous delimiter
    local delim = ""
    -- Previous char
    local p = ""

    for c in cmd:gmatch(".") do
        -- Ensure there is somewhere to put chars in new chunk
        if #parts < i then
            parts[i] = {}
        end

        -- if not escaping and (closing chunk or opening new chunk (delim or space))
        if p ~= "\\" and (c == delim or (delim == "" and (c == '"' or c == '`' or c == "'" or c == " "))) then
            local inc = 0

            -- If chunk is not empty then we must be moving to to a new chunk
            -- this could be due to a space so delim may not be set
            if #(parts[i]) ~= 0 then
                inc = 1
            end

            if c == delim then -- closing delimiter
                delim = ""
                -- TODO: At some point this was included so presumably it was
                -- needed, but it breaks when used with command running.
                --
                -- Add delimiter to output
                --table.insert(parts[i], c)
            else -- opening new chunk due to delim or space
                if c ~= " " then
                    delim = c
                end

                -- inc would be zero due to quotes after space
                if inc > 0 then
                    table.insert(parts, {})
                end

                -- TODO: At some point this was included so presumably it was
                -- needed, but it breaks when used with command running.
                --
                -- Add delimiter to output but not spaces
                --if delim ~= "" then
                --    table.insert(parts[i+inc], c)
                --end
            end
            i = i + inc
        else
            table.insert(parts[i], c)
        end
        p = c
    end

    -- Do all concats in one go to avoid lots of individual calls. Supposedly
    -- this is better for performance.
    local res = {}
    for _, v in ipairs(parts) do
        table.insert(res, table.concat(v))
    end

    return res
end

---@param path string Path with optional wildcards to scan and generate a list of paths
---@param filter? fun(name: string, type: string):boolean Function used to filter path results based on item path and type
---@return nil|fun(): string
M.scan = function(path, filter)
    -- Replace multiple "*" with a single char to avoid repeats due to
    -- recursive nature of this function
    path = path:gsub("%*+", "*")

    local fun

    ---@diagnostic disable-next-line redefined-local
    fun = function (path, filter)
        -- Find the first *
        local _, e, path_start = path:find("([^%*]+)%*")

        -- If no '*'s then return the whole path
        if path_start == nil then
            -- Only return path if it exists
            if vim.uv.fs_stat(path) ~= nil then
                coroutine.yield(path)
            end
            return
        end

        -- Get the base directory of the pattern
        local base_dir = path_start:match("(.*/)")
        -- Get the prefix of the file/dir before the '*'
        local prefix = "^" .. path_start:match(".*/(.*)")
        -- Get the part of the path after the '*'
        local path_remaining = path:sub(e + 1)

        -- Check if base_dir exists - if not exit early
        if vim.uv.fs_stat(base_dir) == nil then
            error("Project base directory does not exist: " .. base_dir)
            return
        end

        -- Create the uv iterator and check it was created
        local dir_iter = vim.uv.fs_scandir(base_dir)

        if dir_iter == nil then
            error("Could not create iterator on directory")
            return
        end

        for name, ftype in vim.uv.fs_scandir_next, dir_iter, 0 do
            -- Check current result prefix matches
            if name:match(prefix) then
                local full_path = base_dir .. name
                -- Apply external filter if given
                if filter == nil or filter(full_path, ftype) then
                    -- If there's remaining stuff in the path then attempt to
                    -- parse any remaining wildcards
                    if path_remaining ~= "" then
                        fun(full_path .. path_remaining, filter)
                    else
                        -- If no remaining path then just return the current result
                        coroutine.yield(full_path)
                    end
                end
            end
        end
    end

    return coroutine.wrap(function() fun(path, filter) end)

    --[[

    This is the same as:

        local co = coroutine.create(function() fun(path, filter) end)
        -- iterator. Every time this is called, gets the next result until
        -- coroutine exits
        return function()
            local code, res = coroutine.resume(co)
            return res
        end

    --]]
end

return M
