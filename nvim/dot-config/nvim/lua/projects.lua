local M = {}

---@class project.ProjectClass
---@field dir string Single path containing wildcards ("*") which when evaluated gives directories of project workareas.
---@field filters string[] List of patterns for matching project workspaces/workareas. Workspace names are created from the first match group.
---@field name? string Project name
---@field name_extr? string Pattern for finding projects based on matched project paths. Project names are created from the first match group.
---@field type string Project type. This should be the name of a lua module containing a project setup function
---@field opts? table Extra project options (specific to project type) which are passed to the project setup function

---@class project.SetupOpts
---@field search_paths project.ProjectClass[]
M.opts = {
    search_paths = {
        {
            dir = os.getenv("HOME") .. "/Documents/*",
            filters = {"/([^.][^/]*)$"},
            name = "Documents",
            type = "default",
            opts = { },
        },
    },
}

---@param opts? project.SetupOpts
M.setup = function (opts)
    if opts == nil then
        return
    end

    for k, v in pairs(opts) do
        M.opts[k] = v
    end
end

local scan_project = function (proj_class)
    local workspaces = {}

    for dir in require("utils").scan(proj_class.dir, function(name, ftype)
        if ftype == "directory" then
            return true
        elseif ftype == nil then
            local res = vim.uv.fs_stat(name)
            if res ~= nil and res ~= "fail" then
                if res.type == "directory" then return true end
            end
        end
        return false
    end) do
        ---@class project.Workspace
        ---@field disp string Workspace display name
        ---@field proj string Project name
        ---@field dir string Workspace directory
        ---@field type string Project type
        ---@field opts table Project opts
        local workspace = {}

        if proj_class.name then
            workspace.proj = proj_class.name
        else
            workspace.proj = dir:match(proj_class.name_extr)
        end

        -- only include workspaces that pass the filters (if they exist)
        local cont = true
        if proj_class.filters then
            for _, filter in pairs(proj_class.filters) do
                workspace.disp = dir:match(filter)

                -- Only add a workspace if there was a match
                if workspace.disp then
                    cont = false
                end
            end
        else
            workspace.disp = dir:match(".*/(.*)$")
        end

        if not cont then
            workspace.dir = dir
            workspace.type = proj_class.type
            workspace.opts = proj_class.opts

            table.insert(workspaces, workspace)
        end
    end

    return workspaces
end

M.get_projects = function ()
    local t_start = vim.uv.hrtime()
    local projects = {}
    for _, proj_class in pairs(M.opts.search_paths) do
        for _, workspace in pairs(scan_project(proj_class)) do
            -- Create the table of workspaces if it doesn't exist
            projects[workspace.proj] = projects[workspace.proj] or {}

            -- Add the workspace to the list of workspaces. Works because workspaces is a reference
            local workspaces = projects[workspace.proj]
            workspaces[#workspaces+1] = workspace
        end
    end

    local t_end = vim.uv.hrtime()
    vim.notify(string.format("Took %.2fms scanning all projects", (t_end - t_start) / 1000000))

    return projects
end

M.load_workarea = function (workarea)
    local status, err = pcall(require("projects." .. workarea.type).load_workarea, workarea)

    if status then
        vim.notify("Loaded project settings for " .. workarea.disp, vim.log.levels.INFO)
    else
        vim.notify("Failed to load workarea " .. workarea.disp .. " of project type " .. workarea.type, vim.log.levels.ERROR)
        vim.notify(err, vim.log.levels.DEBUG)
    end
end

M.choose_project = function ()
    local projects = M.get_projects()

    -- Get sorted list of project names
    local project_names = {}
    for k, _ in pairs(projects) do
        project_names[#project_names+1] = k
    end
    table.sort(project_names)

    require("popup").list(" Project: ", project_names, function (proj_idx)
        -- Get workareas for selected project
        local workareas = projects[project_names[proj_idx]]

        -- Automatically select workarea if only 1 exists
        -- TODO: Maybe add an option for adding a new workarea?
        if #workareas == 1 then
            M.load_workarea(workareas[1])
            return
        end

        -- Get a list of workareanames (already seems to be sorted hence ipairs)
        local workarea_names = {}
        for _, v in ipairs(workareas) do
            workarea_names[#workarea_names+1] = v.disp
        end

        local win = require("popup").list(" Workarea: ", workarea_names, function(workarea_idx)
            -- Get workarea information
            local workarea = workareas[workarea_idx]

            M.load_workarea(workarea)
        end)

        return win
    end)
end

return M
