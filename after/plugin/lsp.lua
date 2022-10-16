local ok, lspconfig = pcall(require, "lspconfig")
if not ok then
	return
end
local mason_ok, mason = pcall(require, "mason")
if not mason_ok then
	return
end
local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_ok then
	return
end

mason.setup()
mason_lspconfig.setup()

local handlers = {
	function(server)
		local found, mason_config = pcall(require, "mason-lspconfig.server_configurations." .. server)
		if found then
			lspconfig[server].setup(mason_config())
		else
			lspconfig[server].setup({})
		end
	end,
}

for server_name, handler in pairs(require("quri.compiled").lspconfigs) do
	handlers[server_name] = function()
		handler(lspconfig)
	end
end

mason_lspconfig.setup_handlers(handlers)

local cmp_ok, comp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if cmp_ok then
	comp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())
end
