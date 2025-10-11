return{
  'projekt0n/github-nvim-theme',
  name = 'github-theme',
  lazy = false, -- Load immediately to ensure theme is available
  event = "VeryLazy",  -- Optional: Lazy-load on events to improve startup time
  -- priority = 1000, -- High priority to ensure theme loads first
  config = function()
    require('github-theme').setup({
    })

    -- vim.cmd('colorscheme github_dark')
  end,
}
