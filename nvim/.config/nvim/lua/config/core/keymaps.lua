local keymap = vim.keymap

-- source current file
keymap.set("n", "<space><space>x", "<cmd>source %<CR>", { desc = "source current file" })

-- run lua commands
keymap.set({ "n", "v" }, "<space>x", ":lua", { desc = "run lua command" })

-- jk = escape
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search higlights
keymap.set("n", "<leader>mnh", ":nohl<CR>", { desc = "[m]isc [n]o search [h]ighlights" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- make pretty format per lsp
keymap.set({ "n", "v" }, "<leader>mp", function()
  vim.lsp.buf.format()
end, { desc = "prettify" })

keymap.set({ "n", "v" }, "<leader><", "<gv", { desc = "Format to left" })  -- split window vertically
keymap.set({ "n", "v" }, "<leader>>", ">gv", { desc = "Format to right" }) -- split window vertically

-- window management
keymap.set("n", "<Up>", "<Nop>", { desc = "Noop Up" })       -- Unused Up arrow
keymap.set("n", "<Down>", "<Nop>", { desc = "Noop Dow" })    -- Unused Down arrow
keymap.set("n", "<Left>", "<Nop>", { desc = "Noop Left" })   -- Unused Left arrow
keymap.set("n", "<Right>", "<Nop>", { desc = "Noop Right" }) -- Unused Down Right

-- 'split windows' cmds begin with 's'
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })     -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })   -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })      -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })              -- move to left window
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to down window" })              -- move to down window
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to up window" })                -- move to up window
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })             -- move to right window

keymap.set("n", "<M-j>", "<C-w>l", { desc = "Resize window" })                    -- resize window
keymap.set("n", "<M-k>", "<C-w>k", { desc = "Resize window" })                    -- resize window
keymap.set("n", "<M-h>", "<C-w>h", { desc = "Resize window" })                    -- resize window
keymap.set("n", "<M-l>", "<C-w>l", { desc = "Resize window" })                    -- resize window

-- tab navigation
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })                     -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })              -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })                     --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })                 --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- buffer navigation
keymap.set("n", "<leader><TAB>", "<cmd>bnext<CR>", { desc = "Move to next tab" })           -- move to next buffer
keymap.set("n", "<leader><S-TAB>", "<cmd>bprevious<CR>", { desc = "Move to previous tab" }) -- move to previous  buffer

-- view files - xxd usage
keymap.set("n", "<leader>vb", ":%!xxd -b<CR>", { desc = "View file as binary" })           -- increment
keymap.set("n", "<leader>vh", ":%!xxd -h<CR>", { desc = "View file as hex" })              -- increment
keymap.set("n", "<leader>vr", ":%!xxd -r<CR>", { desc = "Revert file to previous forma" }) -- increment

-- show cwd
vim.keymap.set({ "n", "v" }, "<leader>vd", ":lua = vim.uv.cwd()<CR>", { desc = "show current working directory" })

-- Oil
vim.keymap.set("n", "-", "<cmd>Oil --float<CR>", { desc = "Open Parent Directory in Oil" })
