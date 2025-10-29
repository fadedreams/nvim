-- ~/.config/nvim/lua/config/themes.lua

-- === 1. DEFINE theme_dir FIRST ===
local theme_dir = vim.fn.stdpath("config")

-- === 2. Ensure config dir exists ===
if vim.fn.isdirectory(theme_dir) == 0 then
  vim.fn.mkdir(theme_dir, "p")
end

-- === 3. Load saved theme on startup ===
local theme_file = theme_dir .. "/.theme"
if vim.fn.filereadable(theme_file) == 1 then
  local file = io.open(theme_file, "r")
  if file then
    local saved_theme = file:read("*a"):gsub("%s+", "")
    file:close()
    if saved_theme ~= "" then
      if saved_theme:match("^tokyonight") then
        require("tokyonight").setup({
          style = saved_theme:gsub("tokyonight^%-", ""),
          transparent = false,
          styles = {
            comments = { italic = false },
            keywords = { italic = false },
            sidebars = "transparent",
            floats = "transparent",
          },
          on_colors = function(colors)
            if saved_theme == "tokyonight-night" then
              colors.bg = "#000000"
              colors.bg_dark = "#000000"
            elseif saved_theme == "tokyonight-moon" then
              colors.bg = "#151617"
              colors.bg_dark = "#151617"
            elseif saved_theme == "tokyonight-day" then
              colors.bg = "#e1e2e7"
              colors.bg_dark = "#e1e2e7"
            end
          end,
          on_highlights = function(highlights, colors)
            if saved_theme == "tokyonight-night" then
              highlights.StatusLine = { fg = "#7aa2f7", bg = "#000000", bold = true }
              highlights.StatusLineNC = { fg = "#7aa2f7", bg = "#000000" }
            elseif saved_theme == "tokyonight-moon" then
              highlights.StatusLine = { fg = "#7aa2f7", bg = "#151617", bold = true }
              highlights.StatusLineNC = { fg = "#7aa2f7", bg = "#000000" }
            elseif saved_theme == "tokyonight-day" then
              highlights.StatusLine = { fg = "#677dc5", bg = "#e1e2e7", bold = true }
            end
            highlights.LineNr = { fg = "#323e63" }
            highlights.LineNrAbove = { fg = "#323e63" }
            highlights.LineNrBelow = { fg = "#323e63" }
            highlights.CursorLineNr = { fg = "#1572a3", bold = true }
          end,
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

-- === Theme Selector with LIVE PREVIEW ===
local function select_theme()
local themes = {
  "tokyonight-night",
  "gruvbox-material",
  "rose-pine-main",
    --gruv
  "nvcode",
  "melange",
  "miasma",
  "forest_stream",
  "sunset_cloud",
  "rusty",
  "bamboo",
  "bamboo-vulgaris",
  "bamboo-multiplex",
    --dark
  "tokyonight-moon",
  "rose-pine-moon",
  "cyberdream",
  "jellybeans",
  "oldworld",
  "ayu-dark",
  "catppuccin",
  "carbonfox",
  "terafox",
  "kanagawa-dragon",
  "vscode",
  "vague",
  "zenbones",
  "zenwritten",
    --blue
  "catppuccin-macchiato",
  "catppuccin-mocha",
  "nanode",
  "tokyonight-storm",
  "ayu-mirage",
  "nightfly",
  "polar",
  "bluloco",
    --light
  "rose-pine-dawn",
  "cyberdream-light",
  "tokyonight-day",
  "dawnfox",
  "kanagawa-lotus",
  "catppuccin-latte",
}

  require("telescope.pickers").new({}, {
    prompt_title = "Select Theme (Live Preview)",
    finder = require("telescope.finders").new_table({
      results = themes,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry:gsub("^%l", string.upper),
          ordinal = entry,
        }
      end,
    }),
    sorter = require("telescope.sorters").get_generic_fuzzy_sorter(),

    attach_mappings = function(prompt_bufnr, map)
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")

      local function apply_theme(theme)
        if not theme then return end

        if theme:match("^tokyonight") then
          local style = theme:gsub("tokyonight%-", "")
          require("tokyonight").setup({
            style = style,
            transparent = false,
            styles = { comments = { italic = false }, keywords = { italic = false }, sidebars = "transparent", floats = "transparent" },
            on_colors = function(colors)
              if theme == "tokyonight-night" then
                colors.bg = "#000000"; colors.bg_dark = "#000000"
              elseif theme == "tokyonight-moon" then
                colors.bg = "#151617"; colors.bg_dark = "#151617"
              elseif theme == "tokyonight-day" then
                colors.bg = "#e1e2e7"; colors.bg_dark = "#e1e2e7"
              end
            end,
            on_highlights = function(highlights, colors)
              if theme == "tokyonight-night" then
                highlights.StatusLine = { fg = "#7aa2f7", bg = "#000000", bold = true }
                highlights.StatusLineNC = { fg = "#7aa2f7", bg = "#000000" }
              elseif theme == "tokyonight-moon" then
                highlights.StatusLine = { fg = "#7aa2f7", bg = "#151617", bold = true }
                highlights.StatusLineNC = { fg = "#7aa2f7", bg = "#000000" }
              elseif theme == "tokyonight-day" then
                highlights.StatusLine = { fg = "#677dc5", bg = "#e1e2e7", bold = true }
              end
              highlights.LineNr = { fg = "#323e63" }
              highlights.LineNrAbove = { fg = "#323e63" }
              highlights.LineNrBelow = { fg = "#323e63" }
              highlights.CursorLineNr = { fg = "#1572a3", bold = true }
            end,
          })
        elseif theme:match("^rose%-pine") then
          local variant_map = { ["rose-pine-main"] = "main", ["rose-pine-moon"] = "moon", ["rose-pine-dawn"] = "dawn" }
          require("rose-pine").setup({ variant = variant_map[theme] or "main", styles = { transparency = false, italic = false } })
        elseif theme == "vscode" then
          require("vscode").setup({ transparent = false, italic_comments = false, disable_nvimtree_bg = true })
        elseif theme:match("^cyberdream") then
          local variant = theme == "cyberdream-light" and "light" or "default"
          require("cyberdream").setup({ variant = variant, transparent = false, italic_comments = false })
        end

        pcall(vim.cmd, "colorscheme " .. theme)
      end

      local function on_move()
        local sel = action_state.get_selected_entry()
        if sel then apply_theme(sel.value) end
      end

      -- Live preview on all keys
      map("i", "<Up>",    function() actions.move_selection_previous(prompt_bufnr); on_move() end)
      map("i", "<Down>",  function() actions.move_selection_next(prompt_bufnr);     on_move() end)
      map("i", "<C-p>",   function() actions.move_selection_previous(prompt_bufnr); on_move() end)
      map("i", "<C-n>",   function() actions.move_selection_next(prompt_bufnr);     on_move() end)
      map("i", "<C-k>",   function() actions.move_selection_previous(prompt_bufnr); on_move() end)
      map("i", "<C-j>",   function() actions.move_selection_next(prompt_bufnr);     on_move() end)

      -- Confirm & save
      map("i", "<CR>", function()
        local sel = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if sel then
          local file = io.open(theme_dir .. "/.theme", "w")
          if file then
            file:write(sel.value); file:flush(); file:close()
            apply_theme(sel.value)
            vim.notify("Theme saved: " .. sel.value, vim.log.levels.INFO)
          else
            vim.notify("Failed to save theme", vim.log.levels.ERROR)
          end
        end
      end)

      map("i", "<Esc>", actions.close)

      -- Initial preview
      vim.schedule(function()
        local sel = action_state.get_selected_entry()
        if sel then apply_theme(sel.value) end
      end)

      return true
    end,

    layout_strategy = "vertical",
    layout_config = { prompt_position = "top", height = 0.5, width = 0.4 },
  }):find()
end

-- Keymap
vim.keymap.set("n", "<leader>i9", select_theme, { desc = "Select Theme (Live Preview)", noremap = true, silent = true })
