-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
   -- Quality of Life

   -- Packer can manage itself
   use 'wbthomason/packer.nvim'

   use {
      'nvim-telescope/telescope.nvim', tag = '0.1.8',
      -- or                            , branch = '0.1.x',
      requires = { {'nvim-lua/plenary.nvim'} }
   }

   -- Color Themes
   vim.cmd("colorscheme habamax")

   use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate'

   }
   use 'nvim-treesitter/playground'
   use "nvim-lua/plenary.nvim" -- don't forget to add this 
                              -- one if you don't have it yet!
   use {
      "ThePrimeagen/harpoon",
      branch = "harpoon2",
      requires = { {"nvim-lua/plenary.nvim"} }
   }
   use ('mbbill/undotree') --literally let's you do an undo tree
   use ('tpope/vim-fugitive') -- greatest git interface for neovim

   -- LSP Stuff
   use { 'neovim/nvim-lspconfig' }
   use { 'hrsh7th/nvim-cmp' }
   use { 'hrsh7th/cmp-nvim-lsp' }
   use { 'L3MON4D3/LuaSnip' }
   use { 'saadparwaiz1/cmp_luasnip' }
   use { 'williamboman/mason.nvim' }
   use { 'williamboman/mason-lspconfig.nvim' }

   require('mason').setup({
      opts = {
         ensure_installed = {
            "clangd",
            "clang-format",
         }
      }
   })
   require('mason-lspconfig').setup({
      automatic_installation = true,
      automatic_enable = true
   })
   require('luasnip.loaders.from_vscode').lazy_load()
   
   -- Code Snippets
   local cmp = require('cmp')
   cmp.setup({
      snippet = {
	    expand = function(args)
	      require('luasnip').lsp_expand(args.body)
	    end
	  },

	  mapping = { 
	    ['<Tab>'] = cmp.mapping.select_next_item(),
	    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
	    ['<CR>'] = cmp.mapping.confirm({select = false}),
	  },

	  sources = {
	    { name = 'nvim_lsp' },
	    { name = 'luasnip' },
	    { name = 'buffer' },
	  }
	})

   -- Oil a file navigator
   use("stevearc/oil.nvim")

   require'nvim-treesitter.configs'.setup {
      ensure_installed = { "c", "cpp", "vim", "typescript", "javascript" },

      auto_install = true,

      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      }
   }

   --Debugger
   use "mfussenegger/nvim-dap"
   use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"}}
   use { "thehamsta/nvim-dap-virtual-text", requires = { "mfussenegger/nvim-dap" }}

  -- Avante, bassically cursor --
   
  -- Required plugins
  -- use 'MunifTanjim/nui.nvim'
  -- use 'MeanderingProgrammer/render-markdown.nvim'

  -- Optional dependencies
  -- use 'nvim-tree/nvim-web-devicons' -- or use 'echasnovski/mini.icons'
  -- use 'HakonHarnes/img-clip.nvim'
  -- use 'zbirenbaum/copilot.lua'
  -- use 'stevearc/dressing.nvim' -- for enhanced input UI
  -- use 'folke/snacks.nvim' -- for modern input UI
  -- Avante.nvim with build process
  -- use {
    -- 'yetone/avante.nvim',
    -- branch = 'main',
    -- run = 'make',
    -- requires = {
      -- "nvim-lua/plenary.nvim",
      -- "MunifTanjim/nui.nvim",
      -- "MeanderingProgrammer/render-markdown.nvim",
      -- "nvim-tree/nvim-web-devicons",
    -- },
    -- config = function()
      -- require('avante').setup({
        -- provider = "gemini",
        -- providers = {
          -- gemini = {
            -- model = "gemini-2.5-flash",
            -- api_key_name = "GOOGLE_API_KEY",
            -- extra_request_body = {
              -- temperature = 0,
            -- },
          -- },
        -- },
      -- })
      -- print("Avante loaded with provider: gemini")
    -- end,
  -- }
end)
