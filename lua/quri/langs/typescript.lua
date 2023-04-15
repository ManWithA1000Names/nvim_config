local lang = require("quri.langs.setup")
local util = require("lspconfig.util")

return lang("typescript")
	:use({
		"David-Kunz/jester",
		config = function()
			require("jester").setup({
				cmd = "npx jest -t '$result' -- $file",
			})
		end,
	})
	:server("tsserver", {
		root_dir = function(fname)
			return util.root_pattern("package.json")(fname)
		end,
		single_file_support = false,
	})
	:server("denols", {
		root_dir = function(fname)
			return util.root_pattern("deno.json", "deno.jsonc")(fname)
		end,
		single_file_support = false,
	})
	:server("eslint")
	:formatter("prettier")
	:keymaps({
		j = {
			function()
				require("jester").run()
				vim.cmd("startinsert")
			end,
			"Run the closet test to the cursor",
		},
		f = {
			function()
				require("jester").run_file()
				vim.cmd("startinsert")
			end,
			"Run this jest file",
		},
		l = {
			function()
				require("jester").run_last()
				vim.cmd("startinsert")
			end,
			"Run the last ran test(s)",
		},
	})
