local M = {}

---@class project.ProjectClass
---@field workspace_paths string Single path containing wildcards ("*") which when evaluated gives directories of project workareas.
---@field workspace_filters string[] List of patterns for matching project workspaces/workareas. Workspace names are created from the first match group. If not supplied, defaults to non-hidden directories.
---@field project_name? string Project name
---@field project_name_extr? string Pattern for finding projects based on matched project paths. Project names are created from the first match group.
---@field project_type string Project type. This should be the name of a lua module containing a project setup function
---@field project_opts table Extra project options (specific to project type) which are passed to the project setup function

---@class project.SetupOpts
---@field search_paths project.ProjectClass[]
M.opts = {
    search_paths = {
        {
            workspace_paths = "$HOME/files/programming/*",
            project_name = "Programming",
            project_type = "default",
            project_opts = { },
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

    for workspace_path in require("utils").scan(proj_class.workspace_paths, function(name, ftype)
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

        if proj_class.project_name then
            workspace.proj = proj_class.project_name
        else
            workspace.proj = workspace_path:match(proj_class.project_name_extr)
        end

        -- only include workspaces that pass the filters (if they exist)
        if proj_class.workspace_filters then
            local matched
            for _, filter in pairs(proj_class.workspace_filters) do
                -- TODO: This passes if a single filter matches (OR-like). Is this expected
                -- behaviour or should it be AND-like or even configurable?
                workspace.disp = workspace_path:match(filter)

                if workspace.disp then
                    break
                end
            end
        else
            -- By default match non-hidden paths
            workspace.disp = workspace_path:match("/([^.][^/]+)$")
        end

        -- Only add workspace if there was a match
        if workspace.disp then
            workspace.dir = workspace_path
            workspace.type = proj_class.project_type
            workspace.opts = proj_class.project_opts

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
            workspaces[workspace.disp] = workspace
        end
    end

    local t_end = vim.uv.hrtime()
    vim.notify(string.format("Took %.2fms scanning all projects", (t_end - t_start) / 1000000))

    return projects
end

-- TODO: Should this be replaced by some kind of callback/init parameter in the opts so that
-- individual project modules aren't needed? Need to consider how to share common code/setup and
-- where this would be stored and how it would be shared between machines.
M.load_workarea = function (workarea)
    local status, err = pcall(require("projects." .. workarea.type).load_workarea, workarea)
    local proj = table.concat({workarea.proj, " (", workarea.disp, ")"})

    if status then
        vim.notify("Loaded project settings for: " .. proj, vim.log.levels.INFO)
    else
        vim.notify("Failed to load project " .. proj .. " of project type " .. workarea.type, vim.log.levels.ERROR)
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

        -- Get a list of workarea names
        local workarea_names = {}
        for k, _ in pairs(workareas) do
            workarea_names[#workarea_names+1] = k
        end
        table.sort(workarea_names)

        -- TODO: Maybe add an option for adding a new workarea?

        -- Automatically select workarea if only 1 exists
        if #workarea_names == 1 then
            M.load_workarea(workareas[workarea_names[1]])
            return
        end

        local win = require("popup").list(" Workarea: ", workarea_names, function(workarea_idx)
            -- Get workarea information
            local workarea = workareas[workarea_names[workarea_idx]]

            M.load_workarea(workarea)
        end)

        return win
    end)
end

return M
