return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "folke/lazydev.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/nvim-cmp",
        -- Allows extra capabilities provided by nvim-cmp
        "saghen/blink.cmp",
        { "antosha417/nvim-lsp-file-operations", config = true },
        { "folke/neodev.nvim",                   opts = {} },
        ft = { "lua", "c", "cpp", "java" },
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
        -- Useful status updates for LSP.
        -- LSP and notify updates in the down right corner
        {
          "j-hui/fidget.nvim",
          opts = {
            notification = {
              override_vim_notify = true,
            },
          },
        },
      },
    },

    config = function()
      -- moved loading of jdtls into mason
      -- lspconfig.jdtls.setup({})

      local keymap = vim.keymap

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig-attach", {}),
        callback = function(event)
          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if not client then
            return
          end
          if client.supports_method("textDocument/documentHighlight") then
            local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("UserLspConfig-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
              end,
            })
          end -- endif client and supports_method(documentHighlight)

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client.supports_method("textDocument/inlayHint") then
            vim.keymap.set("n", "<leader>uh", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, { desc = "Toggle [U]i Inlay [H]ints" })
          end

          -- LSP based fzf supported keymaps
          -- Only register for buffers, where the LSP actually attached.
          vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("keymaps-lsp-attach", { clear = true }),
            callback = function()
              -- Jump to the definition of the word under your cursor.
              --  This is where a variable was first declared, or where a function is defined, etc.
              --  To jump back, press <C-t>.

              -- All of the following gX keybindings are a little more
              -- involved, as we are checking first if there is only one
              -- match. If there is we directly go there. Otherwise we open
              -- fzf-lua for the results.

              -- [G]oto [D]efinition(s)
              vim.keymap.set("n", "gd", function()
                local params = vim.lsp.util.make_position_params()
                vim.lsp.buf_request(0, "textDocument/definition", params, function(_, result)
                  local items = result
                  if type(result) == "table" and result.result then
                    items = result.result
                  end

                  if not items or vim.tbl_isempty(items) then
                    vim.notify("No definition found", vim.log.levels.ERROR)
                  elseif #items == 1 then
                    vim.lsp.buf.definition(params)
                  else
                    require("fzf-lua").lsp_definitions()
                  end
                end)
              end, { desc = "[G]oto [D]efinition(s)" })

              -- Unmap default gr* since 0.11
              local gr_mappings = { "grr", "gra", "gri", "grn" }
              for _, keymap in ipairs(gr_mappings) do
                pcall(function()
                  vim.keymap.del("n", keymap)
                end)
              end

              -- [G]oto [R]eference(s)
              vim.keymap.set("n", "gr", function()
                require("fzf-lua").lsp_references()
              end, { desc = "[G]oto [R]eference(s)" })

              -- [G]oto [I]mplementation(s)
              vim.keymap.set("n", "gI", function()
                local params = vim.lsp.util.make_position_params()
                vim.lsp.buf_request(0, "textDocument/implementation", params, function(_, result)
                  local items = result
                  if type(result) == "table" and result.result then
                    items = result.result
                  end

                  if not items or vim.tbl_isempty(items) then
                    vim.notify("No implementation found", vim.log.levels.ERROR)
                  elseif #items == 1 then
                    vim.lsp.buf.implementation(params)
                  else
                    require("fzf-lua").lsp_implementations()
                  end
                end)
              end, { desc = "[G]oto [I]mplementation(s)" })

              -- [G]oto [D]eclaration
              vim.keymap.set("n", "gD", function()
                -- Check if declaration is supported
                local clients = vim.lsp.get_active_clients({ bufnr = 0 })
                local has_support = false
                for _, client in ipairs(clients) do
                  if client.supports_method("textDocument/declaration") then
                    has_support = true
                    break
                  end
                end

                if not has_support then
                  vim.notify(
                    "LSP method textDocument/declaration not supported",
                    vim.log.levels.ERROR
                  )
                  return
                end

                local params = vim.lsp.util.make_position_params()
                vim.lsp.buf_request(0, "textDocument/declaration", params, function(_, result)
                  local items = result
                  if type(result) == "table" and result.result then
                    items = result.result
                  end

                  if not items or vim.tbl_isempty(items) then
                    vim.notify("No declaration found", vim.log.levels.ERROR)
                  elseif #items == 1 then
                    vim.lsp.buf.declaration(params)
                  else
                    require("fzf-lua").lsp_declarations()
                  end
                end)
              end, { desc = "[G]oto [D]eclaration" })

              -- Jump to the type of the word under your cursor.
              --  Useful when you're not sure what type a variable is and you want to see
              --  the definition of its *type*, not where it was *defined*.
              vim.keymap.set(
                "n",
                "<leader>D",
                require("fzf-lua").lsp_typedefs,
                { desc = "Type [D]efinition" }
              )

              -- Rename the variable under your cursor.
              --  Most Language Servers support renaming across files, etc.
              vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "[R]ename" })

              -- Execute a code action, usually your cursor needs to be on top of an error
              -- or a suggestion from your LSP for this to activate.
              vim.keymap.set(
                { "n", "x" },
                "<leader>ca",
                vim.lsp.buf.code_action,
                { desc = "[C]ode [A]ction" }
              )
            end, -- endof keymaps attach
          }) -- callback UserLspConfig-attach

          -- FZF related general keymaps
          local fzf = require("fzf-lua")
          keymap.set("n", "<leader>/", fzf.lgrep_curbuf, { desc = "[/] Live grep the current buffer" })
          keymap.set("n", "<leader>fB", fzf.builtin, { desc = "[f]ind [B]uiltin FZF" })
          keymap.set("n", "<leader>fb", fzf.buffers, { desc = "[f]ind existing [b]uffers" })

          -- Search in neovim config
          keymap.set("n", "<leader>fc", function()
            fzf.files({ cwd = vim.fn.stdpath("config") })
          end, { desc = "[f]ind Neovim [c]onfig files" })

          keymap.set("n", "<leader>fd", fzf.diagnostics_document, { desc = "[f]ind [d]iagnostics" })
          keymap.set("n", "<leader>ff", fzf.files, { desc = "[f]ind [f]iles" })
          keymap.set("n", "<leader>fG", fzf.live_grep, { desc = "[f]ind by live [G]rep" })
          keymap.set("n", "<leader>fh", fzf.helptags, { desc = "[f]ind [h]elp" })
          keymap.set("n", "<leader>fk", fzf.keymaps, { desc = "[f]ind [k]eymaps" })
          keymap.set("n", "<leader>fo", fzf.oldfiles, { desc = "[f]ind [o]ld files" })
          keymap.set("n", "<leader>fP", "<cmd>FzfDirectories<CR>", { desc = "[f]ind [P]aths" })
          keymap.set("n", "<leader>fp", fzf.grep_project, { desc = "[f]ind [p]roject by grep" })
          keymap.set("n", "<leader>fr", fzf.resume, { desc = "[f]ind [r]esume" })

          keymap.set(
            "n",
            "<leader>fS",
            require("fzf-lua").lsp_workspace_symbols,
            { desc = "[f]ind workspace [S]ymbols" }
          )
          keymap.set(
            "n",
            "<leader>fs",
            require("fzf-lua").lsp_document_symbols,
            { desc = "[f]ind document [s]ymbols" }
          )
          keymap.set("n", "<leader>fW", fzf.grep_cWORD, { desc = "fF]ind current [W]ORD" })
          keymap.set("n", "<leader>fw", fzf.grep_cword, { desc = "[f]ind current [w]ord" })

          -- Search in TODOs, FIXMEs, HACKs, via todo-comments.nvim
          keymap.set("n", "<leader>ft", function()
            require("todo-comments.fzf").todo()
          end, { desc = "[F]ind [T]odos, Fixmes, Hacks, ..." })

          -- Navigate between TODOs and such
          keymap.set("n", "]t", function()
            require("todo-comments").jump_next()
          end, { desc = "Next todo comment" })
          keymap.set("n", "[t", function()
            require("todo-comments").jump_prev()
          end, { desc = "Previous todo comment" })

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = { buffer = event.buf, silent = true }

          -- set keybinds with Telescope
          -- opts.desc = "Show LSP references"
          -- keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references
          --
          -- opts.desc = "Show LSP definitions"
          -- keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions
          --
          -- opts.desc = "Show LSP implementations"
          -- keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations
          --
          -- opts.desc = "Show LSP type definitions"
          -- keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions
          --
          -- opts.desc = "Show buffer diagnostics"
          -- keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

          -- set keybinds with lsp methods
          -- opts.desc = "Smart rename"
          -- keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

          -- opts.desc = "See available code actions"
          -- keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

          -- opts.desc = "Go to declaration"
          -- keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

          --
          -- set keybinds with diagnostics methods
          opts.desc = "Show line diagnostics"
          keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

          opts.desc = "Go to previous diagnostic"
          keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

          opts.desc = "Go to next diagnostic"
          keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

          opts.desc = "Show documentation for what is under cursor"
          keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

          opts.desc = "Restart LSP"
          keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
        end,
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then
            return
          end
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
              end,
            })
          end
        end,
      })

      -- can use cmp_nvim_lsp capabilities settings to lspconfig
      -- This should be executed before you configure any language server
      -- local lspconfig_defaults = require("lspconfig").util.default_config
      -- import cmp-nvim-lsp plugin
      -- used to enable autocompletion (assign to every lsp server config)
      --
      -- local cmp_nvim_lsp = require("cmp_nvim_lsp")
      -- local capabilities = cmp_nvim_lsp.default_capabilities()

      local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        -- require("cmp_nvim_lsp").default_capabilities()
        require("blink.cmp").get_lsp_capabilities()
      )

      local servers = {
        lua_ls = {},
        bashls = {},
        clangd = {},
      }
    end, -- endof config
  },
}
