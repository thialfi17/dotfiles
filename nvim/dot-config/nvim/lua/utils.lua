local M = {}

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
