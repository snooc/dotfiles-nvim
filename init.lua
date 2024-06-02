-- Bootstrap mini.deps
local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/echasnovski/mini.nvim",
    mini_path,
  }
  vim.fn.system(clone_cmd)
  vim.cmd("packadd mini.nvim | helptags ALL")
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end
require("mini.deps").setup({ path = { package = path_package } })

-- mini.deps Helpers
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
  require("settings")
  require("mappings")
end)

now(function()
  add("echasnovski/mini.notify")
  require("mini.notify").setup({
    window = {
      config = {
        border = "double",
      },
    },
  })

  vim.notify = MiniNotify.make_notify()
end)

-- Colorscheme
now(function()
  add("marko-cerovac/material.nvim")

  require("material").setup({})
  vim.g.material_style = "palenight"

  vim.cmd("colorscheme material")
end)

-- Deps
now(function() add("nvim-tree/nvim-web-devicons") end)
now(function() add("nvim-lua/plenary.nvim") end)

now(function()
  add("echasnovski/mini.statusline")
  require("mini.statusline").setup({})
end)

now(function()
  add("echasnovski/mini.tabline")
  require("mini.tabline").setup({})
end)

now(function()
  add("echasnovski/mini.starter")
  require("mini.starter").setup({})
end)

-- Files
later(function()
  add("echasnovski/mini.files")
  require("mini.files").setup({})

  vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesWindowOpen",
    callback = function(args)
      local win_id = args.data.win_id
      vim.api.nvim_win_set_config(win_id, { border = "double" })
    end,
  })

  local mini_files_toggle = function()
    if not MiniFiles.close() then MiniFiles.open() end
  end
  vim.keymap.set("n", "-", function() mini_files_toggle() end, { desc = "Mini File Explorer" })
end)

-- Git
now(function()
  add("echasnovski/mini.diff")
  require("mini.diff").setup({})
end)

later(function()
  add("echasnovski/mini-git")
  require("mini.git").setup({})
end)

later(function()
  require("mini.pick").setup({ window = { config = { border = "double" } } })
  vim.ui.select = MiniPick.ui_select
  vim.keymap.set("n", ",", [[<Cmd>Pick buf_lines scope='current'<CR>]], { nowait = true })
end)

later(function()
  add("echasnovski/mini.extra")
  require("mini.extra").setup({})
end)

-- Completion
later(function()
  add("echasnovski/mini.completion")
  require("mini.completion").setup({
    window = {
      info = { border = "double" },
      signature = { border = "double" },
    },
  })
  vim.keymap.set("i", "<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true })
  vim.keymap.set("i", "<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })

  local keys = {
    ["cr"] = vim.api.nvim_replace_termcodes("<CR>", true, true, true),
    ["ctrl-y"] = vim.api.nvim_replace_termcodes("<C-y>", true, true, true),
    ["ctrl-y_cr"] = vim.api.nvim_replace_termcodes("<C-y><CR>", true, true, true),
  }

  _G.cr_action = function()
    if vim.fn.pumvisible() ~= 0 then
      -- If popup is visible, confirm selected item or add new line otherwise
      local item_selected = vim.fn.complete_info()["selected"] ~= -1
      return item_selected and keys["ctrl-y"] or keys["ctrl-y_cr"]
    else
      -- If popup is not visible, use plain `<CR>`. You might want to customize
      -- according to other plugins. For example, to use 'mini.pairs', replace
      -- next line with `return require('mini.pairs').cr()`
      return keys["cr"]
    end
  end

  vim.keymap.set("i", "<CR>", "v:lua._G.cr_action()", { expr = true })
end)

later(function()
  add("echasnovski/mini.cursorword")
  require("mini.cursorword").setup({})
end)

-- LSP/Lint/Format
later(function()
  add("williamboman/mason.nvim")
  require("mason").setup({
    ui = {
      border = "double",
    },
  })
end)

later(function()
  add("stevearc/conform.nvim")
  require("conform").setup({
    formatters_by_ft = {
      lua = { "stylua" },
      go = { "goimports", "gofmt" },
      javascript = { { "prettierd", "prettier" } },
      python = { { "isort", "black" } },
      ["*"] = { "codespell" },
      ["_"] = { "trim_whitespace" },
    },
    format_on_save = {
      lsp_fallback = true,
      timeout_ms = 500,
    },
  })
end)
