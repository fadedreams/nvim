-- Ensure the config directory exists
local theme_dir = vim.fn.stdpath("config")
if vim.fn.isdirectory(theme_dir) == 0 then
  vim.fn.mkdir(theme_dir, "p")
end

-- Load saved theme if it exists
local theme_file = theme_dir .. "/.theme"
if vim.fn.filereadable(theme_file) == 1 then
  local file = io.open(theme_file, "r")
  if file then
    local saved_theme = file:read("*a"):gsub("%s+", "") -- Trim whitespace
    file:close()
    if saved_theme ~= "" then
      -- Initialize theme-specific settings before applying
      if saved_theme:match("^tokyonight") then
        require("tokyonight").setup({
          style = saved_theme:gsub("tokyonight%-", ""),
          transparent = false,
          styles = {
            comments = { italic = false },
            keywords = { italic = false },
            sidebars = "transparent",
            floats = "transparent",
          },
        })
      elseif saved_theme:match("^rose%-pine") then
        local variant_map = {
          ["rose-pine-main"] = "main",
          ["rose-pine-moon"] = "moon",
          ["rose-pine-dawn"] = "dawn",
        }
        require("rose-pine").setup({
          variant = variant_map[saved_theme] or "main",
          styles = { transparency = false, italic = false },
        })
      end
      pcall(vim.cmd, "colorscheme " .. saved_theme)
    end
  end
end

-- Function to select a theme using Telescope and save the choice
local function select_theme()
  local themes = {
    "tokyonight-night",
    "nvcode",
    "gruvbox-material",
    "melange",
    "forest_stream",
    "miasma",
    "oldworld",
    "rusty",
    "tokyonight-day",
    "dawnfox",
    "catppuccin-latte",
    "tokyonight-moon",
    "tokyonight-storm",
    "cyberdream",
    "ayu-dark",
    "ayu-mirage",
    "rose-pine-main",
    "rose-pine-moon",
    "rose-pine-dawn",
    "catppuccin",
    "catppuccin-mocha",
    "catppuccin-macchiato",
    "carbonfox",
    "terafox",
    "bamboo",
    "bamboo-vulgaris",
    "bamboo-multiplex",
    "kanagawa-dragon",
    "vscode",
    "vague",
    "zenbones",
    "zenwritten",
    "nightfly",
    "cyberdream-light",
    "kanagawa-lotus",
    "sunset_cloud", --boo
    -- "radioactive_waste", --boo
  }
  require("telescope.pickers").new({}, {
    prompt_title = "Select Theme",
    finder = require("telescope.finders").new_table({
      results = themes,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry:gsub("^%l", string.upper), -- Capitalize first letter
          ordinal = entry,
        }
      end,
    }),
    sorter = require("telescope.sorters").get_generic_fuzzy_sorter(),
    attach_mappings = function(prompt_bufnr, map)
      local actions = require("telescope.actions")
      map("i", "<CR>", function()
        local selection = require("telescope.actions.state").get_selected_entry()
        actions.close(prompt_bufnr)
        if selection then
          -- Save the selected theme to a file
          local file = io.open(theme_dir .. "/.theme", "w")
          if file then
            file:write(selection.value)
            file:flush()
            file:close()
          else
            vim.notify("Failed to save theme", vim.log.levels.ERROR)
            return
          end

          -- Initialize theme-specific settings
          if selection.value:match("^tokyonight") then
            require("tokyonight").setup({
              style = selection.value:gsub("tokyonight%-", ""),
              transparent = false,
              styles = {
                comments = { italic = false },
                keywords = { italic = false },
                sidebars = "transparent",
                floats = "transparent",
              },
              on_colors = function(colors)
                if selection.value == "tokyonight-night" then
                  colors.bg = "#000000"
                  colors.bg_dark = "#000000"
                elseif selection.value == "tokyonight-day" then
                  colors.bg = "#e1e2e7"
                  colors.bg_dark = "#e1e2e7"
                end
              end,
              on_highlights = function(highlights, colors)
                if selection.value == "tokyonight-day" then
                  highlights.StatusLine = { fg = "#677dc5", bg = "#e1e2e7", bold = true }
                elseif selection.value == "tokyonight-night" then
                  highlights.StatusLine = { fg = "#7aa2f7", bg = "#000000", bold = true }
                  highlights.StatusLineNC = { fg = "#7aa2f7", bg = "#444444" }
                end
                highlights.LineNr = { fg = "#323e63" }
                highlights.LineNrAbove = { fg = "#323e63" }
                highlights.LineNrBelow = { fg = "#323e63" }
                highlights.CursorLineNr = { fg = "#1572a3", bold = true }
              end,
            })
          elseif selection.value:match("^rose%-pine") then
            local variant_map = {
              ["rose-pine-main"] = "main",
              ["rose-pine-moon"] = "moon",
              ["rose-pine-dawn"] = "dawn",
            }
            require("rose-pine").setup({
              variant = variant_map[selection.value] or "main",
              styles = { transparency = false, italic = false },
            })
          elseif selection.value == "vscode" then
            require("vscode").setup({
              transparent = false,
              italic_comments = false,
              disable_nvimtree_bg = true,
            })
          elseif selection.value:match("^cyberdream") then
            local cd_variant = selection.value == "cyberdream-light" and "light" or "default"
            require("cyberdream").setup({
              variant = cd_variant,
              transparent = false,
              italic_comments = false,
            })
          end

          -- Apply the selected theme
          local status, err = pcall(vim.cmd, "colorscheme " .. selection.value)
          if not status then
            vim.notify("Failed to apply theme: " .. selection.value, vim.log.levels.ERROR)
            return
          end
          vim.notify("Theme set to " .. selection.value, vim.log.levels.INFO)
        end
      end)
      return true
    end,
    layout_strategy = "vertical",
    layout_config = {
      prompt_position = "top",
      height = 0.4,
      width = 0.3,
    },
  }):find()
end

-- Set keybinding to select theme with Telescope
vim.keymap.set("n", "<leader>i9", select_theme, { desc = "Select Theme", noremap = true, silent = true })
