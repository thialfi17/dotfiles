-- Add command to install Paq (https://oroques.dev/notes/neovim-init/)
vim.cmd('command! InstallPaq !git clone https://github.com/savq/paq-nvim.git "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/opt/paq-nvim')

-- Load Paq into Neovim
vim.cmd('packadd paq-nvim')

require "paq" {
    -- Paq manages itself
    {'savq/paq-nvim', opt=true};

    -- Syntax plugins
    {'nvim-treesitter/nvim-treesitter'};
    {'nvim-treesitter/playground'};
    {'nvim-treesitter/nvim-treesitter-refactor'};
    {'sgur/vim-textobj-parameter'};
    {'kana/vim-textobj-user'};
    {'neovim/nvim-lspconfig'};

    -- Various libraries/common functions
    {'nvim-lua/popup.nvim'};
    {'nvim-lua/plenary.nvim'};

    -- Autocomplete
    {'hrsh7th/nvim-compe'};

    -- Search
    {'nvim-telescope/telescope.nvim'};

    -- Appearance
    {'kyazdani42/nvim-web-devicons'};
    {'sainnhe/gruvbox-material'};
    {'lukas-reineke/indent-blankline.nvim'};
    {'lewis6991/gitsigns.nvim'};
    {'folke/zen-mode.nvim'};
    {'romgrk/barbar.nvim'};

    -- Formatting
    {'godlygeek/tabular'};
    {'AckslD/nvim-revJ.lua'};
    {'tpope/vim-surround'};
    {'b3nj5m1n/kommentary'};

    -- Language Specific
    {'lervag/vimtex'};

    -- Other
    {'sindrets/diffview.nvim'};
    {'folke/which-key.nvim'};
    {'folke/trouble.nvim'};
    {'folke/todo-comments.nvim'};
    -- TODO: Look into lsp-saga as an alternative
    {'ray-x/lsp_signature.nvim'};
    {'kyazdani42/nvim-tree.lua'};
    {'phaazon/hop.nvim'};
}

-- Enable colorscheme
vim.g.gruvbox_material_background = 'hard'
vim.g.gruvbox_material_palette = 'original'
vim.g.gruvbox_material_sign_column_background = 'none'

vim.cmd("colorscheme gruvbox-material")

-- Plugin configurations/initialisations
require('myconf.plugins.treesitter')
require('todo-comments').setup{}
require('myconf.plugins.telescope')
require('myconf.plugins.lsp-config')
require('myconf.plugins.gitsigns')
require('myconf.plugins.compe')
require('myconf.plugins.diffview')
require('revj').setup{}
require('myconf.plugins.kommentary')
require('myconf.plugins.which-key')
require('myconf.plugins.trouble')
require('myconf.plugins.zenmode')
require('myconf.plugins.nvim-tree')
require('lsp_signature').on_attach()
require('hop').setup()

-- Configure barbar
vim.g.bufferline = {animation = false}

-- Configure NvimTree
vim.g.nvim_tree_root_folder_modifier = ':~:t'
vim.g.nvim_tree_window_picker_exclude = { filetype = { "Trouble", }, }

-- Configure vimtex to use the right viewer
vim.g.vimtex_view_method = 'zathura'
