-- Add command to install Paq (https://oroques.dev/notes/neovim-init/)
vim.cmd('command! InstallPaq !git clone https://github.com/savq/paq-nvim.git "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/opt/paq-nvim')

-- Load Paq into Neovim
vim.cmd('packadd paq-nvim')

-- Load the module
local paq = require('paq-nvim').paq

-- Add other plugins
paq {'savq/paq-nvim', opt=true}
paq {'nvim-treesitter/nvim-treesitter'}
paq {'nvim-treesitter/nvim-treesitter-refactor'}
paq {'neovim/nvim-lspconfig'}
paq {'nvim-lua/plenary.nvim'}
paq {'nvim-lua/popup.nvim'}
paq {'nvim-telescope/telescope.nvim'}
paq {'morhetz/gruvbox'}
paq {'kyazdani42/nvim-web-devicons'}
paq {'godlygeek/tabular'}
paq {'hrsh7th/nvim-compe'}
paq {'lukas-reineke/indent-blankline.nvim', branch='lua'}
paq {'lewis6991/gitsigns.nvim'}

require('myconf.plugins.telescope')
require('myconf.plugins.gruvbox')
require('myconf.plugins.treesitter')
require('myconf.plugins.lsp-config')
require('myconf.plugins.gitsigns')
require('myconf.plugins.compe')

vim.cmd("au! VimEnter * colorscheme gruvbox")
