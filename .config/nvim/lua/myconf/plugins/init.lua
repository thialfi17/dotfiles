-- Add command to install Paq (https://oroques.dev/notes/neovim-init/)
vim.cmd('command! InstallPaq !git clone https://github.com/savq/paq-nvim.git "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/opt/paq-nvim')

-- Load Paq into Neovim
vim.cmd('packadd paq-nvim')

-- Load the module
local paq = require('paq-nvim').paq

-- Paq manages itself
paq {'savq/paq-nvim', opt=true}
-- Various libraries/common functions
paq {'nvim-lua/popup.nvim'}
paq {'nvim-lua/plenary.nvim'}

-- Syntax plugins
paq {'nvim-treesitter/nvim-treesitter'}
paq {'nvim-treesitter/nvim-treesitter-refactor'}
paq {'sgur/vim-textobj-parameter'}
paq {'kana/vim-textobj-user'}
paq {'neovim/nvim-lspconfig'}

-- Autocomplete
paq {'hrsh7th/nvim-compe'}

-- Search
paq {'nvim-telescope/telescope.nvim'}

-- Appearance
paq {'kyazdani42/nvim-web-devicons'}
paq {'sainnhe/gruvbox-material'}
paq {'lukas-reineke/indent-blankline.nvim', branch='lua'}
paq {'lewis6991/gitsigns.nvim'}

-- Formatting
paq {'godlygeek/tabular'}
paq {'AckslD/nvim-revJ.lua'}
paq {'tpope/vim-surround'}

-- Language Specific
paq {'lervag/vimtex'}

-- Other
paq {'sindrets/diffview.nvim'}

-- Enable colorscheme
vim.g.gruvbox_material_background = 'hard'
vim.g.gruvbox_material_palette = 'original'
vim.g.gruvbox_material_sign_column_background = 'none'
vim.cmd("colorscheme gruvbox-material")

-- Plugin configurations/initialisations
require('myconf.plugins.telescope')
require('myconf.plugins.treesitter')
require('myconf.plugins.lsp-config')
require('myconf.plugins.gitsigns')
require('myconf.plugins.compe')
require('myconf.plugins.diffview')
require('revj').setup{}

-- Configure vimtex to use the right viewer
vim.g.vimtex_view_method = 'zathura'
