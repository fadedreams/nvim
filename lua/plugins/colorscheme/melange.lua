return {
  "savq/melange-nvim",
  lazy = false, -- Load immediately to ensure theme is available
  event = "VeryLazy",  -- Optional: Lazy-load on events to improve startup time
  -- priority = 1000, -- High priority to ensure theme loads first
  config = function()
    -- Your configuration here
    vim.cmd.colorscheme("melange") -- Example: Set melange as the colorscheme
  end,
}
