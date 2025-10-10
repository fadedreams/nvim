local desc = Utils.plugin_keymap_desc("jdtls")
return {
	settings = {
		java = {
			-- Enable inlay hints for Java
			inlayHints = {
				parameterNames = {
					enabled = "all", -- literals, all, none
				},
			},
			-- Enable code formatting
			format = {
				enabled = true,
			},
			-- Enable code completion
			completion = {
				enabled = true,
				favoriteStaticMembers = {
					"org.junit.jupiter.api.Assertions.*",
					"java.util.Objects.requireNonNull",
					"java.util.Objects.requireNonNullElse",
					"org.mockito.Mockito.*",
				},
			},
			-- Enable project configuration
			configuration = {
				runtimes = {
					{
						name = "JavaSE-21", -- Correct name for Java 21
						path = "/usr/lib/jvm/jdk-21.0.8-oracle-x64", -- Path to JDK home directory
					},
					-- Add other JDK versions if needed
					-- {
					--     name = "JavaSE-11",
					--     path = "/usr/lib/jvm/java-11-openjdk",
					-- },
				},
			},
			-- Enable code lenses for actions like run/debug
			codeGeneration = {
				toString = {
					template = "${object.className} [${member.name()}=${member.value}, ${otherMembers}]",
				},
				hashCodeEquals = {
					useJava7Objects = true,
				},
				useBlocks = true,
			},
		},
	},
	keys = {
		{
			"<leader>jo",
			function()
				vim.lsp.buf.code_action({
					apply = true,
					context = {
						only = { "source.organizeImports" },
						diagnostics = {},
					},
				})
			end,
			desc = desc("Organize imports"),
		},
		{
			"<leader>jf",
			function()
				vim.lsp.buf.format({ async = true })
			end,
			desc = desc("Format document"),
		},
		{
			"<leader>jc",
			function()
				vim.lsp.buf.code_action({
					context = {
						diagnostics = vim.lsp.diagnostic.get_line_diagnostics(),
					},
				})
			end,
			desc = desc("List all code actions"),
		},
		{
			"<leader>jr",
			function()
				vim.lsp.buf.execute_command({
					command = "java.debug.run",
					arguments = {},
				})
			end,
			desc = desc("Run Java program"),
		},
	},
}
