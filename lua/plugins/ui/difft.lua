--luacheck: globals Difft
return {
  "ahkohd/difft.nvim",
  keys = {
    {
      "<leader>dc",
      function()
        if Difft.is_visible() then
          Difft.hide()
        else
          Difft.diff()
        end
      end,
      desc = "Toggle Difft",
    },
  },
  config = function()
    require("difft").setup({
      command = "git diff --color=always",  -- ✅ COLORS ENABLED!
      layout = "float",
      window = {
        width = 0.9,
        height = 0.8,
        border = "rounded",
        number = false,
        relativenumber = false,
      },
      header = {
        content = function(filename, step)
          local devicons = require("nvim-web-devicons")
          local basename = vim.fn.fnamemodify(filename, ":t")
          local icon, hl = devicons.get_icon(basename)
          
          local result = {}
          table.insert(result, { " " })
          table.insert(result, { icon and (icon .. " ") or "", hl })
          table.insert(result, { basename })
          table.insert(result, { " " })
          
          if step then
            table.insert(result, { "• " })
            table.insert(result, { tostring(step.current), "Comment" })
            table.insert(result, { "/" })
            table.insert(result, { tostring(step.of), "Comment" })
          end
          
          return result
        end,
        highlight = {
          link = "FloatTitle",
          full_width = true,
        },
      },
    })
  end,
}
