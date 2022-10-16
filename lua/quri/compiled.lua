---@class CompiledOutput
---@field packer (string | table)[]
---@field linters (string | table)[]
---@field formatters (string | table)[]
---@field lspconfigs table<string, fun(lspconfig: table):any>
---@field skipped_format_servers table<string, boolean>
---@field keybinds table<string, table<string, string[]>>
---@field debug_configs table<string, table | function>

---@type CompiledOutput
local M = {
	packer = {},
	linters = {},
	keybinds = {},
	formatters = {},
	lspconfigs = {},
  debug_configs = {},
	skipped_format_servers = {},
}

---@type LanguageConfig[]
local langs = require("quri.langs")

---Compile a language into a combined compiled output
---that can be consumed by packer, mason and null-ls
---@param lang LanguageConfig
local function compile(lang)
	vim.list_extend(M.packer, lang._plugins)
	vim.list_extend(M.linters, lang._linters)
	vim.list_extend(M.formatters, lang._formatters)

	-- disable formatting
	if lang._disable_lsp_formatting then
		for _, server in ipairs(lang._servers) do
			M.skipped_format_servers[server] = true
		end
	end

	-- setup the compiled lspconfigs
	for server, config in pairs(lang._custom_lspconfigs) do
		if type(config) == "function" then
			M.lspconfigs[server] = config
		else
			M.lspconfigs[server] = function(lspconfig)
				lspconfig[server].setup(config)
			end
		end
	end

	if lang._custom_keymaps then
		M.keybinds[lang._name] = lang._custom_keymaps
	end

	if lang._custom_debug_config then
		M.debug_configs[lang._name] = lang._custom_debug_config
	end
end

for _, lang in ipairs(langs) do
	compile(lang)
end

return M
