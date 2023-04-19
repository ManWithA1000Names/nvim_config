local ok, tree = pcall(require, "nvim-tree")
if not ok then
	print("no ok!")
	return
end

local on_attach = require("quri.nvim-tree-custom-on-attach")

tree.setup({
	on_attach = on_attach,
	sync_root_with_cwd = true,
	respect_buf_cwd = true,
	update_focused_file = {
		enable = true,
		update_root = true,
	},
})
