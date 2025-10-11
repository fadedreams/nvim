return{
  'ribru17/bamboo.nvim',
  lazy = false, -- Load immediately to ensure theme is available
  event = "VeryLazy",  -- Optional: Lazy-load on events to improve startup time
  -- priority = 1000, -- High priority to ensure theme loads first
  config = function()
    require('bamboo').setup {
      -- optional configuration here
    }
    require('bamboo').load()
  end,
}
