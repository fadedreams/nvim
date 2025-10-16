

return{
  "KijitoraFinch/nanode.nvim",
  lazy=true,
  -- priority = 1000,
  config = function()
    require("nanode").setup({
      transparent = false,
    })
    vim.cmd.colorscheme("nanode")
  end,
}
