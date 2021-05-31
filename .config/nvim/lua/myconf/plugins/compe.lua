local map = vim.api.nvim_set_keymap

require'compe'.setup {
    enabled = true;
    autocomplete = true;
    debug = false;
    min_length = 1;
    preselect = 'enable';
    throttle_time = 80;
    source_timeout = 200;
    incomplete_delay = 400;
    max_abbr_width = 100;
    max_kind_width = 100;
    max_menu_width = 100;
    documentation = true;

    source = {
        path = true;
        buffer = true;
        calc = true;
        nvim_lsp = true;
        nvim_lua = true;
        ultisnips = false;
        vsnip = false;
    };
}

-- nvim-compe mappings
map('i', '<C-Space>', "compe#complete()", {silent = true, expr = true, noremap = true})
map('i', '<CR>', "compe#confirm('<CR>')", {silent = true, expr = true, noremap = true})
map('i', '<C-e>', "compe#close('<C-e>')", {silent = true, expr = true, noremap = true})
map('i', '<C-f>', "compe#scroll({'delta': +4})", {silent = true, expr = true, noremap = true})
map('i', '<C-d>', "compe#scroll({'delta': -4})", {silent = true, expr = true, noremap = true})
