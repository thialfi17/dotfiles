-- Needs to be loaded before functions inside are referenced elsewhere, so put at the top
require("win.smart_rules")

-- Options: {{{
-- NOTE: vim.opt is soft deprecated and is slated to be removed at _some_ point
-- in the future

-- Set window title to Neovim title
vim.o.title = true

-- Set GUI font
vim.o.guifont = "JetBrainsMono Nerd Font, DejaVu Sans Mono, Courier New:h13"

-- Open man pages in vertical window
vim.g.ft_man_open_mode = "vert"

vim.o.tabline = "%!v:lua.Tabline()"

-- Make sure to use a dark background
vim.o.background = "dark"

-- Set language for spelling to British English
vim.o.spelllang = "en_gb"

-- Show line numbers
vim.o.number = true
-- Show relative line numbers
vim.o.relativenumber = true

-- Set usage of mouse for everything (defaults to 'nvi' so this only enables in Command-line mode)
vim.o.mouse = "a"

-- Don't show the mode, since it's already in status line
vim.o.showmode = false

-- Line Wrapping: {{{

vim.o.wrap = false

-- Set wrapping to occur at the characters specified by 'breakat' not last character on screen
vim.o.linebreak = true
vim.o.breakat = "\t ;?,:"

-- Set characters used to indicate that a line has been wrapped
vim.o.showbreak = "↳ "

-- Wrapped lines begin at same indentation as the line they came from
vim.o.breakindent = true

-- }}} Line Wrapping

-- Automatically expand tabs to spaces and set indent to use 4 spaces by default
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

-- Allow moving/editing past the end of the line
vim.o.virtualedit = "all"

-- Make the default preview window size bigger
vim.o.previewheight = 30

-- Enable persistent undos
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = false
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = "yes"

-- Decrease update time
--vim.o.updatetime = 250
--vim.o.timeoutlen = 300

-- Change how split windows are placed. This places the new window to the right or below the existing window
vim.o.splitright = true
vim.o.splitbelow = true

-- Enable showing tabs and extra spaces
vim.o.list = true

-- Configure characters to display for the following items
vim.o.listchars = "tab:——▶,trail:␣,extends:→,precedes:←,nbsp:⍽,conceal:·"

-- Enable menu for completing command line
vim.o.wildmenu = true

-- Ignore case for completing file names and directories
vim.o.wildignorecase = true

-- Autocomplete to longest match and then list all the remaining matches
vim.o.wildmode = "longest:full,full"

-- Preview substitutions live, as you type!
vim.o.inccommand = "split"

-- Show which line your cursor is on
vim.o.cursorline = true

vim.o.colorcolumn = "100,120"

-- Scroll before the end of the screen in any direction
vim.opt.scrolloff = 10
vim.o.sidescrolloff = 2
-- Scroll by X characters when moving of the edge of the screen
vim.o.sidescroll = 10

-- Always show the tabline
vim.o.showtabline = 2

-- Change default grep arguments for built in :grep searches to support extended regex
if vim.o.grepprg:match("^grep") then
    vim.o.grepprg = "grep -nEIH $* /dev/null"
    -- Not changed just set to ensure it's correct for 'grepprg'
    vim.o.grepformat = "%f:%l:%m,%f:%l%m,%f  %l%m"
end
-- Change default rg arguments for built in :grep searches to follow symlinks
if vim.o.grepprg:match("^rg") then
    vim.o.grepprg = "rg --vimgrep -uu -L"
    -- Not changed just set to ensure it's correct for 'grepprg'
    vim.o.grepformat = "%f:%l:%c:%m"
end

-- Highlight search results
vim.o.hlsearch = true

-- }}} Options

-- Functions: {{{

---@param file string
---@param rules win.SmartRules
OpenFile = function (file, rules)
    -- Look for file in path
    local found = vim.fn.findfile(file)
    if found ~= "" then
        -- findfile returns string[] only when count is -ve
        ---@diagnostic disable-next-line: cast-local-type
        file = found
    end

    -- Find buffer, if it exists for the file
    local buf = vim.fn.bufnr("^" .. file .. "$")

    -- Open a window with the buffer according to the provided rules
    local loaded, _ = require("win.smart").open(buf, rules)

    -- If buffer didn't exist then we need to open it
    if loaded and buf == -1 then
        vim.cmd("find " .. file)
    end
end

-- }}} Functions

-- Mappings: {{{
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = "\\"
vim.g.maplocalleader = " "

-- General Mappings: {{{

-- Remove highlighting from search
vim.keymap.set("n", "<leader>n", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- Terminal-mode escape
vim.keymap.set({ "t" }, "<C-\\><C-\\>", [[<C-\><C-n>]], { desc = "Escape terminal mode" })
vim.keymap.set({ "t" }, "<Esc><Esc>", "<C-\\><C-n>", { desc = "Escape terminal mode" })

-- Remove trailing whitespace on current line
vim.keymap.set(
    { "n" },
    "<localleader>r<space>",
    [[m':.s/\s\+$//e<CR>`']],
    { desc = "Remove trailing whitespace on current line" , silent = true }
)

-- Add zz at the end of search movement commands to center after moving
vim.keymap.set({ "n" }, "n", [[nzz]], { silent = true })
vim.keymap.set({ "n" }, "N", [[Nzz]], { silent = true })

-- One-off cmd in terminal mode {{{
vim.keymap.set({ "t" }, "<C-w>:", function()
    local win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_get_current_buf()
    local group = vim.api.nvim_create_augroup("term_cmd", { clear = true })

    vim.api.nvim_create_autocmd(
        "CmdlineLeave",
        {
            desc = "Handle leaving the cmdwin when entered via <C-w>:",
            group = group,
            once = true,
            callback = function()
                -- Exit insert mode if we entered another window
                vim.api.nvim_create_autocmd(
                    "WinEnter",
                    {
                        desc = "Exit insert mode when command resulted in entering a different window",
                        group = group,
                        once = true,
                        callback = function()
                            if vim.api.nvim_get_current_win() ~= win then
                                vim.cmd("stopinsert")
                            end
                        end,
                    }
                )
                -- Exit insert mode if we entered another buffer
                vim.api.nvim_create_autocmd(
                    "BufEnter",
                    {
                        desc = "Exit insert mode when command resulted in entering a different window",
                        group = group,
                        once = true,
                        callback = function()
                            if vim.api.nvim_get_current_buf() ~= buf then
                                vim.cmd("stopinsert")
                            end
                        end,
                    }
                )

                -- Delete the "WinEnter" autocmd if it didn't fire after
                -- 1000ms. Timeout here should be adjusted to user preference.
                -- My mappings to change window exit insert mode anyway so long
                -- timeout doesn't matter to me.
                vim.defer_fn(function()
                    vim.api.nvim_clear_autocmds({group = group})
                end, 1000)
            end,
        }
    )

    vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes("<C-\\><C-o>:", true, false, true),
        "nt", -- Do not remap and handle as if they were typed
        false -- Don't replace special stuff since we did that already
    )
end)
-- }}}

vim.keymap.set({ "n" }, "j", "gj", {})
vim.keymap.set({ "n" }, "k", "gk", {})

vim.keymap.set({ "n" }, "<Leader>cl", "<CMD>set cursorline!<CR>", { desc = "Toggle cursorline" })
vim.keymap.set({ "n" }, "<Leader>cc", "<CMD>set cursorcolumn!<CR>", { desc = "Toggle cursorcolumn" })
vim.keymap.set({ "n" }, "<Leader>cb", "<CMD>set cursorline! cursorcolumn!<CR>", { desc = "Toggle cursorline and cursorcolumn" })

vim.keymap.set({ "n" }, "<Leader>m", "m'yiw:<C-u>%s/\\<<C-r>\"\\>//gn<CR>`':nohl<CR>", { desc = "Count occurrences of word", silent = true })

-- }}} General Mappings

-- Window/Tab Navigation: {{{

vim.keymap.set({ "n", "t" }, "<M-h>", "<CMD>wincmd h<CR>", {})
vim.keymap.set({ "n", "t" }, "<M-j>", "<CMD>wincmd j<CR>", {})
vim.keymap.set({ "n", "t" }, "<M-k>", "<CMD>wincmd k<CR>", {})
vim.keymap.set({ "n", "t" }, "<M-l>", "<CMD>wincmd l<CR>", {})

vim.keymap.set({ "n", "t" }, "<M-1>", "<CMD>1tabnext<CR>", {})
vim.keymap.set({ "n", "t" }, "<M-2>", "<CMD>2tabnext<CR>", {})
vim.keymap.set({ "n", "t" }, "<M-3>", "<CMD>3tabnext<CR>", {})
vim.keymap.set({ "n", "t" }, "<M-4>", "<CMD>4tabnext<CR>", {})
vim.keymap.set({ "n", "t" }, "<M-5>", "<CMD>5tabnext<CR>", {})
vim.keymap.set({ "n", "t" }, "<M-6>", "<CMD>6tabnext<CR>", {})
vim.keymap.set({ "n", "t" }, "<M-7>", "<CMD>7tabnext<CR>", {})
vim.keymap.set({ "n", "t" }, "<M-8>", "<CMD>8tabnext<CR>", {})
vim.keymap.set({ "n", "t" }, "<M-9>", "<CMD>9tabnext<CR>", {})
vim.keymap.set({ "n", "t" }, "<M-0>", "<CMD>10tabnext<CR>", {})

require("win.blocking").setup({
    additional_mappings_to_overwrite = {
        n = {
            "<M-h>", "<M-j>", "<M-k>", "<M-l>",
        },
        t = {
            "<M-h>", "<M-j>", "<M-k>", "<M-l>",
        },
    },
})

-- }}} Window/Tab Navigation

-- Function Key Mappings: {{{

-- Open configuration file
vim.keymap.set({ "n", "t" }, "<F4>", function() OpenFile("$MYVIMRC", {CurrentTab, FirstTab, FirstEmptyTab, NewTab}) end)

-- }}} Function Key Mappings

-- }}} Mappings

-- Abbreviations: {{{

vim.keymap.set({ "ca" }, "vfind", "vert sfind", {})
vim.keymap.set({ "ca" }, "vterm", "vert term", {})
vim.keymap.set({ "ca" }, "help", "vert help", {})

-- Make :ln behave line :cn. Replaces :ln[oremap]
vim.keymap.set({ "ca" }, "ln", "lnext", {})

-- }}}

-- Autocommands: {{{

local dont_restore_fts = {
    "gitcommit",
    "gitrebase",
}
vim.api.nvim_create_autocmd("BufWinEnter", {
    desc = "Restore previous cursor position when loading a file",
    callback = function()
        -- Skip listed filetypes
        for _, k in pairs(dont_restore_fts) do
            if vim.o.filetype == k then
                return
            end
        end

        local pos = vim.pos.mark(0, unpack(vim.api.nvim_buf_get_mark(0, '"')))
        local max_rows = vim.api.nvim_buf_line_count(0) - 1

        if pos.row > max_rows then
            return
        end

        vim.api.nvim_win_set_cursor(0, pos:to_cursor())
        vim.cmd("norm! zv")

        if pos.row == vim.api.nvim_buf_line_count(0) - 1 then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-e>", true, false, true), "n", false)
        else
        vim.cmd("norm! zz")
        end
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "directory",
    desc = "Make directory buffers unlisted",
    group = vim.api.nvim_create_augroup("config-filetype-directory", { clear = true }),
    callback = function()
        vim.bo.buflisted = false
    end,
})

-- Show highlighted region briefly
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking text",
    group = vim.api.nvim_create_augroup("config-highlight-yank", { clear = true }),
    callback = function()
        vim.hl.hl_op()
    end,
})

vim.api.nvim_create_autocmd({ "VimResized", "WinNew" }, {
    desc = "Resize windows",
    group = vim.api.nvim_create_augroup("config-resize-windows", { clear = true }),
    command = "wincmd =",
})

vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
    desc = "Only enter insert mode in terminal windows if the job is still running",
    group = vim.api.nvim_create_augroup("config-term-windows", { clear = true }),
    pattern = { "term://*" },
    callback = function()
        -- Returns -1 on timeout i.e. if job is still running
        if vim.fn.jobwait({vim.o.channel}, 0)[1] == -1 then
            vim.cmd[[ startinsert ]]
        end
    end,
})

-- For terminals opened with no args automatically closing, see *default-autocmds*
vim.api.nvim_create_autocmd({ "TermClose" }, {
    desc = "Exit insert mode when terminal job finishes. Prevents accidentally closing the window.",
    group = vim.api.nvim_create_augroup("config-term-windows", { clear = false }),
    command = "stopinsert",
})

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
    desc = "Setup highlight groups for custom tabline",
    group = vim.api.nvim_create_augroup("config-colorscheme-tabline", { clear = true }),
    callback = function()
        local hl_tab_line = vim.api.nvim_get_hl(0, { create = false, name = "TabLine" })
        local hl_tab_line_sel = vim.api.nvim_get_hl(0, { create = false, name = "TabLineSel" })

        hl_tab_line_sel.bg = hl_tab_line.bg
        hl_tab_line_sel.ctermbg = hl_tab_line.ctermbg

        vim.api.nvim_set_hl(0, "TabLineSel", hl_tab_line_sel)
        --vim.api.nvim_set_hl(0, "TabNum", hl_tab_line)
        --vim.api.nvim_set_hl(0, "TabNumSel", hl_tab_line_sel)
    end,
})

-- }}} Autocommands

-- Commands: {{{

vim.api.nvim_create_user_command("Syn", function()
    assert(vim.fn.synstack)
    for _, id in ipairs(vim.fn.synstack(vim.fn.line("."), vim.fn.col("."))) do
        print(vim.fn.synIDattr(id, "name"))
    end
end, { desc = "Show the syntax highlighting groups under the cursor" })

-- DiffOrig {{{
-- Open the file in a scratch buffer and perform a live diff against the file on the disk
vim.api.nvim_create_user_command("DiffOrig", function ()
    local ft = vim.api.nvim_get_option_value("filetype", {})
    local file = vim.api.nvim_buf_get_name(0)

    local loaded, win
    require("scratch").open("diff://" .. file, {
        buf_opts = {
            ft = ft,
        },
        open_fun = function (buf)
            loaded, win = require("win.smart").open(buf, { CurrentTab, ReplaceRightSplit, SplitIfBiggerThan }, {
                focus = false,
            })
        end,
    })

    if loaded == false then return end

    local buf = vim.api.nvim_win_get_buf(win)

    do
        local lines = vim.fn.readfile(file)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    end

    vim.api.nvim_win_call(win, function() vim.cmd("diffthis") end)
    vim.cmd("diffthis")

    vim.keymap.set({ "n" }, "<F5>", function ()
        local lines = vim.fn.readfile(file)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    end, { desc = "Reload the file from disc" })
end, {})
-- }}} DiffOrig

-- Shell Commands: {{{

vim.api.nvim_create_user_command(
    "R",
    function (opts)
        require("command").run(opts.args)
    end,
    {
        nargs = "+",
        complete = require("user_command").gen_command_complete("R"),
        desc = "Run a shell command asynchronously",
    }
)

local add_shell_command = function (cmd, rules, desc)
    vim.api.nvim_create_user_command(
        cmd,
        function (opts)
            require("command").run_smart(opts.args, {
                win_rules = rules,
                win_opts = { focus = not opts.bang },
            })
        end,
        {
            nargs = "+",
            bang = true,
            complete = require("user_command").gen_command_complete(cmd),
            desc = desc,
        }
    )
end

add_shell_command("RR", { CurrentTab, Replace }, "Run a shell command and open the results in the current (or existing) window")
add_shell_command("RS", { CurrentTab, SplitIfBiggerThan, VertSplit }, "Run a shell command and put the results in a new split")
add_shell_command("RRS", { CurrentTab, ReplaceRightSplit, SplitIfBiggerThan, VertSplit }, "Run a shell command and put the results in a window on the right")
add_shell_command("RT", { CurrentTab, FirstTab, SplitIfBiggerThan, NewTab }, "Run a shell command and go to existing window, put the results in a split if there is room or in a new tab")

-- }}} Shell Commands

vim.api.nvim_create_user_command("G", function (args)
    require("grep").grep(args, {
        cmd = "rg",
        efm = "%f:%l:%c:%m",
        default_flags = {"--vimgrep", "-LHn"},
        default_recurse_flag = "", -- rg is always recursive when a folder is given
    })
end, {
    nargs = "+",
    bang = true,
    complete = "file",
})

-- Not really needed
vim.api.nvim_create_user_command("UnloadLua", [[
    for name in map(filter(getbufinfo({"bufloaded": 1}), 'match(v:val.name, ".lua$") != -1'), 'fnameescape(v:val.name)')
        exec "bwipeout" name
    endfor
]], {
    nargs = 0,
})

-- }}} Commands

-- File Finding and Editing: {{{

-- Mappings: {{{

-- ":find" searches for the given file in all directories given in 'path'
vim.keymap.set({ "n" }, "<Leader>f", ":find<Space>", { desc = "Find a file" })

-- List buffers and prefill command line for switching to one
vim.keymap.set(
    { "n" },
    "<Leader>b",
    "<Cmd>buffers<CR>:buffer<Space>",
    { desc = "List and switch to a buffer" }
)

-- Shortcut for editing a file since I got used to "<Leader>f"
vim.keymap.set({ "n" }, "<Leader>e", ":e<Space>", { desc = "Edit a file" })
-- Edit a file in the same directory as the current file
vim.keymap.set({ "n" }, "<Leader>E", function()
    return table.concat({ ":e ", vim.fn.expand("%:p:h"), "/" })
end, { desc = "Edit a file", expr = true })

-- }}} Mappings

-- Options: {{{

-- The 'suffixes' option allows selecting file types to de-prioritise from ":find" results
-- De-prioritise directory results
vim.opt.suffixes:append(",")

-- Change what is considered part of a filename
vim.opt.isfname:remove(":")
vim.opt.isfname:remove(",")

-- Suffixes to add when searching for a file with "gf" etc.
-- Buffer local setting so doesn't update when changed in a running session
--vim.opt.suffixesadd:append("")

-- File types to remove from wildcard expansion and ":find" results
--vim.opt.wildignore:append("*.ignore")

-- Change the paths searched when using ":find"
--vim.opt.path:append("/usr/include")

-- }}} Options

-- }}} File Finding and Editing

-- Custom Tabline: {{{

function Tabline()
    local elements = {}
    local cur_tabpage = vim.api.nvim_get_current_tabpage()
    local tabpage_list = vim.api.nvim_list_tabpages()

    for i, tabpage in ipairs(tabpage_list) do
        local wins_list = vim.api.nvim_tabpage_list_wins(tabpage)
        local num_wins = #wins_list

        -- Format the filename
        local win_id = vim.api.nvim_tabpage_get_win(tabpage)
        local buf_id = vim.api.nvim_win_get_buf(win_id)
        local buf_type = vim.api.nvim_get_option_value("buftype", { buf = buf_id })
        local fname = vim.api.nvim_buf_get_name(buf_id)

        local prefix = ""
        local body = ""
        local suffix = ""

        if buf_type == "help" then
            body = "help:" .. vim.fn.fnamemodify(fname, ":t")
        elseif buf_type == "quickfix" then
            body = "Quickfix"
        elseif buf_type == "nofile" then
            if string.match(fname, "://") then
                prefix = string.match(fname, "^.*://")
                body = string.match(fname, "^.*://(.*)")
            else
                body = vim.fn.fnamemodify(fname, ":~:.")
            end
        else -- Normal file
            if fname == "" then
                body = "[No Name]"
            else
                prefix = vim.fn.fnamemodify(fname, ":~:.:h:p")
                body = vim.fn.fnamemodify(fname, ":t")
            end

            -- Attempt to replace absolute path with relative path
            if string.match(prefix, "^/") then
                local potential_replacement = ""

                local cwd = vim.uv.cwd() or ""
                local cwd_parts = vim.split(cwd, "/", { trimempty = true })
                local path_parts = vim.split(prefix, "/", { trimempty = true })

                local part = 1
                while cwd_parts[part] == path_parts[part] do
                    part = part + 1
                end

                local filler = {}
                for _ = part, #path_parts, 1 do
                    table.insert(filler, "..")
                end
                table.insert(filler, "")

                potential_replacement = table.concat(filler, "/")
                potential_replacement = potential_replacement .. table.concat(path_parts, "/", part)

                if #potential_replacement < #prefix then
                    prefix = potential_replacement
                end
            end

            if #prefix + #body > 25 then
                prefix = "##"
            end

            if prefix == "." then
                prefix = ""
            elseif prefix ~= "" then
                prefix = prefix .. "/"
            end
        end

        -- Default file name for e.g. new files
        if body == "" then
            body = "[No Name]"
        end

        -- Handle the suffix (things like window count)
        local suffix_parts = {}

        -- Show if current buffer has been modified
        if vim.api.nvim_get_option_value("modified", { buf = buf_id }) then
            table.insert(suffix_parts, "*")
        end

        -- Seperately show if any other windows in the tab have been modified
        local modified = ""
        for _, win in pairs(wins_list) do
            local buf = vim.api.nvim_win_get_buf(win)
            local skip = false
            if buf == buf_id then
                skip = true
            end
            if not skip and vim.api.nvim_get_option_value("modified", { buf = buf }) then
                modified = "*"
                break
            end
        end

        -- Form suffix
        if num_wins > 1 then
            table.insert(suffix_parts, " ")
            table.insert(suffix_parts, "(")
            table.insert(suffix_parts, vim.api.nvim_win_get_number(win_id))
            table.insert(suffix_parts, "/")
            table.insert(suffix_parts, num_wins)
            table.insert(suffix_parts, modified)
            table.insert(suffix_parts, ")")
        end
        suffix = table.concat(suffix_parts, "")

        ------------------------------
        -- Form the tabline
        ------------------------------

        -- Start clickable region for selecting tab
        table.insert(elements, "%" .. i .. "T")

        -- Set highlight group?
        if tabpage == cur_tabpage then
            table.insert(elements, "%#TabLineSel#")
        else
            table.insert(elements, "%#TabLine#")
        end

        -- Add tab number
        table.insert(elements, " ")
        table.insert(elements, i)
        table.insert(elements, " ")

        -- Add file path
        table.insert(elements, "%#TabLine#")
        table.insert(elements, prefix)

        -- Colour the file name differently depending on if it is the current tab
        if tabpage == cur_tabpage then
            table.insert(elements, "%#TabLineSel#")
        else
            table.insert(elements, "%#TabLine#")
        end

        -- Add the file name
        table.insert(elements, body)

        -- Fill remaining items such as separators with normal (not active) colours
        table.insert(elements, "%#TabLine#")

        -- Add the suffix
        table.insert(elements, suffix)

        -- End clickable region for selecting tab
        table.insert(elements, "%T")

        -- if last tab page
        if i == #tabpage_list then
            if #tabpage_list > 1 then
                -- Add close tab page button
                -- %= right aligns and %999X makes a "close current tab" clickable region
                table.insert(elements, "%=%999XX")
            end
        else
            -- Insert seperator between tab pages
            table.insert(elements, " |")
        end
    end
    return table.concat(elements)
end

-- }}}

-- Plugins: {{{

-- Builtin: {{{

vim.cmd[[ packadd! cfilter ]]
vim.cmd[[ packadd! matchit ]]

-- }}}

-- Mine: {{{

if require("utils").is_module_available("local") then require("local") end

vim.keymap.set({"n"}, "<F1>", require("projects").choose_project, {})

-- TODO: Add completions for other shells, maybe make it possible to
-- automatically detect shell in use?
require("user_command").setup({
    cmd = vim.fn.stdpath("config") .. "/scripts/bash_complete",
})

vim.keymap.set({"n", "t"}, "<M-z>", require("zenmode").toggle, {})
vim.keymap.set({"n", "t"}, "<M-S-z>", function() require("zenmode").toggle({show_tabline = true, show_statusline = false}) end, {})

-- }}} Mine

-- Install and Configure Plugins: {{{
local gh = function(x) return 'https://github.com/' .. x end
vim.pack.add({
    { src = gh("tpope/vim-sleuth") },
    { src = gh("lewis6991/gitsigns.nvim") },
    -- { src = gh("lewis6991/async.nvim") },
    { src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },
})

-- GitSigns Configuration: {{{
require("gitsigns").setup({
    current_line_blame = true,
})

vim.keymap.set("n", "]c", function()
    if vim.o.diff then
        vim.cmd[[ norm! ]c ]]
    end
    require("gitsigns").nav_hunk("next")
end, { desc = "Jump to next hunk", })

vim.keymap.set("n", "[c", function()
    if vim.o.diff then
        vim.cmd[[ norm! [c ]]
    end
    require("gitsigns").nav_hunk("prev")
end, { desc = "Jump to next hunk", })
-- }}} GitSigns Configuration

-- nvim-treesitter Configuration: {{{
local nvim_treesitter_installed = vim.o.runtimepath:match("nvim%-treesitter")

local ts_available = {}

if nvim_treesitter_installed then
    -- Mark available all the languages that are unstable or better
    ts_available = require("nvim-treesitter").get_available(2)
end

vim.api.nvim_create_autocmd('FileType', {
    pattern = "*",
    desc = "Start tree-sitter highlighting for all filetypes",
    group = vim.api.nvim_create_augroup("config-treesitter-start", { clear = true }),
    callback = function(ev)
        -- ev.match is the filetype
        if ev.match == "" then
            vim.treesitter.stop()
            return
        end

        local installed
        local lang_for_ft = vim.treesitter.language.get_lang(ev.match)
        local parser_lib = lang_for_ft .. ".so"
        local installed_parsers = vim.api.nvim_get_runtime_file('parser/*', true)

        for _, parser in pairs(installed_parsers) do
            installed = installed or parser:match(parser_lib)
        end

        if installed then
            -- Need to re-enable to make sure it triggers the new language
            vim.treesitter.start()
            return
        end

        -- Scan available languages and try installing if it's available
        local matched_lang
        for _, lang in pairs(ts_available) do
            if lang == lang_for_ft then
                matched_lang = lang
            end
        end

        if matched_lang then
            vim.print("Parser available for language, attempting to install...")
            -- Goal was to make this plugin agnostic but doesn't seem like it will be easily
            -- possible
            if nvim_treesitter_installed then
                local ret = require("nvim-treesitter.async").arun(function()
                    local task = require("nvim-treesitter").install(matched_lang)
                    local ret = require("nvim-treesitter.async").await(task)
                    if ret then
                        -- Needed here to prevent triggering until after install is complete
                        vim.print("Installed parser with nvim-treesitter. Enabling...")
                        vim.treesitter.start()
                    end
                    return ret
                end)
                -- Doesn't work due to lack of wait/await above. Cannot get that to work
                -- asynchronously though
                if ret then return true end
            end
        end

        vim.print("Parser could not be installed for '" .. lang_for_ft .. " (" .. ev.match .. ")".. "'. Disabling tree-sitter...")
        vim.treesitter.stop()
    end,
})
-- }}} nvim-treesitter Configuration

-- }}} Install and Configure Plugins

-- }}} Plugins

vim.cmd[[ colorscheme retrobox ]]

-- vim: fdm=marker
