return {
  {
    "rose-pine/neovim",
    lazy = false, -- Load immediately to ensure theme is available
    event = "VeryLazy",  -- Optional: Lazy-load on events to improve startup time
    -- priority = 1000, -- High priority to ensure theme loads first
    config = function()
      require("rose-pine").setup({
        variant = "main", -- main, moon, or dawn
        styles = {
          transparency = true,
          italic = false,
        },
      })
    end,
  },
}
