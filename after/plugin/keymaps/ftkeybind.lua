local ok, wk = pcall(require, "which-key")
if not ok then
	return
end

local keybinds = require("quri.compiled").keybinds

local function transform(binds)
	binds.name = vim.bo.filetype
	return {
		k = binds,
	}
end

local function on_buffer_open(opts)
	local ftkeybinds = keybinds[vim.bo.filetype]
	if ftkeybinds == nil then
		return
	end
	wk.register(transform(ftkeybinds), {
		prefix = "<leader>",
		buffer = opts.buf,
	})
end

vim.api.nvim_create_autocmd("FileType", { callback = on_buffer_open })
