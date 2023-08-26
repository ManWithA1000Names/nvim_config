--[[
 -- todo
 -- setup harpoon

--]]
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1
require("quri.nvim-tree")

require("quri.set")
require("quri.packer")
require("quri.colorscheme")

vim.api.nvim_create_autocmd({ [[InsertEnter]] }, {
	pattern = { "*.js", "*.ts" },
	callback = function()
		print("gotcha bitch insert!")
	end,
})

vim.api.nvim_create_autocmd({ [[FileType]] }, {
	pattern = { "javascript", },
	callback = function()
		print("from filetype!")
	end,
})
