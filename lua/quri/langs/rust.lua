local lang = require("quri.langs.setup")

local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/")
local codelldb_adapter = {
	type = "server",
	port = "${port}",
	executable = {
		command = mason_path .. "bin/codelldb",
		args = { "--port", "${port}" },
	},
}
return lang("rust")
	:use("simrat39/rust-tools.nvim")
	:server("rust_analyzer", function()
		local ok, rust = pcall(require, "rust-tools")
		if not ok then
			return
		end

		rust.setup({
			tools = {
				executor = require("rust-tools/executors").termopen, -- can be quickfix or termopen
				reload_workspace_from_cargo_toml = true,
				runnables = {
					use_telescope = true,
				},
				inlay_hints = {
					auto = false,
				},
				hover_actions = {
					border = "rounded",
				},
				on_initialized = function()
					vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "CursorHold", "InsertLeave" }, {
						pattern = { "*.rs" },
						callback = function()
							local _, _ = pcall(vim.lsp.codelens.refresh)
						end,
					})
				end,
			},
			dap = {
				adapter = codelldb_adapter,
			},
			server = {
				on_attach = function(_, bufnr)
					vim.keymap.set("n", "gh", rust.hover_actions.hover_actions, { buffer = bufnr })
				end,

				settings = {
					["rust-analyzer"] = {
						lens = {
							enable = true,
						},
						checkOnSave = {
							enable = true,
							command = "clippy",
						},
					},
				},
			},
		})
	end)
	:debug(function(dap)
		dap.adapters.codelldb = codelldb_adapter
		dap.configurations.rust = {
			{
				name = "Launch file",
				type = "codelldb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
			},
		}
	end)
