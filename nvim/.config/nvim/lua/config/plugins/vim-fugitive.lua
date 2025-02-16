return {
  {
    "tpope/vim-fugitive",
    config = function()
      local keymap = vim.keymap

      -- execute a Git command
      keymap.set({ "n" }, "<leader>Gx", "<cmd>Git <cr>", { desc = "[G]it e[x]ecute a cmd" })

      -- Set a vim motion to <Space> + g + b to view the most recent contributers to the file
      vim.keymap.set("n", "<leader>Gb", ":Git blame<cr>", { desc = "[G]it [B]lame" })

      -- Set a vim motion to <Space> + g + <Shift>A to all files changed to the staging area
      vim.keymap.set("n", "<leader>GA", ":Git add .<cr>", { desc = "[G]it Add [A]ll" })

      -- Set a vim motion to <Space> + g + a to add the current file and changes to the staging area
      vim.keymap.set("n", "<leader>Ga", "Git add", { desc = "[G]it [A]dd" })

      -- Set a vim motion to <Space> + g + c to commit the current chages
      vim.keymap.set("n", "<leader>Gc", ":Git commit", { desc = "[G]it [C]ommit" })

      -- Set a vim motion to <Space> + g + p to push the commited changes to the remote repository
      vim.keymap.set("n", "<leader>Gp", "Git push", { desc = "[G]it [P]ush" })
    end,
  },
}
