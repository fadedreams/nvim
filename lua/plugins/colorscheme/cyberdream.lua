return {
  {
    "scottmckendry/cyberdream.nvim",
    lazy = true, -- Load immediately to ensure theme is available
    priority = 1000, -- High priority to ensure theme loads first
    config = function()
      require("cyberdream").setup({
        variant = "default", -- use "light" for the light variant. Also accepts "auto" to set dark or light colors based on the current value of `vim.o.background`
        transparent = true,
        -- italic_comments = true,
        hide_fillchars = true,
        borderless_telescope = true,
        italic_comments = false,
      })
    end,
  },
}
