-- Easily comment visual regions/lines
return {
  {
    "numToStr/Comment.nvim",
    opts = {},
    -- config = function()
    --   local optsCommentLine = { noremap = true, silent = true, desc = "[C]ode comment a [l]ine" }
    --   local optsCommentBlock = { noremap = true, silent = true, desc = "[C]de comment a [b]lock" }
    --   vim.keymap.set("n", "<leader>Cl", require("Comment.api").toggle.linewise.current, optsCommentLine)
    --   vim.keymap.set("n", "<leader>Cb", require("Comment.api").toggle.blockwise.current, optsCommentBlock)
    --   vim.keymap.set(
    --     "v",
    --     "<leader><M-l>",
    --     "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
    --     optsCommentLine
    --   )
    --   vim.keymap.set(
    --     "v",
    --     "<leader><M-b>",
    --     "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
    --     optsCommentBlock
    --   )
    -- end,
  },
}
