-- Options: {{{
-- NOTE: vim.opt is soft deprecated and is slated to be removed at _some_ point
-- in the future

-- Set window title to Neovim title
vim.o.title = true

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

-- Change default grep arguments for built in grep searches
vim.o.grepprg = "grep -nE $* /dev/null"

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
        file = found
    end

    -- Find buffer, if it exists for the file
    local buf = vim.fn.bufnr("^" .. file .. "$")

    -- Open a window with the buffer according to the provided rules
    local loaded, win = require("win.smart").open(buf, rules)

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
    local group = vim.api.nvim_create_augroup("term_cmd", { clear = true })

    vim.api.nvim_create_autocmd(
        "CmdLineLeave",
        {
            desc = "Handle leaving the cmdwin when entered via <C-w>:",
            group = group,
            once = true,
            callback = function()
                -- Default to entering insert mode because we can't detect when
                -- we have re-entered the window we came from, but can detect
                -- when we have entered a different window.
                vim.cmd("startinsert")

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
        vim.api.nvim_replace_termcodes("<C-\\><C-n>:", true, false, true),
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

-- TODO:

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

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking text",
    group = vim.api.nvim_create_augroup("config-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd({ "VimResized", "WinNew" }, {
    desc = "Resize windows",
    group = vim.api.nvim_create_augroup("config-resize-windows", { clear = true }),
    pattern = { "" },
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
    pattern = { "" },
    command = "stopinsert",
})

-- }}} Autocommands

-- Commands: {{{

vim.api.nvim_create_user_command("Syn", function()
    assert(vim.fn.synstack)
    for _, id in ipairs(vim.fn.synstack(vim.fn.line("."), vim.fn.col("."))) do
        print(vim.fn.synIDattr(id, "name"))
    end
end, { desc = "Show the syntax highlighting groups under the cursor" })

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
        local file_type = vim.api.nvim_get_option_value("filetype", { buf = buf_id })
        local file_name = vim.api.nvim_buf_get_name(buf_id)

        local prefix = ""
        local body = ""
        local suffix = ""

        if file_type == "help" then
            body = "help:" .. vim.fn.fnamemodify(file_name, ":t")
        elseif file_type == "quickfix" then
            body = "Quickfix"
        elseif file_type == "nofile" then
            print("[TABLINE] File type is NOFILE")
        else -- Normal file
            prefix = vim.fn.fnamemodify(file_name, ":~:.:h:p")
            body = vim.fn.fnamemodify(file_name, ":t")

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
            else
                prefix = prefix .. "/"
            end
        end

        -- Default file name for e.g. new files
        if body == "" then
            body = "[No Name]"
        end

        -- Handle the suffix (things like window count)
        local suffix_parts = {}

        if vim.api.nvim_get_option_value("modified", { buf = buf_id }) then
            table.insert(suffix_parts, "*")
        end

        local modified = ""
        for _, win in pairs(wins_list) do
            local buf = vim.api.nvim_win_get_buf(win)
            if buf == buf_id then
                goto continue
            end
            if vim.api.nvim_get_option_value("modified", { buf = buf }) then
                modified = "*"
                break
            end
            ::continue::
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
--vim.cmd[[ packadd! matchit ]]

-- }}}

-- Mine: {{{

require("win.smart_rules")

vim.keymap.set({"n", "t"}, "<M-z>", require("zenmode").toggle, {})
vim.keymap.set({"n", "t"}, "<M-S-z>", function() require("zenmode").toggle({show_tabline = true, show_statusline = false}) end, {})

-- }}} Mine

-- Install Plugin Manager: {{{
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- }}} Install Plugin Manager

-- Install and Configure Plugins: {{{
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins, you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require("lazy").setup({
    -- This section is pretty much copied from kickstart.nvim
    --
    -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).

    -- NOTE: Plugins can also be added by using a table,
    -- with the first argument being the link and the following
    -- keys can be used to configure plugin behavior/loading/etc.
    --
    -- Use `opts = {}` to force a plugin to be loaded.
    --
    --  This is equivalent to:
    --    require('Comment').setup({})

    -- NOTE: Plugins can also be configured to run lua code when they are loaded.
    --
    -- This is often very useful to both group configuration, as well as handle
    -- lazy loading plugins that don't need to be loaded immediately at startup.
    --
    -- For example, in the following configuration, we use:
    --  event = 'VimEnter'
    --
    -- which loads which-key before all the UI elements are loaded. Events can be
    -- normal autocommands events (`:help autocmd-events`).
    --
    -- Then, because we use the `config` key, the configuration only runs
    -- after the plugin has been loaded:
    --  config = function() ... end

    -- NOTE: Plugins can specify dependencies.
    --
    -- The dependencies are proper plugin specifications as well - anything
    -- you do for a plugin at the top level, you can do for a dependency.
    --
    -- Use the `dependencies` key to specify the dependencies of a particular plugin

    "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically

    -- gitsigns: {{{
    { -- Adds git related signs to the gutter, as well as utilities for managing changes
        "lewis6991/gitsigns.nvim",
        opts = {
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
        },
    },
    -- }}} gitsigns

    -- WhichKey: {{{
    { -- Useful plugin to show you pending keybinds.
        "folke/which-key.nvim",
        event = "VimEnter", -- Sets the loading event to 'VimEnter'
        config = function() -- This is the function that runs, AFTER loading
            --require("which-key").setup()

            -- Document existing key chains
            require("which-key").add({
            })
        end,
    },
    -- }}} WhichKey

    -- LSP: {{{
    { -- LSP Configuration & Plugins
        "neovim/nvim-lspconfig",
        dependencies = {
            -- Useful status updates for LSP.
            -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
            { "j-hui/fidget.nvim", opts = {} },
        },
        config = function()
            --  This function gets run when an LSP attaches to a particular buffer.
            --    That is to say, every time a new file is opened that is associated with
            --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
            --    function will be executed to configure the current buffer
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
                callback = function(event)
                    -- NOTE: Remember that lua is a real programming language, and as such it is possible
                    -- to define small helper and utility functions so you don't have to repeat yourself
                    -- many times.
                    --
                    -- In this case, we create a func that lets us more easily define mappings specific
                    -- for LSP related items. It sets the mode, buffer and description for us each time.
                    local map = function(keys, func, desc)
                        vim.keymap.set(
                            "n",
                            keys,
                            func,
                            { buffer = event.buf, desc = "LSP: " .. desc }
                        )
                    end

                    -- -- Jump to the definition of the word under your cursor.
                    -- --  This is where a variable was first declared, or where a function is defined, etc.
                    -- --  To jump back, press <C-T>.
                    -- map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
                    --
                    -- -- Find references for the word under your cursor.
                    -- map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
                    --
                    -- -- Jump to the implementation of the word under your cursor.
                    -- --  Useful when your language has ways of declaring types without an actual implementation.
                    -- map(
                    --     "gI",
                    --     require("telescope.builtin").lsp_implementations,
                    --     "[G]oto [I]mplementation"
                    -- )
                    --
                    -- -- Jump to the type of the word under your cursor.
                    -- --  Useful when you're not sure what type a variable is and you want to see
                    -- --  the definition of its *type*, not where it was *defined*.
                    -- map(
                    --     "<leader>D",
                    --     require("telescope.builtin").lsp_type_definitions,
                    --     "Type [D]efinition"
                    -- )
                    --
                    -- -- Fuzzy find all the symbols in your current document.
                    -- --  Symbols are things like variables, functions, types, etc.
                    -- map(
                    --     "<leader>ds",
                    --     require("telescope.builtin").lsp_document_symbols,
                    --     "[D]ocument [S]ymbols"
                    -- )
                    --
                    -- -- Fuzzy find all the symbols in your current workspace
                    -- --  Similar to document symbols, except searches over your whole project.
                    -- map(
                    --     "<leader>ws",
                    --     require("telescope.builtin").lsp_dynamic_workspace_symbols,
                    --     "[W]orkspace [S]ymbols"
                    -- )
                    --
                    -- Rename the variable under your cursor
                    --  Most Language Servers support renaming across files, etc.
                    map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
                    --
                    -- -- Execute a code action, usually your cursor needs to be on top of an error
                    -- -- or a suggestion from your LSP for this to activate.
                    -- map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
                    --
                    -- -- Opens a popup that displays documentation about the word under your cursor
                    -- --  See `:help K` for why this keymap
                    -- map("K", vim.lsp.buf.hover, "Hover Documentation")
                    --
                    -- -- WARN: This is not Goto Definition, this is Goto Declaration.
                    -- --  For example, in C this would take you to the header
                    -- map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

                    -- The following two autocommands are used to highlight references of the
                    -- word under your cursor when your cursor rests there for a little while.
                    --    See `:help CursorHold` for information about when this is executed
                    --
                    -- When you move your cursor, the highlights will be cleared (the second autocommand).
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.server_capabilities.documentHighlightProvider then
                        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.clear_references,
                        })
                    end
                end,
            })

            -- LSP servers and clients are able to communicate to each other what features they support.
            --  By default, Neovim doesn't support everything that is in the LSP Specification.
            --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
            --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend(
                "force",
                capabilities,
                require("cmp_nvim_lsp").default_capabilities()
            )

            -- Enable the following language servers
            --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
            --
            --  Add any additional override configuration in the following tables. Available keys are:
            --  - cmd (table): Override the default command used to start the server
            --  - filetypes (table): Override the default list of associated filetypes for the server
            --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
            --  - settings (table): Override the default settings passed when initializing the server.
            --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
            local servers = {

                lua_ls = {
                    -- cmd = {...},
                    -- filetypes { ...},
                    -- capabilities = {},
                    settings = {
                        Lua = {
                            runtime = { version = "LuaJIT" },
                            workspace = {
                                --checkThirdParty = false,
                                -- Tells lua_ls where to find all the Lua files that you have loaded
                                -- for your neovim configuration.
                                --library = {
                                --    "${3rd}/luv/library",
                                --    unpack(vim.api.nvim_get_runtime_file("", true)),
                                --},
                                -- If lua_ls is really slow on your computer, you can try this instead:
                                -- library = { vim.env.VIMRUNTIME },
                            },
                            completion = {
                                callSnippet = "Replace",
                            },
                            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                            -- diagnostics = { disable = { 'missing-fields' } },
                        },
                    },
                },
            }

            for name, config in pairs(servers) do
                require("lspconfig")[name].setup(config)
            end
        end,
    },
    -- }}} LSP

    -- Rustaceanvim: {{{
    {
        "mrcjkb/rustaceanvim",
        version = "^4", -- Recommended
        ft = { "rust" },
    },
    -- }}} Rustaceanvim

    -- nvim-cmp (Completion): {{{
    { -- Autocompletion
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            {
                "L3MON4D3/LuaSnip",
                build = (function()
                    -- Build Step is needed for regex support in snippets
                    -- This step is not supported in many windows environments
                    -- Remove the below condition to re-enable on windows
                    if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
                        return
                    end
                    return "make install_jsregexp"
                end)(),
            },
            "saadparwaiz1/cmp_luasnip",

            -- Adds other completion capabilities.
            --  nvim-cmp does not ship with all sources by default. They are split
            --  into multiple repos for maintenance purposes.
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",

            -- If you want to add a bunch of pre-configured snippets,
            --    you can use this plugin to help you. It even has snippets
            --    for various frameworks/libraries/etc. but you will have to
            --    set up the ones that are useful for you.
            -- 'rafamadriz/friendly-snippets',
        },
        config = function()
            -- See `:help cmp`
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            luasnip.config.setup({})

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                completion = { completeopt = "menu,menuone,noinsert" },

                -- For an understanding of why these mappings were
                -- chosen, you will need to read `:help ins-completion`
                --
                -- No, but seriously. Please read `:help ins-completion`, it is really good!
                mapping = cmp.mapping.preset.insert({
                    -- Select the [n]ext item
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    -- Select the [p]revious item
                    ["<C-p>"] = cmp.mapping.select_prev_item(),

                    -- Accept ([y]es) the completion.
                    --  This will auto-import if your LSP supports it.
                    --  This will expand snippets if the LSP sent a snippet.
                    ["<C-y>"] = cmp.mapping.confirm({ select = true }),

                    -- Manually trigger a completion from nvim-cmp.
                    --  Generally you don't need this, because nvim-cmp will display
                    --  completions whenever it has completion options available.
                    ["<C-Space>"] = cmp.mapping.complete({}),

                    -- Think of <c-l> as moving to the right of your snippet expansion.
                    --  So if you have a snippet that's like:
                    --  function $name($args)
                    --    $body
                    --  end
                    --
                    -- <c-l> will move you to the right of each of the expansion locations.
                    -- <c-h> is similar, except moving you backwards.
                    ["<C-l>"] = cmp.mapping(function()
                        if luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        end
                    end, { "i", "s" }),
                    ["<Tab>"] = cmp.mapping(function()
                        if luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        end
                    end, { "i", "s" }),
                    ["<C-h>"] = cmp.mapping(function()
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function()
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        end
                    end, { "i", "s" }),
                }),
                sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "path" },
                    { name = "lazydev", group_index = 0 },
                },
            })
        end,
    },
    -- }}} nvim-cmp

    -- gruvbox (Colorscheme): {{{
    {
        "sainnhe/gruvbox-material",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd[[
                " TODO: Make this more generic and add to autocmd
                let g:gruvbox_material_foreground = 'original'
                let g:gruvbox_material_disable_italic_comment = 1
                let g:gruvbox_material_ui_contrast = 'high'

                let s:configuration = gruvbox_material#get_configuration()
                let s:palette = gruvbox_material#get_palette( s:configuration.background, s:configuration.foreground, s:configuration.colors_override)

                colorscheme gruvbox-material

                highlight! link ModeMsg MoreMsg
                highlight! link TSPunctBracket TSOperator

                call gruvbox_material#highlight('TabNum', s:palette.fg0, s:palette.bg1)
                call gruvbox_material#highlight('TabNumSel', s:palette.green, s:palette.bg1, 'bold')
                call gruvbox_material#highlight('TabLine', s:palette.grey0, s:palette.bg1)
                call gruvbox_material#highlight('TabLineSel', s:palette.green, s:palette.bg1)
            ]]
        end,
    },
    -- }}} colorscheme

    -- todo-comments: {{{
    {
        "folke/todo-comments.nvim",
        event = "VimEnter",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { signs = true },
    },
    -- }}} todo-comments

    -- treesitter: {{{
    { -- Highlight, edit, and navigate code
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { },
                -- Autoinstall languages that are not installed
                auto_install = true,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },
    -- }}} treesitter
})

-- }}} Install and Configure Plugins

-- }}} Plugins

-- vim: fdm=marker
