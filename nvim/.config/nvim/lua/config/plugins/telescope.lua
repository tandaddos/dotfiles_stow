return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-tree/nvim-web-devicons",
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        -- This will not install any breaking changes.
        -- For major updates, this must be adjusted manually.
        version = "^1.0.0",
      },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local builtins = require("telescope.builtin")
      local lga = require("telescope-live-grep-args.actions")

      require("config.telescope.multigrep").setup()

      telescope.setup({
        defaults = {
          path_display = { "smart" }, -- could be smart|truncate
          mappings = {
            i = {
              -- navigation within find result list
              -- default <C-n> and <C-p> and <C-c> are preserved
              ["<C-k>"] = actions.move_selection_previous,                -- move to previous result
              ["<C-j>"] = actions.move_selection_next,                    -- move to next result
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- send to quick fix list
            },
          },
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
          },
          prompt_prefix = "🔍 ",
          selection_caret = " ",
          entry_prefix = "  ",
          initial_mode = "insert",
          selection_strategy = "reset",
          sorting_strategy = "descending",
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              mirror = false,
              preview_width = 0.6,
            },
            vertical = {
              mirror = false,
            },
          }, -- for layout_config
          file_sorter = require("telescope.sorters").get_fuzzy_file,
          file_ignore_patterns = {},
          generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
          winblend = 0,
          border = {},
          borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
          color_devicons = true,
          use_less = true,
          set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
          file_previewer = require("telescope.previewers").vim_buffer_cat.new,
          grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
          qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
          buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
        }, -- for defaults
        extensions = {
          live_grep_args = {
            auto_quoting = true, -- enable/disable auto-quoting
            -- define mappings, e.g.
            mappings = {   -- extend mappings
              i = {
                -- mypromt --> "mypromt"
                ["<C-k>"] = lga.quote_prompt(),

                -- myprompt --> "myprompt --iglob"
                ["<C-i>"] = lga.quote_prompt({ postfix = " --iglob " }),

                -- myprompt --> "mypromt --t" -- this is filter by file type
                ["<C-t"] = lga.quote_prompt({ postfix = " -t " }),

                -- freeze the current list and start a fuzzy search in the frozen list
                ["<C-space>"] = actions.to_fuzzy_refine,
              },
            },
            -- ... also accepts theme settings, for example:
            -- theme = "dropdown", -- use dropdown theme
            -- theme = { }, -- use own theme spec
            -- layout_config = { mirror=true }, -- mirror preview pane
          }, -- live grep args
        }, -- extensions
      }) -- for setup

      telescope.load_extension("fzf")
      telescope.load_extension("file_browser")
      telescope.load_extension("ui-select")
      telescope.load_extension("live_grep_args")

      -- set keymap
      local keymap = vim.keymap
      keymap.set(
        "n",
        "<leader>fbi",
        builtins.find_files,
        { noremap = true, silent = true, desc = "Telescope builtin find files" }
      )
      keymap.set(
        "n",
        "<leader>ff",
        "<cmd>Telescope find_files<cr>",
        { noremap = true, silent = true, desc = "Telescope fuzzy find files in cwd" }
      )
      keymap.set(
        "n",
        "<leader>fr",
        "<cmd>Telescope oldfiles<cr>",
        { noremap = true, silent = true, desc = "Telescope fuzzy find recent files" }
      )
      keymap.set(
        "n",
        "<leader>fl",
        "<cmd>Telescope live_grep<cr>",
        { noremap = true, silent = true, desc = "Telescope livegrep string in cwd" }
      )
      keymap.set(
        "n",
        "<leader>fg",
        "<cmd>Telescope grep_string<cr>",
        { noremap = true, silent = true, desc = "Telescope grep string under cursor in cwd" }
      )
      keymap.set(
        "n",
        "<leader>fbu",
        "<cmd>Telescope buffers<cr>",
        { noremap = true, silent = true, desc = "Telescope list buffers" }
      )
      keymap.set(
        "n",
        "<leader>fh",
        "<cmd>Telescope help_tags<cr>",
        { noremap = true, silent = true, desc = "Telescope list tags" }
      )

      -- search files in nvim config dir
      keymap.set("n", "<leader>fc", function()
        builtins.find_files({
          cwd = vim.fn.stdpath("config"),
        })
      end, { desc = "search nvim config" })

      -- search nvim packages files
      keymap.set("n", "<leader>fp", function()
        builtins.find_files({
          cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy"),
        })
      end, { desc = "search nvim packages" })

      -- livegrep with args
      --  search_dirs	= Directory/directories/files to search.
      --                Paths are expanded and appended to the grep command.
      --
      --  Prompt                    Arg                     Description
      --  ========================  ======================  ============
      --  foo bar	                  foo bar	                search for „foo bar“
      --  "foo bar"                 baz	foo bar, baz	      search for „foo bar“ in dir „baz“
      --  --no-ignore "foo bar	    --no-ignore, foo bar	  search for „foo bar“ ignoring ignores
      --  "foo" --iglob **/test/**	search for „foo“ in
      --                            any „test“ path
      --  "foo" ../other-project	  foo, ../other-project	  search for „foo“
      --                                                    in ../other-project
      keymap.set("n", "<leader>fml", function()
        telescope.extensions.live_grep_args.live_grep_args()
      end, { desc = "Telescope livegrep with args" })
    end,
  },
}
