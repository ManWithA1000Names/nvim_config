local M = {}

M.scheme = "tokyonight-night"

function M.update()
	vim.cmd("colorscheme " .. M.scheme)
end

function M.horizon()
	M.scheme = "horizon"
	M.update()
end

function M.tokyo()
	M.scheme = "tokyonight"
	M.update()
end

function M.toggle()
	if M.scheme == "horizon" then
		M.tokyo()
	else
		M.horizon()
	end
end

M.update()

return M
