local lang = require("quri.langs.setup")

local lua = lang("lua"):use("hrsh7th/cmp-nvim-lua", true):formatter("stylua"):linter("luacheck"):server("sumneko_lua", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim", "awesome", "screen", "use" },
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
					[vim.fn.stdpath("config") .. "/after/plugin"] = true,
				},
			},
		},
	},
})

return lua
