return {
  {
    "folke/tokyonight.nvim",
    lazy = false, -- Load immediately
    priority = 1000, -- Ensure it loads before other plugins
    opts = function()
      -- Read the saved theme from the .theme file once
      local theme_file = vim.fn.stdpath("config") .. "/.theme"
      local selected_theme = "tokyonight-night" -- Default fallback
      if vim.fn.filereadable(theme_file) == 1 then
        local file = io.open(theme_file, "r")
        if file then
          selected_theme = file:read("*a"):gsub("%s+", "")
          file:close()
        end
      end

      return {
        style = selected_theme:gsub("tokyonight%-", ""), -- Extract style (night, day, etc.)
        light_style = "day",
        transparent = false, -- Ensure background is applied
        styles = {
          comments = { italic = false },
          keywords = { italic = false },
          sidebars = "transparent",
          floats = "transparent",
        },
        on_colors = function(colors)
          if selected_theme == "tokyonight-night" then
            colors.bg = "#000000"
            colors.bg_dark = "#000000"
          elseif selected_theme == "tokyonight-day" then
            colors.bg = "#e1e2e7"
            colors.bg_dark = "#e1e2e7"
          end
        end,
        on_highlights = function(highlights, colors)
          if selected_theme == "tokyonight-night" then
            highlights.StatusLine = { fg = "#7aa2f7", bg = "#000000", bold = true }
            highlights.StatusLineNC = { fg = "#7aa2f7", bg = "#000000" }
          elseif selected_theme == "tokyonight-day" then
            highlights.StatusLine = { fg = "#677dc5", bg = "#e1e2e7", bold = true }
          end
          highlights.LineNr = { fg = "#323e63" }
          highlights.LineNrAbove = { fg = "#323e63" }
          highlights.LineNrBelow = { fg = "#323e63" }
          highlights.CursorLineNr = { fg = "#1572a3", bold = true }
        end,
      }
    end,
    config = function(_, opts)
      require("tokyonight").setup(opts)
      -- Apply the colorscheme after setup
      -- vim.cmd("colorscheme tokyonight")
    end,
  },


  -- {
  --   "folke/tokyonight.nvim",
  --   lazy = false, -- Load immediately
  --   priority = 1000, -- Ensure it loads before other plugins
  --   opts = {
  --     style = "night", -- Default style
  --     light_style = "day",
  --     transparent = false, -- Set to false to ensure background is applied
  --     styles = {
  --       comments = { italic = false },
  --       keywords = { italic = false },
  --       sidebars = "transparent",
  --       floats = "transparent",
  --     },
  --     on_colors = function(colors)
  --       -- Read the saved theme from the .theme file
  --       local theme_file = vim.fn.stdpath("config") .. "/.theme"
  --       local selected_theme = "night" -- Default fallback
  --       if vim.fn.filereadable(theme_file) == 1 then
  --         local file = io.open(theme_file, "r")
  --         if file then
  --           selected_theme = file:read("*a"):gsub("%s+", "")
  --           file:close()
  --         end
  --       end
  --       if selected_theme == "tokyonight-night" then
  --         colors.bg = "#000000"
  --         colors.bg_dark = "#000000"
  --       elseif selected_theme == "tokyonight-day" then
  --         colors.bg = "#e1e2e7" -- Light background for tokyonight-day
  --         colors.bg_dark = "#e1e2e7"
  --       end
  --     end,
  --     on_highlights = function(highlights, colors)
  --       -- Read the theme again to ensure consistency
  --       local theme_file = vim.fn.stdpath("config") .. "/.theme"
  --       local selected_theme = "night" -- Default fallback
  --       if vim.fn.filereadable(theme_file) == 1 then
  --         local file = io.open(theme_file, "r")
  --         if file then
  --           selected_theme = file:read("*a"):gsub("%s+", "")
  --           file:close()
  --         end
  --       end
  --       if selected_theme == "tokyonight-day" then
  --         highlights.StatusLine = { fg = "#677dc5", bg = "#e1e2e7", bold = true }
  --       elseif selected_theme == "tokyonight-night" then
  --         print(selected_theme)
  --         highlights.StatusLine = { fg = "#7aa2f7", bg = "#000000", bold = true }
  --         highlights.StatusLineNC = { fg = "#7aa2f7", bg = "#444444" }
  --       end
  --       highlights.LineNr = { fg = "#323e63" }
  --       highlights.LineNrAbove = { fg = "#323e63" }
  --       highlights.LineNrBelow = { fg = "#323e63" }
  --       highlights.CursorLineNr = { fg = "#1572a3", bold = true }
  --     end,
  --   },
  --   config = function(_, opts)
  --     require("tokyonight").setup(opts)
  --   end,
  -- },
}
-- {
--   "folke/tokyonight.nvim",
--   lazy = false, -- Load immediately
--   priority = 1000, -- Ensure it loads before other plugins
--   opts = {
--     -- storm, moon, night, day
--     style = "night",
--     light_style = "day",
--     transparent = true,
--     styles = {
--       comments = { italic = false },
--       keywords = { italic = false },
--       functions = {},
--       variables = {},
--       sidebars = "transparent", -- transparent, dark, light
--       floats = "transparent",
--     },
--     -- https://github.com/folke/tokyonight.nvim/blob/main/extras/lua/tokyonight_night.lua#L4
--     on_colors = function(colors)
--       -- colors.comment = "#7c86bf"
--       -- colors.comment = "#787000"
--       -- colors.bg_highlight = "#787000"
--       -- colors.hint = "#787000"
--       -- colors.fg = "#787000"
--       -- colors.bg_highlight = "#787000"
--
--       colors.bg = "#000000"
--       colors.bg_dark = "#000000"
--
--       -- colors.bg_float = "#787000"
--       colors.bg_highlight = "#0A0E17"
--       -- colors.bg_popup = "#787000"
--       -- colors.bg_search = "#787000"
--       -- colors.bg_sidebar = "#787000"
--       colors.bg_statusline = "#000000" --statusline
--       -- colors.bg_visual = "#787000"
--       -- colors.black = "#787000"
--       -- colors.blue = "#787000"
--       -- colors.blue0 = "#787000"
--       -- colors.blue1 = "#787000"
--       -- colors.blue2 = "#787000"
--       -- colors.blue5 = "#787000"
--       -- colors.blue6 = "#787000"
--       -- colors.blue7 = "#787000"
--       -- colors.border = "#787000"
--       -- colors.border_highlight = "#787000"
--       -- colors.comment = "#787000"
--       -- colors.cyan = "#787000"
--       -- colors.dark3 = "#787000"
--       -- colors.dark5 = "#787000"
--       -- colors.diff =
--       --     add: "#787000"
--       --     change: "#787000"
--       --     delete: "#787000"
--       --     text: "#787000"
--       -- }
--       -- colors.error = "#787000"
--       -- colors.fg = "#787000"
--       -- colors.fg_dark = "#787000"
--       -- colors.fg_float = "#787000"
--
--       colors.fg_gutter = "#1E2A4D" --highlights
--
--       -- colors.fg_sidebar = "#787000"
--       -- colors.git =
--       --     add: "#787000"
--       --     change: "#787000"
--       --     delete: "#787000"
--       --     ignore: "#787000
--       -- }
--       -- colors.green = "#787000"
--       -- colors.green1 = "#787000"
--       -- colors.green2 = "#787000"
--       -- colors.hint = "#787000"
--       -- colors.info = "#787000"
--       -- colors.magenta = "#787000"
--       -- colors.magenta2 = "#787000"
--       -- colors.none = "#787000"
--       -- colors.orange = "#787000" -- active linenumber
--       -- colors.purple = "#787000"
--       -- colors.rainbow = ["#787000", "#787000", "#787000", "#787000", "#787000", "#787000"]
--       -- colors.red = "#787000"
--       -- colors.red1 = "#787000"
--       -- colors.teal = "#787000"
--       colors.terminal_black = "#5C6C7A" --unused variables
--       -- colors.todo = "#787000"
--       -- colors.warning = "#787000"
--       -- colors.yellow = "#787000"
--     end,
--     on_highlights = function(highlights, colors)
--       -- highlights["@function.body"] = { bg = colors.bg_dark, fg = colors.fg }  -- Adjust colors as needed
--       -- Or for language-specific (e.g., Lua local functions)
--       -- highlights["@function.inner"] = { bg = colors.bg_dark, fg = colors.fg }
--
--       highlights.StatusLine = { fg = "#ffffff", bg = "#000000", bold = true } -- Customize this to your preferred fg/bg
--       highlights.StatusLineNC = { fg = "#ffffff", bg = "#444444" } -- Customize this to your preferred fg/bg for inactive statusline
--
--       -- Regular line numbers
--       highlights.LineNr = { fg = "#323e63" }
--
--       -- Previous line number
--       highlights.LineNrAbove = { fg = "#323e63" }
--
--       -- Next line number
--       highlights.LineNrBelow = { fg = "#323e63" }
--
--       -- Current line number
--       highlights.CursorLineNr = { fg = "#1572a3", bold = true }
--     end,
--   },
-- },
-- {
--   "folke/tokyonight.nvim",
--   lazy = false,
--   priority = 1000,
--   opts = {
--     -- storm, moon, night, day
--     style = "moon",
--     styles = {
--       comments = { italic = false },
--       keywords = { italic = false },
--       functions = {},
--       variables = {},
--       sidebars = "transparent", -- transparent, dark, light
--       floats = "transparent",
--     },
--   },
-- },
-- {
--   "LazyVim/LazyVim",
--   opts = {
--     -- colorscheme = "catppuccin",
--     -- #182136
--     colorscheme = "tokyonight",
--   },
-- },

-- set in keymaps.lua
-- { "EdenEast/nightfox.nvim" }, -- :colorscheme nightfox/dayfox/dawnfox/duskfox/nordfox/terafox/carbonfox or use LazyVim/LazyVim

-- :colorscheme rose-pine or use LazyVim/LazyVim
-- {
--   "rose-pine/neovim",
--   name = "rose-pine",
-- },

-- :colorscheme onedark or use LazyVim/LazyVim
-- {
--   "olimorris/onedarkpro.nvim",
--   priority = 1000, -- Ensure it loads first
-- },
-- }

