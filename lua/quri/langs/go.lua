local lang = require("quri.langs.setup")

return lang("go")
	:server("gopls", {
		on_attach = function()
			local _, _ = pcall(vim.lsp.codelens.refresh)
		end,
		settings = {
			gopls = {
				usePlaceholders = true,
				codelenses = {
					generate = false,
					gc_details = true,
					test = true,
					tidy = true,
				},
			},
		},
	})
	:server("golangci_lint_ls")
	:use({
		"olexsmir/gopher.nvim",
		config = function()
			require("gopher").setup()
		end,
	})
	:debug(function()
		require("gopher.dap").setup()
	end)
	:keymaps({
		c = { ":GoCmt<CR>", "Go comment" },
		e = { ":GoIfErr<CR>", "Go if err" },
		i = { ":GoImpl<CR>", "Go impl" },
		T = {
			name = "tag",
			a = { ":GoTagAdd<CR>", "Go add tag" },
			r = { ":GoTagRm<CR>", "Go remove tag" },
		},
		t = {
			name = "test",
			a = { ":GoTestAdd<CR>", "Go add test" },
			A = { ":GoTestsAll<CR>", "Go test all" },
			e = { ":GoTestExp<CR>", "Go test exported" },
		},
	})
	:formatter("goimports")
	:lsp_format(true)
