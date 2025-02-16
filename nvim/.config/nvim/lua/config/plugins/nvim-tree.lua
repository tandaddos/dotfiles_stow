return {
  "nvim-tree/nvim-tree.lua",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    local nvimtree = require("nvim-tree")

    -- recommended settings from nvim-tree documentation
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    nvimtree.setup({
      auto_reload_on_write = true,
      disable_netrw = true,
      hijack_netrw = true,
      hijack_cursor = false,
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = {
          -- set following to true if want explore to update to cwd
          enable = false,
        },
      },

      -- mappings = {
      --   list = {
      --     { key = { "l", "<CR>", "o" }, action = "edit" },
      --     { key = "h",                  action = "close_node" },
      --     { key = "v",                  action = "vsplit" },
      --   },
      -- },
      view = {
        width = 35,
        relativenumber = true,
        signcolumn = "yes",
      },
      -- change folder arrow icons
      renderer = {
        indent_markers = {
          enable = true,
        },
        icons = {
          glyphs = {
            folder = {
              arrow_closed = "", -- arrow when folder is closed
              arrow_open = "", -- arrow when folder is open
            },
          }, -- glyphs
          show = {
            git = true,
            folder = true,
            file = true,
            folder_arrow = true,
          }, -- show
        }, -- icons
        highlight_git = true,
        highlight_opened_files = "icon",
      }, -- renderer
      -- disable window_picker for explorer to work well with  window splits
      actions = {
        open_file = {
          window_picker = {
            enable = false,
          },
          quit_on_open = true,
        },
      },
      filters = {
        custom = { ".DS_Store" },
      },
      git = {
        ignore = false,
      },
    })

    -- set keymaps
    local keymap = vim.keymap
    keymap.set(
      "n",
      "<leader>ee",
      "<cmd>NvimTreeToggle<CR>",
      { noremap = true, silent = true, desc = "Toggle file explorer" }
    ) -- toggle file explorer
    keymap.set(
      "n",
      "<leader>ef",
      "<cmd>NvimTreeFindFileToggle<CR>",
      { desc = "Toggle file explorer on current file" }
    ) -- toggle file explorer on current file
    keymap.set(
      "n",
      "<leader>ec",
      "<cmd>NvimTreeCollapse<CR>",
      { noremap = true, silent = true, desc = "Collapse file explorer" }
    ) -- collapse file explorer
    keymap.set(
      "n",
      "<leader>er",
      "<cmd>NvimTreeRefresh<CR>",
      { noremap = true, silent = true, desc = "Refresh file explorer" }
    ) -- refresh file explorer
  end,
}
