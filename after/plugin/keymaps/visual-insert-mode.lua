local wk_ok, wk = pcall(require, "which-key")
if not wk_ok then
	return
end

local keysV = {
	J = { ":m '>+1<CR>gv=gv", "move current selection up" },
	K = { ":m '<-2<CR>gv=gv", "move current selection down" },
	["<"] = { "<gv", "dedent" },
	[">"] = { ">gv", "indent" },
	["<A-j>"] = { ":m '>+1<CR>gv=gv" },
	["<A-k>"] = { ":m '<-2<CR>gv=gv" },
}

local leaderKeysV = {
	d = { '"_d', "Delete wihtout copying" },
	p = { '"_dP"', "Patse without copying" },
	y = { '"+y', "Copy to system clipbaord" },
	P = { '"_d"+P', "Paste from the clipboard without copying" },
}

local keysI = {
	["jk"] = { "<Esc>", "Exit insert mode" },
	["kj"] = { "<Esc>", "Exit insert mode" },
	["<A-j>"] = { "<Esc>:m .+1<CR>==gi", "Move current line up" },
	["<A-k>"] = { "<Esc>:m .-2<CR>==gi", "Move current line down" },
}

function _G.set_terminal_keymaps()
	local opts = { buffer = 0, noremap = true, silent = true }
	vim.keymap.set("t", "<esc>", [[<C-\><C-n>:ToggleTermToggleAll<CR>]], opts)
	vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
	vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
	vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
	vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
	vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

wk.register(keysI, { mode = "i" })
wk.register(keysV, { mode = "v" })
wk.register(leaderKeysV, { mode = "v", prefix = "<leader>" })
