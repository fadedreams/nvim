return     {
  'sainnhe/gruvbox-material',
  lazy = false, -- Load immediately to ensure theme is available
  event = "VeryLazy",  -- Optional: Lazy-load on events to improve startup time
  -- priority = 1000,
  config = function()
    -- Optionally configure and load the colorscheme
    -- directly inside the plugin declaration.
    vim.g.gruvbox_material_enable_italic = true
    vim.cmd.colorscheme('gruvbox-material')
  end
}

