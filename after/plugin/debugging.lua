local ok, dap = pcall(require, "dap")
if not ok then
	print("NO DAP")
	return
end

local ok_ui, ui = pcall(require, "dapui")
if not ok_ui then
	print("NO DAP-UI")
	return
end

ui.setup({
	layouts = {
		{
			elements = {
				{ id = "scopes", size = 0.25 },
				"breakpoints",
				"stacks",
				"watches",
			},
			size = 40, -- 40 columns
			position = "right",
		},
		{
			elements = {
				"repl",
				"console",
			},
			size = 0.25, -- 25% of total lines
			position = "bottom",
		},
	},
})

dap.listeners.after.event_initialized["dapui_config"] = function()
	ui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
	ui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
	ui.close()
end

vim.fn.sign_define("DapBreakpoint", {
	text = "",
	texthl = "LspDiagnosticsSignError",
	linehl = "",
	numhl = "",
})
vim.fn.sign_define("DapBreakpointRejected", {
	text = "",
	texthl = "LspDiagnosticsSignHint",
	linehl = "",
	numhl = "",
})
vim.fn.sign_define("DapStopped", {
	text = "",
	texthl = "LspDiagnosticsSignInformation",
	linehl = "DiagnosticUnderlineInfo",
	numhl = "LspDiagnosticsSignInformation",
})

for lang, config in pairs(require("quri.compiled").debug_configs) do
	if type(config) == "function" then
		pcall(config, dap)
	else
		dap.configurations[lang] = config
	end
end
