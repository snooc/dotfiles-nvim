return {
  {
    'marko-cerovac/material.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('material').setup({
        high_visibility = {
          darker = true,
        },
        plugins = {
          'gitsigns',
          'nvim-web-devicons',
          'nvim-notify',
          'telescope',
        }
      })

      vim.g.material_style = 'palenight'

      vim.cmd('colorscheme material')
    end,
  },

  {
    'stevearc/oil.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons'
    },
    opts = {
      float = {
        padding = 8,
        max_width = 80,
        max_height = 80,
      },
      view_options = {
        show_hidden = true,
        is_hidden_file = function (name, _)
          local visibleHidden = {
            '.env',
            '.github',
            '.gitignore',
            '.helmignore',
            '.makerc',
            '.tool-versions',
          }

          for _, v in ipairs(visibleHidden) do
            if (name == v) then return false end
          end

          return vim.startswith(name, ".")
        end,
      },
    },
    keys = {
      { "-", function() require("oil").toggle_float() end, desc = "Oil" },
    },
  },

  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons'
    },
    event = 'VeryLazy',
    opts = {
      theme = 'auto',
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          { "diagnostics" },
          { "filetype", icon_only = false, separator = "", padding = { left = 1, right = 0 } },
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

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  }
}
