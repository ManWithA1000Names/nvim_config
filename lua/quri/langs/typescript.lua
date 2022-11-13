local lang = require("quri.langs.setup")

return lang("typescript")
	:use({
		"David-Kunz/jester",
		config = function()
			require("jester").setup({
				cmd = "npx jest -t '$result' -- $file",
			})
		end,
	})
	:server("tsserver")
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
