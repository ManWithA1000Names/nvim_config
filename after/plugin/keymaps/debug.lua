local wk_ok, wk = pcall(require, "which-key")
if not wk_ok then
	return
end
local dap_ok, dap = pcall(require, "dap")
if not dap_ok then
	return
end
local ui_ok, ui = pcall(require, "dapui")
if not ui_ok then
	return
end

local function start()
	dap.continue()
end

local keys = {
	d = {
		name = "debug",
		s = { start, "Start" },
		q = { dap.close, "Quit" },
		p = { dap.pause, "Pause" },
		c = { dap.continue, "Continue" },
		u = { dap.step_out, "Step Out" },
		g = { dap.session, "Get Session" },
		i = { dap.step_into, "Step Into" },
		o = { dap.step_over, "Step Over" },
		b = { dap.step_back, "Step Back" },
    U = { ui.toggle, "Toggle dap ui" },
		d = { dap.disconnect, "Disconnect" },
		r = { dap.repl.toggle, "Toggle Repl" },
		C = { dap.run_to_cursor, "Run To Cursor" },
		t = { dap.toggle_breakpoint, "Toggle Breakpoint" },
	},
}

wk.register(keys, { prefix = "<leader>" })
