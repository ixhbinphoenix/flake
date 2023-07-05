-- Load this using require('plugins')

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
    requires = {
      {'nvim-lua/plenary.nvim'}
    }
  }
  use {
    'nathom/filetype.nvim',
    config = function ()
      require("filetype").setup({
        overrides = {
          extensions = {
            hx = "haxe",
            astro = "astro",
            kdl = "kdl"
          }
        },
      })
    end
  }
  use 'rhaiscript/vim-rhai'
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  }
  use 'christoomey/vim-tmux-navigator'
  use {
    'nvim-treesitter/nvim-treesitter',
    {run = ":TSUpdate"}
  }
  use 'nvim-treesitter/playground'
  use 'theprimeagen/harpoon'
  use 'mbbill/undotree'
  use 'tpope/vim-fugitive'
  use {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v1.x',
    requires = {
      -- LSP
      {'neovim/nvim-lspconfig'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},
      -- Autocompletion
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'hrsh7th/cmp-buffer'},
      {'hrsh7th/cmp-path'},
      {'hrsh7th/cmp-nvim-lua'},

      {'saadparwaiz1/cmp_luasnip'},
      -- Snippets
      {'L3MON4D3/LuaSnip'},
    }
  }
  use 'andweeb/presence.nvim'
  use 'elkowar/yuck.vim'
  use 'wuelnerdotexe/vim-astro'
  use 'kyazdani42/nvim-web-devicons'
  use {
    'catppuccin/nvim',
    as = 'catppuccin',
    config = function ()
      vim.g.catppuccin_flavour = "mocha"
      require('catppuccin').setup()
      vim.cmd("colorscheme catppuccin")
    end
  }
  use {
    'nanozuki/tabby.nvim',
    config = function ()
      require('tabby').setup({
        tabline = require("tabby.presets").active_tab_with_wins
      })
    end
  }
  use 'feline-nvim/feline.nvim'
  use { 'kyazdani42/nvim-tree.lua', requires = { 'kyazdani42/nvim-web-devicons' } }
  use {
    's1n7ax/nvim-terminal',
    config = function ()
      vim.o.hidden = true
      require('nvim-terminal').setup()
    end
  }
  use 'andweeb/presence.nvim'
  
  if packer_bootstrap then
    require('packer').sync()
  end
end)
