local desc = Utils.plugin_keymap_desc("intelephense")

return {
	settings = {
		intelephense = {
			diagnostics = {
				enable = true,
			},
			format = {
				enable = true,
				braces = "psr12", -- Follow PSR-12 bracing style
			},
			stubs = {
				"apache",
				"bcmath",
				"bz2",
				"calendar",
				"com_dotnet",
				"Core",
				"curl",
				"date",
				"dba",
				"dom",
				"enchant",
				"exif",
				"FFI",
				"fileinfo",
				"filter",
				"fpm",
				"ftp",
				"gd",
				"gettext",
				"gmp",
				"hash",
				"iconv",
				"imap",
				"intl",
				"json",
				"ldap",
				"libxml",
				"mbstring",
				"mysql",
				"mysqli",
				"oci8",
				"odbc",
				"openssl",
				"pcntl",
				"pcre",
				"PDO",
				"pdo_ibm",
				"pdo_mysql",
				"pdo_pgsql",
				"pdo_sqlite",
				"pgsql",
				"Phar",
				"posix",
				"pspell",
				"readline",
				"Reflection",
				"session",
				"shmop",
				"SimpleXML",
				"soap",
				"sockets",
				"sodium",
				"SPL",
				"sqlite3",
				"standard",
				"tidy",
				"tokenizer",
				"xml",
				"xmlreader",
				"xmlrpc",
				"xmlwriter",
				"xsl",
				"Zend OPcache",
				"zip",
				"zlib",
			},
		},
	},
	keys = {
		{
			"<leader>lho",
			function()
				vim.lsp.buf.code_action({
					apply = true,
					context = {
						only = { "source.organizeImports" },
						diagnostics = {},
					},
				})
			end,
			desc = desc("Organize imports PHP"),
		},
		{
			"<leader>lhf",
			function()
				vim.lsp.buf.format({ async = true })
			end,
			desc = desc("Format document PHP"),
		},
		{
			"<leader>lhc",
			function()
				vim.lsp.buf.code_action({
					context = {
						diagnostics = vim.lsp.diagnostic.get_line_diagnostics(),
					},
				})
			end,
			desc = desc("List all code actions"),
		},
	},
}
