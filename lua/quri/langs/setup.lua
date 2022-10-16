---@class LanguageConfig
---@field _name string #the filetype of the language
---@field _plugins table[] #A table of packer plugins to be used with this langauge
---@field _servers string[] #a table of servers to be activated with this language
---@field _linters string[][] #a table of linters to be activated with this language
---@field _formatters string[][] #a table of linters to be activated with this language
---@field _custom_lspconfigs table<string, table | fun(lspconfig: table): any> #a custom lspconfig table or a function that will handle hte lspconfig by it self
---@field _disable_lsp_formatting boolean|nil # is the ls native formatting should be disabled, auto disabled if formatter is present.
---@field _custom_keymaps table<string, string[]>? # custom keymaps for this filetype
---@field _custom_debug_config (table|function)? # custom dap config for the lang
---@field use fun(this: LanguageConfig, plugin: string | table, ft?: boolean): LanguageConfig # register a plugin
---@field server fun(this: LanguageConfig, server_name: string, custom_lspconfig?: table | fun(lspconfig: table): any): LanguageConfig # register a language server
---@field formatter fun(this: LanguageConfig, formatter: string | string[]): LanguageConfig # register a formatter
---@field linter fun(this: LanguageConfig, linter: string | string[]): LanguageConfig # register a linter
---@field lsp_format fun(this: LanguageConfig, on: boolean): LanguageConfig # set lsp_format on or off (off by default, when at least one formatter is provided)
---@field keymaps fun(this: LanguageConfig, keys: table<string, string[]>): LanguageConfig # set custom keymaps activated on filetype , available under <leader>g
---@field debug fun(this: LanguageConfig, config: table | function): LanguageConfig # set a custom debug config for the language.

---Create a new langauge module
---@param name string The name of the language, USE THE FILTYPE ex. lua, python NOT py, js.
---@return LanguageConfig config new language config
return function(name)
	---@type LanguageConfig
	local m = {
		_name = name,
		_plugins = {},
		_servers = {},
		_linters = {},
		_formatters = {},
		_custom_lspconfigs = {},
		_disable_lsp_formatting = nil,
		_custom_keymaps = nil,
		_custom_debug_config = nil,
	}

	function m:use(plugin, ft)
		self._has_plugins = true
		if ft then
			if type(plugin) == "table" then
				if plugin.ft == nil then
					plugin.ft = self._name
				end
				table.insert(self._plugins, plugin)
			else
				table.insert(self._plugins, { plugin, ft = self._name })
			end
		else
			table.insert(self._plugins, plugin)
		end
		return self
	end

	function m:server(server_name, config)
		table.insert(self._servers, server_name)
		if config ~= nil then
			self._custom_lspconfigs[server_name] = config
		end
		return self
	end

	function m:formatter(formatter)
		if self._disable_lsp_formatting == nil then
			self._disable_lsp_formatting = true
		end
		table.insert(self._formatters, formatter)
		return self
	end

	function m:linter(linter)
		table.insert(self._linters, linter)
		return self
	end

	function m:lsp_format(on)
		self._disable_lsp_formatting = not on
		return self
	end

	function m:keymaps(keys)
		self._custom_keymaps = keys
		return self
	end

	function m:debug(config)
		self._custom_debug_config = config
		return self
	end

	return m
end
