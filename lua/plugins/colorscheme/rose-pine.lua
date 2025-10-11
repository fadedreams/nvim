return {
  {
    "rose-pine/neovim",
    lazy = false, -- Load immediately
    config = function()
      require("rose-pine").setup({
        variant = "main", -- Default variant
        styles = {
          transparency = false, -- Set to false to apply background color
          italic = false,
        },
      })
    end,
  },
}
