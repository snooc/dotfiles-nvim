return {
  {
    "marko-cerovac/material.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      high_visibility = {
        darker = true,
      },
      plugins = {
        "gitsigns",
        "nvim-cmp",
        "nvim-notify",
        "nvim-web-devicons",
        "telescope",
        "trouble",
      },
    },
    config = function(_, opts)
      require("material").setup(opts)
      vim.g.material_style = "palenight"
      vim.cmd([[colorscheme material]])
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    event = "VeryLazy",
    opts = {
      theme = "auto",
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
          { "copilot" },
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        },
        lualine_z = {
          "mode",
        },
      },
    },
  },

  {
    "stevearc/oil.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      float = {
        padding = 8,
        max_width = 80,
        max_height = 80,
      },
      view_options = {
        show_hidden = false,
        is_hidden_file = function(name, _) return require("util").is_hidden_file(name) end,
      },
    },
    keys = {
      { "-", function() require("oil").toggle_float() end, desc = "Oil" },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },

  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {},
    keys = {
      { "<leader>\\", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
      {
        "<leader>\\d",
        function()
          local Terminal = require("toggleterm.terminal").Terminal
          local lazydocker = Terminal:new({
            cmd = "lazydocker",
            hidden = true,
            direction = "float",
            float_opts = {
              border = "double",
            },
          })

          lazydocker:toggle()
        end,
        desc = "Toggle lazydocker in Terminal",
      },
      {
        "<leader>\\g",
        function()
          local Terminal = require("toggleterm.terminal").Terminal
          local lazydocker = Terminal:new({
            cmd = "lazygit",
            hidden = true,
            direction = "float",
            float_opts = {
              border = "double",
            },
          })

          lazydocker:toggle()
        end,
        desc = "Toggle lazydocker in Terminal",
      },
      {
        "<leader>\\k",
        function()
          local Terminal = require("toggleterm.terminal").Terminal
          local lazydocker = Terminal:new({
            cmd = "k9s",
            hidden = true,
            direction = "float",
            float_opts = {
              border = "double",
            },
          })

          lazydocker:toggle()
        end,
        desc = "Toggle lazydocker in Terminal",
      },
    },
  },

  {
    "nvim-telescope/telescope.nvim",
    opts = {},
    keys = {
      { "<leader><space>", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>,", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Switch Buffers" },
      { "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
    },
  },
}
