return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    preset = "helix", -- classic | modern | helix
  },
  icons = {
    rules = false,
    breadcrumb = " ", -- symbol used in the command line area that shows your active key combo
    separator = "󱦰  ", -- symbol used between a key and it's label
    group = "󰹍 ", -- symbol prepended to a group
  },
  presets = {
    operators = true,  -- adds help for operators like d, y, ...
    motions = true,    -- adds help for motions
    text_objects = true, -- help for text objects triggered after entering an operator
    windows = true,    -- default bindings on <c-w>
    nav = true,        -- misc bindings to work with windows
    z = true,          -- bindings for folds, spelling and others prefixed with z
    g = true,          -- bindings for prefixed with g
    marks = true,      -- shows a list of your marks on ' and `
    registers = true,  -- shows your registers on " in NORMAL or <C-r> in INSERT mode
  },
  config = function()
    -- gain access to the which key plugin
    local which_key = require("which-key")

    -- call the setup function with default properties
    which_key.setup()

    -- Register prefixes for the different key mappings we have setup previously
    which_key.add({
      {
        "<leader>C",
        group = "Code",
        expand = function()
          return require("which-key.extras").expand.buf()
        end,
      },
      {
        "<leader>D",
        group = "Debug",
        expand = function()
          return require("which-key.extras").expand.buf()
        end,
      },
      {
        "<leader>e",
        group = "explorer",
        expand = function()
          return require("which-key.extras").expand.buf()
        end,
      },
      {
        "<leader>f",
        group = "Find Files",
        expand = function()
          return require("which-key.extras").expand.buf()
        end,
      },
      {
        "<leader>h",
        group = "h git ops",
        expand = function()
          return require("which-key.extras").expand.buf()
        end,
      },
      {
        "<leader>l",
        group = "lazygit",
        expand = function()
          return require("which-key.extras").expand.buf()
        end,
      },
      {
        "<leader>m",
        group = "misc",
        expand = function()
          return require("which-key.extras").expand.buf()
        end,
      },
      {
        "<leader>G",
        group = "Git",
        expand = function()
          return require("which-key.extras").expand.buf()
        end,
      },
      {
        "<leader>s",
        group = "Split windows",
        expand = function()
          return require("which-key.extras").expand.buf()
        end,
      },
      {
        "<leader>S",
        group = "Sessions",
        expand = function()
          return require("which-key.extras").expand.buf()
        end,
      },
      {
        "<leader>t",
        group = "Tabs",
        expand = function()
          return require("which-key.extras").expand.buf()
        end,
      },
      {
        "<leader>T",
        group = "Telescope",
        expand = function()
          return require("which-key.extras").expand.buf()
        end,
      },
      {
        "<leader>v",
        group = "View Files",
        expand = function()
          return require("which-key.extras").expand.buf()
        end,
      },
      --   ["<leader>J"] = { name = "[J]ava", _ = "which_key_ignore" },
      --   ["<leader>w"] = { name = "[W]indow", _ = "which_key_ignore" },
    })
  end,
}
