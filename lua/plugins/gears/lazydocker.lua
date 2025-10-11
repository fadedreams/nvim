return {
  "crnvl96/lazydocker.nvim",
  lazy = true, -- Enable lazy loading
  dependencies = {
    "folke/which-key.nvim", -- Optional: For showing keymap hints.
  },
  opts = {
    -- Optional config: Customize the window size/border.
    window = {
      settings = {
        width = 0.9,  -- Percentage of screen width.
        height = 0.9, -- Percentage of screen height.
        border = "rounded", -- See `:h nvim_open_win` for options.
        relative = "editor",
      },
    },
  },
  keys = {
    -- This is the keymap! Maps <leader>ll to toggle LazyDocker.
    -- Use {'n', 't'} modes so it works in normal and terminal (since LazyDocker runs in a term buffer).
    { "<leader>ll", "<cmd>lua require('lazydocker').toggle()<CR>", desc = "Toggle LazyDocker" },
  },
}
