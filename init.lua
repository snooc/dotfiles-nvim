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
local MiniDeps = require("mini.deps")
MiniDeps.setup({ path = { package = path_package } })

-- mini.deps Helpers
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
  require("settings")
  require("mappings")
end)

now(function()
  add("echasnovski/mini.notify")
  local MiniNotify = require("mini.notify")
  MiniNotify.setup({
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
  local MiniFiles = require("mini.files")
  MiniFiles.setup({
    options = {
      use_as_default_explorer = true,
    },
  })

  vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesWindowOpen",
    callback = function(args)
      local win_id = args.data.win_id
      vim.api.nvim_win_set_config(win_id, { border = "double" })
    end,
  })

  local go_in_plus = function() MiniFiles.go_in({ close_on_file = true }) end
  vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesBufferCreate",
    callback = function(args)
      local buf_id = args.data.buf_id
      -- Tweak left-hand side of mapping to your liking
      vim.keymap.set("n", "<CR>", go_in_plus, { buffer = buf_id })
    end,
  })

  local show_dotfiles = true
  local filter_show = function(fs_entry) return true end
  local filter_hide = function(fs_entry) return not vim.startswith(fs_entry.name, ".") end
  local toggle_dotfiles = function()
    show_dotfiles = not show_dotfiles
    local new_filter = show_dotfiles and filter_show or filter_hide
    MiniFiles.refresh({ content = { filter = new_filter } })
  end
  vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesBufferCreate",
    callback = function(args)
      local buf_id = args.data.buf_id
      -- Tweak left-hand side of mapping to your liking
      vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id })
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
  local MiniPick = require("mini.pick")
  MiniPick.setup({
    window = {
      config = {
        border = "double",
      },
    },
    options = {
      content_from_bottom = true,
    },
  })
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

later(function()
  add("echasnovski/mini.trailspace")
  require("mini.trailspace").setup({})
end)

-- LSP/Lint/Format
now(function()
  add("williamboman/mason.nvim")
  require("mason").setup({
    ui = {
      border = "double",
    },
  })
end)

now(function()
  add("neovim/nvim-lspconfig")
  require("lsp")
end)

later(function()
  add({
    source = "nvim-treesitter/nvim-treesitter",
    checkout = "master",
    monitor = "main",
    hooks = { post_checkout = function() vim.cmd("TSUpdate") end },
  })
  require("treesitter")
end)

later(function()
  add("stevearc/conform.nvim")
  require("formatting")
end)

later(function()
  add("zbirenbaum/copilot.lua")
  require("copilot").setup({
    panel = {
      enabled = true,
      auto_refresh = true,
    },
  })
end)
