return {
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    opts = {
      theme = "wave",
      background = {
        dark = "wave",
	light = "lotus",
      }
    },
    config = function(_, opts)
      require("kanagawa").setup(opts)
      vim.cmd([[colorscheme kanagawa]])
    end
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
        show_hidden = false,
        is_hidden_file = function (name, _)
	  return require("util").is_hidden_file(name)
        end,
      },
    },
    keys = {
      { "-", function() require("oil").toggle_float() end, desc = "Oil" },
    },
  },
}
