local lang = require("quri.langs.setup")

---Split a string by a specified sperator
---@param string string
---@param sep string
---@return table
local function split_str(string, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for str in string.gmatch(string, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end
	return t
end

return lang("c"):server("clangd"):lsp_format(true):debug({
	{
		name = "Launch file",
		type = "codelldb",
		request = "launch",
		args = function()
			local args
			vim.ui.input({ prompt = "Args: ", default = "" }, function(input)
				args = input
			end)
			return split_str(args, " ")
		end,
		program = function()
			local path
			vim.ui.input({ prompt = "Path to executable: ", default = vim.loop.cwd() .. "/" }, function(input)
				path = input
			end)
			vim.cmd("redraw")
			return path
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
	},
})
