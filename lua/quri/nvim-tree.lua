local ok, tree = pcall(require, "nvim-tree")
if not ok then
	return
end
local api = require("nvim-tree.api")

tree.setup({
	on_attach = function(bufnr)
		vim.schedule(function()
			vim.api.nvim_set_option_value("cursorline", true, { buf = bufnr })
		end)
		vim.keymap.set("n", "l", function()
			api.node.open.edit()
		end, { noremap = true, buffer = bufnr })
		vim.keymap.set("n", "h", function()
			api.node.navigate.parent_close()
		end, { noremap = true, buffer = bufnr })
	end,
	hijack_netrw = true,
	open_on_setup = true,
	open_on_setup_file = false,
	update_focused_file = {
		enable = true,
		update_root = true,
	},
	hijack_directories = {
		enable = true,
		auto_open = true,
	},
	diagnostics = {
		enable = true,
		show_on_dirs = true,
		icons = {
			hint = "",
			info = "",
			warning = "",
			error = "",
		},
	},
	renderer = {
		indent_markers = {
			enable = true,
		},
	},
})
