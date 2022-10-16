local wk_ok, wk = pcall(require, "which-key")
if not wk_ok then
	return
end

local clients = require("quri.compiled").skipped_format_servers

local function next_diagnostic()
	vim.diagnostic.goto_next({ border = true })
end

local function prev_diagnostic()
	vim.diagnostic.goto_prev({ border = true })
end

local function line_diagnostics()
	vim.diagnostic.open_float({ border = "rounded" })
end

local function fmt()
	vim.lsp.buf.format({
		filter = function(client)
			return clients[client.name] == nil
		end,
	})
end

local keys = {
	[";"] = { fmt, "Format" },
	["gh"] = { vim.lsp.buf.hover, "Hover" },
	["gl"] = { line_diagnostics, "Line diagnostics" },
	["ga"] = { vim.lsp.buf.code_action, "Code action" },
	["gd"] = { vim.lsp.buf.definition, "Go to definition" },
	["gD"] = { vim.lsp.buf.declaration, "Go to declaration" },
	["gs"] = { vim.lsp.buf.signature_help, "Signature help" },
	["gr"] = { ":Telescope lsp_references<CR>", "References" },
	["gI"] = { vim.lsp.buf.implementation, "Go to implementation" },
	["gt"] = { vim.lsp.buf.type_definition, "Go to type definition" },
  ["gL"] = { vim.lsp.codelens.run, "Codelens actions"}
}

local keysLeader = {
	r = { vim.lsp.buf.rename, "Rename" },
	l = {
		name = "LSP",
		l = { ":LspInfo<CR>", "Lsp information" },
		n = { ":NullLsInfo<CR>", "Null-ls information" },
		j = { next_diagnostic, "Go to next diagnostic" },
		k = { prev_diagnostic, "Go to prev diagnostic" },
		d = { ":Telescope diagnostics<CR>", "Workspace diagnostics" },
	},
}

wk.register(keys)
wk.register(keysLeader, { prefix = "<leader>" })
