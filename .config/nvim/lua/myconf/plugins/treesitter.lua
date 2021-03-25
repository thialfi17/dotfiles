require'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
    },
    indent = {
        enable = false,
    },
    refactor = {
        smart_rename = {
            enable = true,
            keymaps = {
                smart_rename = "<Leader>grr",
            },
        },
        navigation = {
            enable = true,
            keymaps = {
                goto_definition = "<Leader>gnd",
                list_definitions = "<Leader>gnD",
                list_definitions_toc = "<Leader>gO",
                goto_next_usage = "<a-*>",
                goto_previous_usage = "<a-#>",
            },
        },
    },
}
