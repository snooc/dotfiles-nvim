-- Install lazy.nvim
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

-- Settings
vim.opt.termguicolors = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.wrap = false

vim.opt.scrolloff = 5

vim.g.mapleader = " "

-- File Indents
vim.cmd([[
  autocmd FileType javascript setlocal softtabstop=4 shiftwidth=4 expandtab
  autocmd FileType javascript.jsx setlocal softtabstop=4 shiftwidth=4 expandtab
  autocmd FileType c setlocal softtabstop=4 shiftwidth=4 expandtab
  autocmd FileType cpp setlocal softtabstop=4 shiftwidth=4 expandtab
  autocmd FileType make setlocal softtabstop=4 shiftwidth=4 tabstop=4 noexpandtab
  autocmd FileType yaml setlocal softtabstop=2 shiftwidth=2 expandtab
  autocmd FileType lua setlocal softtabstop=2 shiftwidth=2 expandtab
  autocmd FileType go setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
  autocmd FileType jenkinsfile setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

  autocmd BufNewFile,BufReadPost *.imd set filetype=markdown
  autocmd BufNewFile,BufReadPost .babelrc set filetype=json
  autocmd BufNewFile,BufReadPost *.gyp set filetype=json
  autocmd BufNewFile,BufReadPost .gitlab-ci set filetype=yaml
  autocmd BufNewFile,BufReadPost *.tpl set filetype=gotexttmpl
  autocmd FileType markdown set colorcolumn=120
]])

-- Plugins
require("lazy").setup({
  -- GitHub Dark Color Scheme
  {
    'projekt0n/github-nvim-theme',
    lazy = false,
    priority = 1000,
    config = function()
      require('github-theme').setup({
        options = {
          -- transparent = true,
        },
      })

      vim.cmd('colorscheme github_dark_dimmed')
    end,
  },

  -- Lualine
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          { "diagnostics" },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
        },

        lualine_x = {
          { "diff", symbols = { added = " ", modified = " ", removed = " " } },
        },
        lualine_y = {
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        },
        lualine_z = {
          "mode"
        }
      }
    },
    config = true
  },

  -- Oil
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
    keys = {
      { "-", "<CMD>Oil<CR>", { desc = "Open parent directory" } },
    },
  },

  -- Gitsigns
  {
    'lewis6991/gitsigns.nvim',
    opts = {},
  },

  -- Autopair
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {},
  },

  -- Blankline
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {}
  },

  -- UI Components
  {
    'stevearc/dressing.nvim',
    opts = {},
  },

  -- LSP and Auto Complete Chaos
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    lazy = true,
    config = false,
    init = function()
      -- Disable automatic setup, we are doing it manually
      vim.g.lsp_zero_extend_cmp = 0
      vim.g.lsp_zero_extend_lspconfig = 0
    end,
  },

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      { 'onsails/lspkind.nvim' },
      { 'L3MON4D3/LuaSnip' },
    },
    config = function()
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_cmp()

      local cmp = require('cmp')
      local cmp_action = lsp_zero.cmp_action()

      local nwd = require('nvim-web-devicons')

      cmp.setup({
        formatting = {
          format = function(entry, vim_item)
            if vim.tbl_contains({ 'path' }, entry.source.name) then
              local icon, hl_group = nwd.get_icon(entry:get_completion_item().label)
              if icon then
                vim_item.kind = icon
                vim_item.kind_hl_group = hl_group
                return vim_item
              end
            end
            return require('lspkind').cmp_format({ with_text = false })(entry, vim_item)
          end
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<CR>'] = cmp.mapping.confirm({ select = false }),

          ['<Tab>'] = cmp_action.luasnip_supertab(),
          ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
        })
      })
    end
  },

  -- LSP
  {
    'williamboman/mason.nvim',
    lazy = false,
    config = true,
  },

  {
    'neovim/nvim-lspconfig',
    cmd = {'LspInfo', 'LspInstall', 'LspStart'},
    event = {'BufReadPre', 'BufNewFile'},
    dependencies = {
      {'hrsh7th/cmp-nvim-lsp'},
      {'williamboman/mason-lspconfig.nvim'},
    },
    config = function()
      -- This is where all the LSP shenanigans will live
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_lspconfig()

      lsp_zero.on_attach(function(client, bufnr)
        -- see :help lsp-zero-keybindings
        -- to learn the available actions
        lsp_zero.default_keymaps({buffer = bufnr})
      end)

      require('mason-lspconfig').setup({
        ensure_installed = {
          'lua_ls',
          'gopls',
        },
        handlers = {
          lsp_zero.default_setup,
          lua_ls = function()
            -- (Optional) Configure lua language server for neovim
            local lua_opts = lsp_zero.nvim_lua_ls()
            require('lspconfig').lua_ls.setup(lua_opts)
          end,
        },
      })
    end
  }

}, {
  install = {
  },
  ui = {
    border = "rounded",
  }
})
