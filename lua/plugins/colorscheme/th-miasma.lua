return{
  "xero/miasma.nvim",
  lazy = false, -- Load immediately to ensure theme is available
  event = "VeryLazy",  -- Optional: Lazy-load on events to improve startup time
  -- priority = 1000, -- High priority to ensure theme loads first
  config = function()
    -- vim.cmd("colorscheme miasma")
  end,
}
