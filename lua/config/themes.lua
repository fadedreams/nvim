-- ~/.config/nvim/lua/config/themes.lua
-- Theme manager with live preview and persistent save

local theme_dir = vim.fn.stdpath("config")
local theme_file = theme_dir .. "/.theme"

-- === 1. Shared TokyoNight Config ===
local tokyonight_shared = {
  transparent = false,
  styles = {
    comments = { italic = false },
    keywords = { italic = false },
    sidebars = "transparent",
    floats = "transparent",
  },
  on_colors = function(colors, theme)
    if theme == "tokyonight-night" then
      colors.bg = "#000000"
      colors.bg_dark = "#000000"
    elseif theme == "tokyonight-moon" then
      colors.bg = "#282828"
      colors.bg_dark = "#282828"
    elseif theme == "tokyonight-day" then
      colors.bg = "#e1e2e7"
      colors.bg_dark = "#e1e2e7"
    end
  end,
  on_highlights = function(highlights, colors, theme)
    local common = {
      LineNr = { fg = "#323e63" },
      LineNrAbove = { fg = "#323e63" },
      LineNrBelow = { fg = "#323e63" },
      CursorLineNr = { fg = "#1572a3", bold = true },
    }
    vim.tbl_extend("force", highlights, common)

    if theme == "tokyonight-night" then
      highlights.StatusLine = { fg = "#7aa2f7", bg = "#000000", bold = true }
      highlights.StatusLineNC = { fg = "#7aa2f7", bg = "#000000" }
    elseif theme == "tokyonight-moon" then
      highlights.StatusLine = { fg = "#7aa2f7", bg = "#282828", bold = true }
      highlights.StatusLineNC = { fg = "#7aa2f7", bg = "#1f1f1f" }
    elseif theme == "tokyonight-day" then
      highlights.StatusLine = { fg = "#677dc5", bg = "#e1e2e7", bold = true }
      highlights.StatusLineNC = { fg = "#677dc5", bg = "#d0d1d6" }
    end
  end,
}

-- === 2. Ensure config dir exists ===
if vim.fn.isdirectory(theme_dir) == 0 then
  vim.fn.mkdir(theme_dir, "p")
end

-- === 3. Load saved theme on startup ===
if vim.fn.filereadable(theme_file) == 1 then
  local file = io.open(theme_file, "r")
  if file then
    local saved_theme = file:read("*a"):gsub("%s+", "")
    file:close()
    if saved_theme ~= "" then
      local function apply_tokyonight(theme)
        local style = theme:gsub("tokyonight%-", "")
        local config = vim.deepcopy(tokyonight_shared)
        config.style = style
        config.on_colors = function(c) tokyonight_shared.on_colors(c, theme) end
        config.on_highlights = function(h, c) tokyonight_shared.on_highlights(h, c, theme) end
        require("tokyonight").setup(config)
      end

      if saved_theme:match("^tokyonight") then
        apply_tokyonight(saved_theme)
      elseif saved_theme:match("^rose%-pine") then
        local variant_map = { ["rose-pine-main"] = "main", ["rose-pine-moon"] = "moon", ["rose-pine-dawn"] = "dawn" }
        require("rose-pine").setup({
          variant = variant_map[saved_theme] or "main",
          styles = { transparency = false, italic = false },
        })
      elseif saved_theme == "vscode" then
        require("vscode").setup({ transparent = false, italic_comments = false, disable_nvimtree_bg = true })
      elseif saved_theme:match("^cyberdream") then
        local variant = saved_theme == "cyberdream-light" and "light" or "default"
        require("cyberdream").setup({ variant = variant, transparent = false, italic_comments = false })
      end

      pcall(vim.cmd, "colorscheme " .. saved_theme)
    end
  end
end

-- === 4. Theme Selector with LIVE PREVIEW ===
local function select_theme()
  local themes = {
    -- Dark
    "tokyonight-night", "tokyonight-moon", "tokyonight-storm",
    "gruvbox-material", "nightingale", "carbonfox", "nvcode", "nanode",
    "rose-pine-main", "rose-pine-moon", "catppuccin", "cyberdream",
    "mellifluous", "melange", "miasma", "rusty",
    "bamboo", "bamboo-vulgaris", "bamboo-multiplex",
    "forest_stream", "sunset_cloud", "vague", "vscode", "jellybeans", "oldworld",
    "kanagawa-dragon", "zenbones", "zenwritten", "ayu-dark",

    --blue
    "catppuccin-macchiato", "catppuccin-mocha", "terafox", "nightfly",
    "polar", "bluloco", "ayu-mirage",

    -- Light
    "tokyonight-day", "rose-pine-dawn", "cyberdream-light",
    "dawnfox", "kanagawa-lotus", "catppuccin-latte",
  }

  require("telescope.pickers").new({}, {
    prompt_title = "Select Theme (Live Preview)",
    finder = require("telescope.finders").new_table({
      results = themes,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry:gsub("^%l", string.upper):gsub("%-", " "),
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
          local config = vim.deepcopy(tokyonight_shared)
          config.style = style
          config.on_colors = function(c) tokyonight_shared.on_colors(c, theme) end
          config.on_highlights = function(h, c) tokyonight_shared.on_highlights(h, c, theme) end
          require("tokyonight").setup(config)

        elseif theme:match("^rose%-pine") then
          local variant_map = { ["rose-pine-main"] = "main", ["rose-pine-moon"] = "moon", ["rose-pine-dawn"] = "dawn" }
          require("rose-pine").setup({
            variant = variant_map[theme] or "main",
            styles = { transparency = false, italic = false },
          })

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

      -- Live preview on navigation
      for _, key in ipairs({ "<Up>", "<Down>", "<C-p>", "<C-n>", "<C-k>", "<C-j>" }) do
        map("i", key, function()
          if key:match("Up") or key == "<C-p>" or key == "<C-k>" then
            actions.move_selection_previous(prompt_bufnr)
          else
            actions.move_selection_next(prompt_bufnr)
          end
          on_move()
        end)
      end

      -- Confirm & save
      map("i", "<CR>", function()
        local sel = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if sel then
          local file = io.open(theme_file, "w")
          if file then
            file:write(sel.value)
            file:flush()
            file:close()
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
    layout_config = { prompt_position = "top", height = 0.6, width = 0.5 },
  }):find()
end

-- === 5. Keymap ===
vim.keymap.set("n", "<leader>i9", select_theme, { desc = "Select Theme (Live Preview)", noremap = true, silent = true })
