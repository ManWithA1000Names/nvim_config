local ok, null = pcall(require, "null-ls")
if not ok then
	return
end

local formatting = null.builtins.formatting
local diagnostics = null.builtins.diagnostics

local c = require("quri.compiled")
local formatters = c.formatters
local linters = c.linters

local sources = {}

for _, formatter in ipairs(formatters) do
	if type(formatter) == "string" then
		table.insert(sources, formatting[formatter])
	else
		table.insert(sources, formatting[formatter[1]].with({ extra_args = vim.list_slice(formatter, 2, #formatter) }))
	end
end

for _, linter in ipairs(linters) do
	if type(linter) == "string" then
		table.insert(sources, diagnostics[linter])
	else
		table.insert(sources, diagnostics[linter[1]].with({ extra_args = vim.list_slice(linter, 2, #linter) }))
	end
end

null.setup({ sources = sources })
