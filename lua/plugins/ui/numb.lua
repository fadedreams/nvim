return{
  'nacro90/numb.nvim',
  event = "VeryLazy",  -- Optional: Lazy-load on events to improve startup time
  config = function()
    require('numb').setup()
  end,
}
