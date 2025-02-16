return {
  {
    'preservim/tagbar',
    config = function()
      local keymap = vim.keymap
      keymap.set({ "n", "v" }, "<leader>tt",
        "<cmd>TagbarToggle<cr>", { desc = "toggle Tagbar" })
      vim.g.tagbar_position = "leftabove vertical"
    end
  },
}
