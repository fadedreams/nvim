-- sudo apt install universal-ctags -y
return {
  "preservim/tagbar",
  event = "VeryLazy",  -- Optional: Lazy-load on events to improve startup time
  config = function()
    vim.keymap.set("n", "<leader>xo", ":TagbarToggle<CR>", { desc = "Buffer Outline" })
  end,
}
