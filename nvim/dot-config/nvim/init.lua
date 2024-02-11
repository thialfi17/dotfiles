-- vim: fdm=marker

-- Plugin Management: {{{
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    "nvim-treesitter/nvim-treesitter",
    "ellisonleao/gruvbox.nvim",
    "neovim/nvim-lspconfig",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "L3MON4D3/LuaSnip",
    "L3MON4D3/cmp-luasnip-choice",
}, {
})

-- }}}

-- Options: {{{

-- Make sure to use a dark background
vim.o.background = "dark"

-- Set language for spelling to British English
vim.o.spelllang = "en_gb"

-- Highlight search results
vim.o.hlsearch = true

-- Show line numbers
vim.o.number = true
-- Show relative line numbers
vim.o.relativenumber = true

-- Set what backspace is allowed to delete
vim.o.backspace = "indent,start,eol"

-- Line Wrapping: {{{

vim.o.wrap = false

-- Set wrapping to occur at the characters specified by 'breakat' not last character on screen
vim.o.linebreak = true
vim.o.breakat = "\t ;?,:"

-- Set characters used to indicate that a line has been wrapped
vim.o.showbreak = "↳ "

-- Wrapped lines begin at same indentation as the line they came from
vim.o.breakindent = true

-- }}}

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

-- Incremental search
vim.o.incsearch = true

-- Change default grep arguments for built in grep searches
vim.o.grepprg = "grep -nE $* /dev/null"

-- Set usage of mouse for everything (defaults to 'nvi' so this only enables in Command-line mode)
vim.o.mouse = "a"

-- Always show the statusline
vim.o.laststatus = 2
-- Always show the tabline
vim.o.showtabline = 2

-- Allow buffers to be hidden
vim.o.hidden = true

-- Scroll before the end of the screen in any direction
vim.o.scrolloff = 10
vim.o.sidescrolloff = 2
-- Scroll by X characters when moving of the edge of the screen
vim.o.sidescroll = 10

-- Change how split windows are placed. This places the new window to the right or below the existing window
vim.o.splitright = true
vim.o.splitbelow = true

-- Automatically expand tabs to spaces and set indent to use 4 spaces by default
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

-- Enable persistent undos
vim.o.undofile = true

-- Don't wrap text on lines in insert mode when they get too long
vim.o.textwidth = 0

-- Change it so that 'J' removes the comment string when combining lines
vim.opt.formatoptions:append("j")

-- Allow moving/editing past the end of the line
vim.o.virtualedit = "all"

-- Make the default preview window size bigger
vim.o.previewheight = 30

-- }}}

-- Mappings: {{{

-- General Mappings: {{{

vim.g.mapleader = "\\"
vim.g.maplocalleader = " "

-- Remove trailing whitespace on current line
vim.keymap.set({ 'n' }, '<Leader>r<space>', [[m':.s/\s\+$//<CR>`']], { desc = "Remove trailing whitespace on current line" })

-- Make it so '//' searches for the selected text
vim.keymap.set({ 'v' }, '//', [[y/<C-R>"<CR>]], { desc = "Search for selected text" })

-- Remove highlighting from search
vim.keymap.set({ 'n' }, '<Leader>n', [[<Cmd>nohl<CR>]], { desc = "Disable highlighting from search" })

-- Terminal escape
vim.keymap.set({ 't' }, '<C-\\><C-\\>', [[<C-\><C-n>]], { desc = "Escape terminal mode" })
vim.keymap.set({ 't' }, '<Esc><Esc>', '<C-\\><C-n>', { desc = "Escape terminal mode" })

-- Add zz at the end of search movement commands to center after moving
vim.keymap.set({ 'n' }, 'n', [[nzz]], {})
vim.keymap.set({ 'n' }, 'N', [[Nzz]], {})

-- Open configuration file
vim.keymap.set({ 'n', 't' }, '<F4>', '<CMD>tabe $MYVIMRC<CR>', {})

-- }}}

-- Window/Tab Navigation: {{{

vim.keymap.set({ 'n', 't' }, '<M-h>', '<CMD>wincmd h<CR>', {})
vim.keymap.set({ 'n', 't' }, '<M-j>', '<CMD>wincmd j<CR>', {})
vim.keymap.set({ 'n', 't' }, '<M-k>', '<CMD>wincmd k<CR>', {})
vim.keymap.set({ 'n', 't' }, '<M-l>', '<CMD>wincmd l<CR>', {})

vim.keymap.set({ 'n', 't' }, '<M-1>', '<CMD>1tabnext<CR>', {})
vim.keymap.set({ 'n', 't' }, '<M-2>', '<CMD>2tabnext<CR>', {})
vim.keymap.set({ 'n', 't' }, '<M-3>', '<CMD>3tabnext<CR>', {})
vim.keymap.set({ 'n', 't' }, '<M-4>', '<CMD>4tabnext<CR>', {})
vim.keymap.set({ 'n', 't' }, '<M-5>', '<CMD>5tabnext<CR>', {})
vim.keymap.set({ 'n', 't' }, '<M-6>', '<CMD>6tabnext<CR>', {})
vim.keymap.set({ 'n', 't' }, '<M-7>', '<CMD>7tabnext<CR>', {})
vim.keymap.set({ 'n', 't' }, '<M-8>', '<CMD>8tabnext<CR>', {})
vim.keymap.set({ 'n', 't' }, '<M-9>', '<CMD>9tabnext<CR>', {})
vim.keymap.set({ 'n', 't' }, '<M-0>', '<CMD>10tabnext<CR>', {})

-- }}}

-- }}}

-- Abbreviations: {{{

vim.keymap.set({ 'ca' }, 'vfind', 'vert sfind', {})
vim.keymap.set({ 'ca' }, 'vterm', 'vert term', {})
vim.keymap.set({ 'ca' }, 'help', 'vert help', {})

-- }}}

-- Autocommands: {{{

local augroup = vim.api.nvim_create_augroup("Custom", {})
vim.api.nvim_create_autocmd({"BufWritePost"}, {
    group = augroup,
    pattern = os.getenv("MYVIMRC"),
    command = [[source $MYVIMRC]],
    nested = true,
})
vim.api.nvim_create_autocmd({"BufWinEnter"}, {
    group = augroup,
    callback = function()
        if vim.o.previewwindow then
            vim.wo.foldlevel = 99
        end
    end,
})
vim.api.nvim_create_autocmd({"TermOpen"}, {
    group = augroup,
    command = "startinsert",
})
vim.api.nvim_create_autocmd({"BufEnter"}, {
    group = augroup,
    pattern = "term://*",
    command = "startinsert",
})

-- }}}

-- File Finding and Editing: {{{

-- Mappings: {{{

-- ":find" searches for the given file in all directories given in 'path'
vim.keymap.set({ 'n' }, '<Leader>f', ':find<Space>', { desc = "Find a file" })

-- List buffers and prefill command line for switching to one
vim.keymap.set({ 'n' }, '<Leader>b', '<Cmd>buffers<CR>:buffer<Space>', { desc = "List and switch to a buffer" })

-- Shortcut for editing a file since I got used to "<Leader>f"
vim.keymap.set({ 'n' }, '<Leader>e', ':e<Space>', { desc = "Edit a file" })
-- Edit a file in the same directory as the current file
vim.keymap.set({ 'n' }, '<Leader>E', function ()
    return table.concat({":e ", vim.fn.expand("%:p:h"), "/"})
end, { desc = "Edit a file", expr = true })

-- }}}

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

-- }}}

-- }}}

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
        local file_type = vim.api.nvim_get_option_value("filetype", {buf = buf_id})
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

                local cwd_parts = vim.split(vim.uv.cwd(), "/", {trimempty = true})
                local path_parts = vim.split(prefix, "/", {trimempty = true})

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

        if vim.api.nvim_get_option_value("modified", {buf = buf_id}) then
            table.insert(suffix_parts, "*")
        end

        local modified = ""
        for _, win in pairs(wins_list) do
            local buf = vim.api.nvim_win_get_buf(win)
            if buf == buf_id then goto continue end
            if vim.api.nvim_get_option_value("modified", {buf = buf}) then
                modified = "*"
                break
            end
            ::continue::
        end

        -- Form suffix
        if num_wins > 1 then
            table.insert(suffix_parts , " ")
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

vim.o.tabline = "%!v:lua.Tabline()"

-- }}}

---
---
---
---
---

require('nvim-treesitter.configs').setup {
    ensure_installed = { "c", "lua", "vim", "vimdoc" },
    sync_install = false,
    auto_install = true,
    ignore_install = {},
    highlight = {
        enable = true
    },
    modules = {}
}

require('gruvbox').setup({
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
})

require 'lspconfig'.lua_ls.setup { settings = {
    Lua = {
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
            enable = false,
        },
    }
} }
require 'lspconfig'.marksman.setup{}

local cmp = require 'cmp'
cmp.setup({
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'nvim_lsp_signature_help' },
    })
})

vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<space>f', function()
            vim.lsp.buf.format { async = true }
        end, opts)
    end,
})

vim.cmd([[colorscheme gruvbox]])

function StartEditingTempFile()
    vim.bo.undofile = false

    local filename = vim.api.nvim_cmd({ cmd = "echo", args = { "bufname()" } }, { output = true })
    local newfname, _ = string.gsub(filename, "XX%w*", "")
    local undofilename = vim.api.nvim_cmd({ cmd = "echo", args = { string.format("undofile('%s')", newfname) } },
        { output = true })

    pcall(vim.cmd, { cmd = "rundo", args = { undofilename }, magic = { file = false, }, mods = { silent = true } })

    vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
        buffer = 0,
        callback = function()
            vim.cmd({ cmd = "wundo", args = { undofilename }, magic = { file = false, }, mods = { silent = true } })
        end,
    })
end

vim.api.nvim_create_autocmd({ "BufRead" }, {
    pattern = { "/var/tmp/*XX*" },
    callback = StartEditingTempFile,
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
    pattern = { "" },
    command = "wincmd =",
})
