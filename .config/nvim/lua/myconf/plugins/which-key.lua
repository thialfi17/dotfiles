local wk = require('which-key')

-- TODO: Move keymaps defined elsewhere into this file?

-- Normal-mode Keymaps
wk.register({
    ["gR"] = {"<cmd>TroubleToggle lsp_references<cr>", "LSP List References", silent = true, noremap = true },
    ["<C-s>"] = {"<cmd>BufferPick<CR>", "Magic Buffer Select", silent = true, noremap = true},
})

-- Normal-mode Keymaps with Leader
wk.register({
    c = {
        name = "Kommentary",
        d = { name = "Motion Decrease", c = "Line decrease", },
        i = { name = "Motion Increase" , c = "Line increase", },
    },
    f = {
        name = "Telescope Files",
        f = { "Find Local File" },
        g = { "Grep Local Files" },
        n = {
            name = "Config Files",
            g = { "Grep Config Files" },
            f = { "Find Config File" },
        },
    },
    g = {
        name = "Treesitter",
        r = {
            name = "Rename",
            r = { "Smart Rename" },
        },
        n = {
            name = "Definitions",
            d = { "Goto Definitions", },
            D = { "List Definitions", },
        },
        O = {
            name = "List Definitions TOC",
        },
    },
    h = {
        name = "Git Signs",
        b = { "Blame Line" },
        p = { "Preview Hunk" },
        r = { "Reset Hunk" },
        R = { "Reset Buffer" },
        s = { "Stage Hunk" },
        u = { "Undo Stage Hunk" },
    },
    ["lm"] = { "Reload Telescope" },
    n = {
        name = "NvimTree",
        t = { "<cmd>lua require'myconf.plugins.tree'.toggle()<cr>", "Toggle Tree", silent = true, noremap = true },
        o = { "<cmd>lua require'myconf.plugins.tree'.open()<cr>", "Open Tree", silent = true, noremap = true },
        c = { "<cmd>lua require'myconf.plugins.tree'.close()<cr>", "Close Tree", silent = true, noremap = true },
        r = { "<cmd>NvimTreeRefresh<cr>", "Refresh Tree", silent = true, noremap = true },
        f = { "<cmd>NvimTreeFindFile<cr>", "Find File", silent = true, noremap = true },
    },
    t = {
        name = "Trouble",
        x = { "<cmd>TroubleToggle<cr>", "Trouble", silent = true, noremap = true },
        w = { "<cmd>TroubleToggle lsp_workspace_diagnostics<cr>", "LSP Workspace Diagnostics", silent = true, noremap = true },
        d = { "<cmd>TroubleToggle lsp_document_diagnostics<cr>", "LSP Document Diagnostics", silent = true, noremap = true },
        l = { "<cmd>TroubleToggle loclist<cr>", "Location List", silent = true, noremap = true },
        q = { "<cmd>TroubleToggle quickfix<cr>", "Quickfix List", silent = true, noremap = true },
    },
    x = { "<cmd>BufferClose<cr>", "Close Buffer", silent = true, noremap = true },
}, { prefix = "<leader>" })

-- Visual-mode Keymaps with Leader
wk.register({
    c = {
        name = "Kommentary",
        d = { "Motion Decrease" },
        i = { "Motion Increase" },
    },
}, { prefix = "<leader>", mode = "v" })
