-- Automatically add Packer to Neovim
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

require('packer').startup(function(use)
    -- Packer manages itself
    use 'wbthomason/packer.nvim'

    -- Syntax plugins
    use { 'nvim-treesitter/nvim-treesitter', config = function() require('myconf.plugins.treesitter') end, }
    use 'nvim-treesitter/playground'
    use 'nvim-treesitter/nvim-treesitter-refactor'
    use 'sgur/vim-textobj-parameter'
    use 'kana/vim-textobj-user'
    use { 'neovim/nvim-lspconfig', config = function() require('myconf.plugins.lsp-config') end, }

    -- Various libraries/common functions
    use 'nvim-lua/popup.nvim'
    use 'nvim-lua/plenary.nvim'

    -- Autocomplete
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'onsails/lspkind-nvim',
            'saadparwaiz1/cmp_luasnip',
        }
    }
    use {
        'L3MON4D3/LuaSnip',
        config = function()
            vim.cmd [[
                imap <silent><expr> <c-j> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<c-k>'
                inoremap <silent> <c-k> <cmd>lua require('luasnip').jump(-1)<CR>
                imap <silent><expr> <C-l> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-l>'
                snoremap <silent> <c-j> <cmd>lua require('luasnip').jump(1)<CR>
                snoremap <silent> <c-k> <cmd>lua require('luasnip').jump(-1)<CR>
            ]]
        end,
    }

    -- Search
    use { 'nvim-telescope/telescope.nvim', config = function() require('myconf.plugins.telescope') end, }
    use { 'nvim-telescope/telescope-symbols.nvim' }

    -- Appearance
    use 'kyazdani42/nvim-web-devicons'
    use 'sainnhe/gruvbox-material'
    use 'lukas-reineke/indent-blankline.nvim'
    use { 'lewis6991/gitsigns.nvim', config = function() require('myconf.plugins.gitsigns') end, }
    use {
        'folke/zen-mode.nvim',
        opt = true,
        cmd = {'ZenMode'},
        config = function() require('myconf.plugins.zenmode') end,
    }
    use 'romgrk/barbar.nvim'
    use { 'norcalli/nvim-colorizer.lua', config = function() require('colorizer').setup() end, }

    -- Formatting
    use 'godlygeek/tabular'
    use { 'AckslD/nvim-revJ.lua', config = function() require('revj').setup() end, }
    use 'tpope/vim-surround'
    use { 'b3nj5m1n/kommentary', config = function() require('myconf.plugins.kommentary') end, }

    -- Language Specific
    use 'lervag/vimtex'

    -- Other
    use {
        'sindrets/diffview.nvim',
        opt = true,
        cmd = {'DiffviewOpen', 'DiffviewFileHistory'},
        config = function() require('myconf.plugins.diffview') end,
    }
    use { 'folke/trouble.nvim', config = function() require('myconf.plugins.trouble') end, }
    use { 'folke/todo-comments.nvim', config = function() require('todo-comments').setup{} end, }
    -- TODO: Look into lsp-saga as an alternative
    use { 'ray-x/lsp_signature.nvim', config = function() require('lsp_signature').on_attach() end, }
    use { 'kyazdani42/nvim-tree.lua', config = function() require('myconf.plugins.nvim-tree') end, }
    use { 'phaazon/hop.nvim', config = function() require('hop').setup() end, }
    use { 'folke/which-key.nvim', config = function() require('myconf.plugins.which-key') end, }

    -- Automatically set up configuration after cloning packer.nvim
    if packer_bootstrap then
        require('packer').sync()
    end
end)

-- Enable colorscheme
vim.g.gruvbox_material_background = 'hard'
vim.g.gruvbox_material_palette = 'original'
vim.g.gruvbox_material_sign_column_background = 'none'

vim.cmd("colorscheme gruvbox-material")

-- Plugin configurations/initialisations
require('myconf.plugins.nvim-cmp')

-- Configure barbar
vim.g.bufferline = {animation = false}

-- Configure NvimTree
vim.g.nvim_tree_root_folder_modifier = ':~:t'
vim.g.nvim_tree_window_picker_exclude = { filetype = { "Trouble", }, }

-- Configure vimtex to use the right viewer
vim.g.vimtex_view_method = 'zathura'
