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
      pcall(vim.cmd, "colorscheme " .. saved_theme) -- Use pcall to avoid errors on invalid themes
    end
  end
end

-- Function to select a theme using Telescope and save the choice
local function select_theme()
  local themes = {
    -- "default",
    "tokyonight-night",
    "gruvbox-material",
    "melange",
    "oldworld",
    "tokyonight-day",
    "tokyonight-moon",
    "tokyonight-storm",
    "cyberdream",
    "ayu-dark",
    "ayu-mirage",
    "rose-pine-main",
    "rose-pine-moon",
    "rose-pine-dawn",
    "catppuccin-mocha",
    "carbonfox",
    "terafox",
    "bamboo",
    "bamboo-vulgaris",
    "bamboo-multiplex",
    "miasma",
    "kanagawa-dragon",
    -- "kanagawa-wave",
    "vscode",
    "vague",
    "zenbones",
    "zenwritten",
    "nightfly",
    "cyberdream-light",
    "kanagawa-lotus",
    -- "github_dark_default",
    -- "github_dark",
    -- "github_dark_dimmed",
    -- "github_dark_colorblind",
    -- "github_dark_high_contrast",
    -- "github_dark_tritanopia",
  }
  require("telescope.pickers").new({}, {
    prompt_title = "Select Theme",
    finder = require("telescope.finders").new_table({
      results = themes,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry:gsub("^%l", string.upper), -- Capitalize first letter for display
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
          -- Ensure the config directory exists
          local theme_dir = vim.fn.stdpath("config")
          if vim.fn.isdirectory(theme_dir) == 0 then
            vim.fn.mkdir(theme_dir, "p")
          end
          -- Save the selected theme to a file
          local file = io.open(theme_dir .. "/.theme", "w")
          if file then
            file:write(selection.value)
            file:flush() -- Ensure the file is written immediately
            file:close()
          else
            vim.notify("Failed to save theme", vim.log.levels.ERROR)
            return
          end
          -- Clear existing highlights
          vim.cmd("highlight clear")
          
          if selection.value:match("^tokyonight") then
            -- Reinitialize TokyoNight to trigger on_colors
            require("tokyonight").setup({
              style = selection.value:gsub("tokyonight%-", ""), -- Extract "night" or "day"
              transparent = false,
              styles = {
                comments = { italic = false },
                keywords = { italic = false },
                functions = {},
                variables = {},
                sidebars = "transparent",
                floats = "transparent",
              },
              on_colors = function(colors)
                -- Read the .theme file to confirm the theme
                local theme_file = vim.fn.stdpath("config") .. "/.theme"
                local selected_theme = "night" -- Default fallback
                if vim.fn.filereadable(theme_file) == 1 then
                  local f = io.open(theme_file, "r")
                  if f then
                    selected_theme = f:read("*a"):gsub("%s+", "")
                    f:close()
                  end
                end
                print("Applying theme: " .. selected_theme) -- Debug output
                if selected_theme == "tokyonight-night" then
                  colors.bg = "#000000"
                  colors.bg_dark = "#000000"
                end
                if selected_theme == "tokyonight-day" then
                  -- colors.bg = "#292522"
                  -- colors.bg_dark = "#292522"
                end
              end,
              on_highlights = function(highlights, colors)
                highlights.StatusLine = { fg = "#7aa2f7", bg = "#000000", bold = true }
                highlights.StatusLineNC = { fg = "#7aa2f7", bg = "#444444" }
                highlights.LineNr = { fg = "#323e63" }
                highlights.LineNrAbove = { fg = "#323e63" }
                highlights.LineNrBelow = { fg = "#323e63" }
                highlights.CursorLineNr = { fg = "#1572a3", bold = true }
              end,
            })
          elseif selection.value:match("^rose%-pine") then
            -- Reinitialize Rose Pine with the selected variant and disable transparency for background
            local variant_map = {
              ["rose-pine-main"] = "main",
              ["rose-pine-moon"] = "moon",
              ["rose-pine-dawn"] = "dawn",
            }
            local rp_variant = variant_map[selection.value] or "main"
            require("rose-pine").setup({
              variant = rp_variant,
              styles = {
                transparency = false,  -- Set to false to apply background color
                italic = false,
              },
              -- Add any other customizations here if needed
            })
          elseif selection.value == "vscode" then
            -- Reinitialize vscode with desired options
            require("vscode").setup({
              transparent = false,  -- Adjust as needed
              italic_comments = false,
              disable_nvimtree_bg = true,
              -- For light mode: add style = 'light' or vim.o.background = 'light' here
            })
          elseif selection.value:match("^cyberdream") then
            -- Reinitialize cyberdream with desired options
            local cd_variant = "default"
            if selection.value == "cyberdream-light" then
              cd_variant = "light"
            end
            require("cyberdream").setup({
              variant = cd_variant,  -- "default" for dark, "light" for light
              transparent = false,  -- Set to false to apply background color
              italic_comments = false,
              -- Add any other customizations here if needed (e.g., hide_fillchars = true, borderless_pickers = true)
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
