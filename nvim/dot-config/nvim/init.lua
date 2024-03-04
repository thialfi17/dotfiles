-- Options: {{{
-- NOTE: vim.opt is soft deprecated and is slated to be removed at _some_ point
-- in the future

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
vim.o.ignorecase = true
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
vim.o.listchars = "tab:——▸,trail:␣,extends:→,precedes:←,nbsp:⍽,conceal:·"

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

-- Mappings: {{{
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = "\\"
vim.g.maplocalleader = " "

-- General Mappings: {{{

-- Remove highlighting from search
vim.keymap.set("n", "<leader>n", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set(
    "n",
    "[d",
    vim.diagnostic.goto_prev,
    { desc = "Go to previous [D]iagnostic message" }
)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set(
    "n",
    "<localleader>e",
    vim.diagnostic.open_float,
    { desc = "Show diagnostic [E]rror messages" }
)
vim.keymap.set(
    "n",
    "<localleader>l",
    vim.diagnostic.setloclist,
    { desc = "Open diagnostic [L]ocation list" }
)

-- Terminal-mode escape
vim.keymap.set({ "t" }, "<C-\\><C-\\>", [[<C-\><C-n>]], { desc = "Escape terminal mode" })
vim.keymap.set({ "t" }, "<Esc><Esc>", "<C-\\><C-n>", { desc = "Escape terminal mode" })

-- Remove trailing whitespace on current line
vim.keymap.set(
    { "n" },
    "<localleader>r<space>",
    [[m':.s/\s\+$//<CR>`']],
    { desc = "Remove trailing whitespace on current line" }
)

-- Add zz at the end of search movement commands to center after moving
vim.keymap.set({ "n" }, "n", [[nzz]], {})
vim.keymap.set({ "n" }, "N", [[Nzz]], {})

-- Open configuration file
vim.keymap.set({ "n", "t" }, "<F4>", "<CMD>tabe $MYVIMRC<CR>", {})

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

-- }}} Window/Tab Navigation

-- }}} Mappings

-- Abbreviations: {{{

vim.keymap.set({ "ca" }, "vfind", "vert sfind", {})
vim.keymap.set({ "ca" }, "vterm", "vert term", {})
vim.keymap.set({ "ca" }, "help", "vert help", {})

-- }}}

-- Autocommands: {{{

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking text",
    group = vim.api.nvim_create_augroup("config-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
    desc = "Resize windows when Neovim is resized",
    group = vim.api.nvim_create_augroup("config-resize-windows", { clear = true }),
    pattern = { "" },
    command = "wincmd =",
})

-- }}} Autocommands

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

    -- "gc" to comment visual regions/lines
    { "numToStr/Comment.nvim", opt = {} },

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
            require("which-key").setup()

            -- Document existing key chains
            require("which-key").register({
                ["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
                ["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
                ["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
                ["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
                ["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
            })
        end,
    },
    -- }}} WhichKey

    -- Telescope: {{{
    { -- Fuzzy Finder (files, lsp, etc)
        "nvim-telescope/telescope.nvim",
        event = "VimEnter",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { -- If encountering errors, see telescope-fzf-native README for install instructions
                "nvim-telescope/telescope-fzf-native.nvim",

                -- `build` is used to run some command when the plugin is installed/updated.
                -- This is only run then, not every time Neovim starts up.
                build = "make",

                -- `cond` is a condition used to determine whether this plugin should be
                -- installed and loaded.
                cond = function()
                    return vim.fn.executable("make") == 1
                end,
            },
            { "nvim-telescope/telescope-ui-select.nvim" },

            -- Useful for getting pretty icons, but requires special font.
            --  If you already have a Nerd Font, or terminal set up with fallback fonts
            --  you can enable this
            -- { 'nvim-tree/nvim-web-devicons' }
        },
        config = function()
            -- Telescope is a fuzzy finder that comes with a lot of different things that
            -- it can fuzzy find! It's more than just a "file finder", it can search
            -- many different aspects of Neovim, your workspace, LSP, and more!
            --
            -- The easiest way to use telescope, is to start by doing something like:
            --  :Telescope help_tags
            --
            -- After running this command, a window will open up and you're able to
            -- type in the prompt window. You'll see a list of help_tags options and
            -- a corresponding preview of the help.
            --
            -- Two important keymaps to use while in telescope are:
            --  - Insert mode: <c-/>
            --  - Normal mode: ?
            --
            -- This opens a window that shows you all of the keymaps for the current
            -- telescope picker. This is really useful to discover what Telescope can
            -- do as well as how to actually do it!

            -- [[ Configure Telescope ]]
            -- See `:help telescope` and `:help telescope.setup()`
            require("telescope").setup({
                -- You can put your default mappings / updates / etc. in here
                --  All the info you're looking for is in `:help telescope.setup()`
                --
                -- defaults = {
                --   mappings = {
                --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
                --   },
                -- },
                -- pickers = {}
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown(),
                    },
                },
            })

            -- Enable telescope extensions, if they are installed
            pcall(require("telescope").load_extension, "fzf")
            pcall(require("telescope").load_extension, "ui-select")

            -- See `:help telescope.builtin`
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
            vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
            vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
            vim.keymap.set(
                "n",
                "<leader>ss",
                builtin.builtin,
                { desc = "[S]earch [S]elect Telescope" }
            )
            vim.keymap.set(
                "n",
                "<leader>sw",
                builtin.grep_string,
                { desc = "[S]earch current [W]ord" }
            )
            vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
            vim.keymap.set(
                "n",
                "<leader>sd",
                builtin.diagnostics,
                { desc = "[S]earch [D]iagnostics" }
            )
            vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
            vim.keymap.set(
                "n",
                "<leader>s.",
                builtin.oldfiles,
                { desc = '[S]earch Recent Files ("." for repeat)' }
            )
            vim.keymap.set(
                "n",
                "<leader><leader>",
                builtin.buffers,
                { desc = "[ ] Find existing buffers" }
            )

            -- Slightly advanced example of overriding default behavior and theme
            vim.keymap.set("n", "<leader>/", function()
                -- You can pass additional configuration to telescope to change theme, layout, etc.
                builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
                    winblend = 10,
                    previewer = false,
                }))
            end, { desc = "[/] Fuzzily search in current buffer" })

            -- Also possible to pass additional configuration options.
            --  See `:help telescope.builtin.live_grep()` for information about particular keys
            vim.keymap.set("n", "<leader>s/", function()
                builtin.live_grep({
                    grep_open_files = true,
                    prompt_title = "Live Grep in Open Files",
                })
            end, { desc = "[S]earch [/] in Open Files" })

            -- Shortcut for searching your neovim configuration files
            vim.keymap.set("n", "<leader>sn", function()
                builtin.find_files({ cwd = vim.fn.stdpath("config") })
            end, { desc = "[S]earch [N]eovim files" })
        end,
    },
    -- }}} Telescope

    -- LSP: {{{
    { -- LSP Configuration & Plugins
        "neovim/nvim-lspconfig",
        dependencies = {
            -- Automatically install LSPs and related tools to stdpath for neovim
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",

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
                    -- In this case, we create a function that lets us more easily define mappings specific
                    -- for LSP related items. It sets the mode, buffer and description for us each time.
                    local map = function(keys, func, desc)
                        vim.keymap.set(
                            "n",
                            keys,
                            func,
                            { buffer = event.buf, desc = "LSP: " .. desc }
                        )
                    end

                    -- Jump to the definition of the word under your cursor.
                    --  This is where a variable was first declared, or where a function is defined, etc.
                    --  To jump back, press <C-T>.
                    map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

                    -- Find references for the word under your cursor.
                    map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

                    -- Jump to the implementation of the word under your cursor.
                    --  Useful when your language has ways of declaring types without an actual implementation.
                    map(
                        "gI",
                        require("telescope.builtin").lsp_implementations,
                        "[G]oto [I]mplementation"
                    )

                    -- Jump to the type of the word under your cursor.
                    --  Useful when you're not sure what type a variable is and you want to see
                    --  the definition of its *type*, not where it was *defined*.
                    map(
                        "<leader>D",
                        require("telescope.builtin").lsp_type_definitions,
                        "Type [D]efinition"
                    )

                    -- Fuzzy find all the symbols in your current document.
                    --  Symbols are things like variables, functions, types, etc.
                    map(
                        "<leader>ds",
                        require("telescope.builtin").lsp_document_symbols,
                        "[D]ocument [S]ymbols"
                    )

                    -- Fuzzy find all the symbols in your current workspace
                    --  Similar to document symbols, except searches over your whole project.
                    map(
                        "<leader>ws",
                        require("telescope.builtin").lsp_dynamic_workspace_symbols,
                        "[W]orkspace [S]ymbols"
                    )

                    -- Rename the variable under your cursor
                    --  Most Language Servers support renaming across files, etc.
                    map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

                    -- Execute a code action, usually your cursor needs to be on top of an error
                    -- or a suggestion from your LSP for this to activate.
                    map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

                    -- Opens a popup that displays documentation about the word under your cursor
                    --  See `:help K` for why this keymap
                    map("K", vim.lsp.buf.hover, "Hover Documentation")

                    -- WARN: This is not Goto Definition, this is Goto Declaration.
                    --  For example, in C this would take you to the header
                    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

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
                -- clangd = {},
                -- gopls = {},
                -- pyright = {},
                -- rust_analyzer = {},
                -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
                --
                -- Some languages (like typescript) have entire language plugins that can be useful:
                --    https://github.com/pmizio/typescript-tools.nvim
                --
                -- But for many setups, the LSP (`tsserver`) will work just fine
                -- tsserver = {},
                --

                lua_ls = {
                    -- cmd = {...},
                    -- filetypes { ...},
                    -- capabilities = {},
                    settings = {
                        Lua = {
                            runtime = { version = "LuaJIT" },
                            workspace = {
                                checkThirdParty = false,
                                -- Tells lua_ls where to find all the Lua files that you have loaded
                                -- for your neovim configuration.
                                library = {
                                    "${3rd}/luv/library",
                                    unpack(vim.api.nvim_get_runtime_file("", true)),
                                },
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

            -- Ensure the servers and tools above are installed
            --  To check the current status of installed tools and/or manually install
            --  other tools, you can run
            --    :Mason
            --
            --  You can press `g?` for help in this menu
            require("mason").setup()

            -- You can add other tools here that you want Mason to install
            -- for you, so that they are available from within Neovim.
            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                "stylua", -- Used to format lua code
            })
            require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

            require("mason-lspconfig").setup({
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        -- This handles overriding only values explicitly passed
                        -- by the server configuration above. Useful when disabling
                        -- certain features of an LSP (for example, turning off formatting for tsserver)
                        server.capabilities = vim.tbl_deep_extend(
                            "force",
                            {},
                            capabilities,
                            server.capabilities or {}
                        )
                        require("lspconfig")[server_name].setup(server)
                    end,
                },
            })
        end,
    },
    -- }}} LSP

    -- conform (Autoformatting): {{{
    { -- Autoformat
        "stevearc/conform.nvim",
        opts = {
            notify_on_error = true,
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
            formatters_by_ft = {
                lua = { "stylua" },
                -- Conform can also run multiple formatters sequentially
                -- python = { "isort", "black" },
                --
                -- You can use a sub-list to tell conform to run *until* a formatter
                -- is found.
                -- javascript = { { "prettierd", "prettier" } },
            },
        },
    },
    -- }}} Conform

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
                    ["<C-h>"] = cmp.mapping(function()
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        end
                    end, { "i", "s" }),
                }),
                sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "path" },
                },
            })
        end,
    },
    -- }}} nvim-cmp

    -- gruvbox (Colorscheme): {{{
    {
        --"folke/tokyonight.nvim",
        "ellisonleao/gruvbox.nvim",
        lazy = false, -- make sure we load this during startup
        priority = 1000, -- make sure to load this before all other plugins
        -- After loading
        config = function()
            -- Load the colorscheme
            vim.cmd.colorscheme("gruvbox")
        end,
        -- Provided to setup( .. )
        opts = {
            undercurl = true,
            underline = true,
            bold = true,
            italic = {
                strings = false,
                emphasis = false,
                comments = true,
                operators = false,
                folds = true,
            },
            strikethrough = true,
            inverse = true,
            contrast = "hard",
            transparent_mode = true,
        },
    },
    -- }}} colorscheme

    -- todo-comments: {{{
    {
        "folke/todo-comments.nvim",
        event = "VimEnter",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { signs = false },
    },
    -- }}} todo-comments

    -- mini: {{{
    { -- Collection of various small independent plugins/modules
        "echasnovski/mini.nvim",
        config = function()
            -- Better Around/Inside textobjects
            --
            -- Examples:
            --  - va)  - [V]isually select [A]round [)]paren
            --  - yinq - [Y]ank [I]nside [N]ext [']quote
            --  - ci'  - [C]hange [I]nside [']quote
            require("mini.ai").setup({ n_lines = 500 })

            -- Add/delete/replace surroundings (brackets, quotes, etc.)
            --
            -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
            -- - sd'   - [S]urround [D]elete [']quotes
            -- - sr)'  - [S]urround [R]eplace [)] [']
            require("mini.surround").setup()

            -- Simple and easy statusline.
            --  You could remove this setup call if you don't like it,
            --  and try some other statusline plugin
            local statusline = require("mini.statusline")
            statusline.setup()

            -- You can configure sections in the statusline by overriding their
            -- default behavior. For example, here we set the section for
            -- cursor location to LINE:COLUMN
            ---@diagnostic disable-next-line: duplicate-set-field
            statusline.section_location = function()
                return "%2l:%-2v"
            end

            -- ... and there is more!
            --  Check out: https://github.com/echasnovski/mini.nvim
        end,
    },
    -- }}} mini

    -- treesitter: {{{
    { -- Highlight, edit, and navigate code
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "bash",
                    "c",
                    "html",
                    "lua",
                    "markdown",
                    "vim",
                    "vimdoc",
                    "python",
                    "rust",
                },
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
