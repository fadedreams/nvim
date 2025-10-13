return {
  {
    "rose-pine/neovim",
    lazy = true, -- Load immediately
    config = function()
      require("rose-pine").setup({
        variant = "main", -- Default variant
        styles = {
          transparency = false, -- Set to false to apply background color
          italic = false,
        },
        -- highlight_groups = {
        --     TreesitterContext = { bg = 'NONE' },
        --     TreesitterContextLineNumber = { bg = 'NONE' },
        -- },
      })
    end,
  },
}
