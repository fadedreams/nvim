local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		-- { import = "plugins" },
		{import = "plugins.colorscheme"},
    {import = "plugins.ui"},

    {import = "plugins.editor"},
    {import = "plugins.ex"},
    {import = "plugins.ai"},
		{import = "plugins.gears"},
		{import = "plugins.git"},
    {import = "plugins.lsp"},


	},
	change_detection = {
		notify = false, --changed
		enabled = true,
	},
	install = {
		-- colorscheme = {"rose-pine"},
		colorscheme = { "tokyonight" },
	},
	performance = {
		cache = { enabled = true },
		rtp = {
			disabled_plugins = {
				--"gzip",
				--"netrwPlugin",
				--"rplugin",
				--"tarPlugin",
				--"tohtml",
				--"tutor",
				--"zipPlugin",
				--"netrw",
				--"netrwPlugin",
				--"netrwSettings",
				--"netrwFileHandlers",
			},
		},
	},
	ui = {
		border = "single",
		size = {
			width = 0.7,
			height = 0.7,
		},
	},
})
