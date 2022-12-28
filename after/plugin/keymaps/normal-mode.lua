local wk_ok, wk = pcall(require, "which-key")
if not wk_ok then
	return
end

local active_term = nil
local function new_term()
	local ok, term = pcall(require, "toggleterm.terminal")
	if ok then
		if active_term == nil then
			active_term = term.Terminal:new({
				direction = "horizontal",
			})
		end
		active_term:toggle()
	end
end

local function telescope()
	local t_ok, builtin = pcall(require, "telescope.builtin")
	if not t_ok then
		error("telescope.builtin failed to be required.")
	end
	local theme_ok, themes = pcall(require, "telescope.themes")
	if not theme_ok then
		error("telescope.builtin failed to be required.")
	end
	return builtin, themes
end

local function find_files()
	local ok, builtin, themes = pcall(telescope)
	if not ok then
		return
	end
	builtin.find_files(themes.get_dropdown({ previewer = false }))
end

local function buffers()
	local ok, builtin, themes = pcall(telescope)
	if not ok then
		return
	end
	builtin.buffers(themes.get_dropdown({ previewer = false }))
end

local function save_source()
	vim.cmd("w")
	vim.cmd("so")
end

local function nvim_tree_focus_toggle()
	local winNum = vim.api.nvim_get_current_win()
	vim.api.nvim_create_autocmd("WinEnter", {
		callback = function()
			if vim.bo.filetype ~= "NvimTree" then
				winNum = vim.api.nvim_get_current_win()
			end
		end,
	})
	return function()
		if vim.bo.filetype == "NvimTree" then
			vim.api.nvim_set_current_win(winNum)
		else
			vim.cmd("NvimTreeFocus")
		end
	end
end

local function buffer_kill()
	-- copied and modified from lunarvim ...lvim/lua/lvim/core/bufferline.lua;
	local kill_command = "bd!"

	local bo = vim.bo
	local api = vim.api

	local bufnr = api.nvim_get_current_buf()

	-- Get list of windows IDs with the buffer to close
	local windows = vim.tbl_filter(function(win)
		return api.nvim_win_get_buf(win) == bufnr
	end, api.nvim_list_wins())

	if #windows == 0 then
		return
	end

	-- Get list of active buffers
	local current_buffers = vim.tbl_filter(function(buf)
		return api.nvim_buf_is_valid(buf) and bo[buf].buflisted
	end, api.nvim_list_bufs())

	-- If there is only one buffer (which has to be the current one), vim will
	-- create a new buffer on :bd.
	-- For more than one buffer, pick the previous buffer (wrapping around if necessary)
	if #current_buffers > 1 then
		for i, v in ipairs(current_buffers) do
			if v == bufnr then
				local prev_buf_idx = i == 1 and (#current_buffers - 1) or (i - 1)
				local prev_buffer = current_buffers[prev_buf_idx]
				for _, win in ipairs(windows) do
					api.nvim_win_set_buf(win, prev_buffer)
				end
			end
		end
	end

	-- Check if buffer still exists, to ensure the target buffer wasn't killed
	-- due to options like bufhidden=wipe.
	if api.nvim_buf_is_valid(bufnr) and bo[bufnr].buflisted then
		vim.cmd(string.format("%s %d", kill_command, bufnr))
	end
end

local keys = {
	Y = { "yg$", "Copy to end of line" },
	Q = { "<nop>", "Disable command mode" },
	H = { ":BufferLineCyclePrev<CR>", "Prev buffer" },
	L = { ":BufferLineCycleNext<CR>", "Next buffer" },
	n = { "nzzzv", "Go to next match and center the screen" },
	N = { "Nzzzv", "Go to prev match and center the screen" },

	["."] = { ";", "next thing" },
	["'"] = { ":w<CR>", "Save" },
	["\\"] = { "za", "Fold" },
	['"'] = { ":nohl<CR>", "no highlight" },
	["<C-h>"] = { "<C-w>h", "Move to the window to the left" },
	["<C-j>"] = { "<C-w>j", "Move to the window below" },
	["<C-k>"] = { "<C-w>k", "Move to the window above" },
	["<C-l>"] = { "<C-w>l", "Move to the window to the right" },
	["<C-q>"] = { ":q<CR>", "Quit" },
	["<A-j>"] = { ":m .+1<CR>==", "Move current line up" },
	["<A-k>"] = { ":m .-2<CR>==", "Move current line down" },
	["<Return>"] = { "@a", "Map enter to the 'a' macro" },
	["<C-Up>"] = { ":resize -2<CR>", "Make the smaller on the y axis" },
	["<C-Down>"] = { ":resize +2<CR>", "Make the window bigger on the y axis" },
	["<C-Left>"] = { ":vertical resize +2<CR>", "Make the window bigger on the x axis" },
	["<C-Right>"] = { ":vertical resize -2<CR>", "Make the window smaller on the x axis" },
}

local leaderKeys = {
	q = { ":qa<CR>", "Quit all" },
	w = { ":wa<CR>", "Save all" },
	T = { new_term, "New terminal" },
	b = { buffers, "Buffer picker" },
	f = { find_files, "File picker" },
	c = { buffer_kill, "Close buffer" },
	o = { save_source, "Save & source" },
	v = { ":vsplit<CR>", "Vertical Split" },
	D = { '"_d', "Delete without copying" },
	x = { ":split<CR>", "Horizontal Split" },
	y = { '"+y', "Copy to system clipboard" },
	W = { "<cmd>wqa<CR>", "Save and quit all" },
	p = { '"+p', "Paste from system clipboard" },
	e = { nvim_tree_focus_toggle(), "Nvim tree" },
	h = { ":lua print('harpooning')<CR>", "Harpoon" },
	E = { ":NvimTreeToggle<CR>", "Nvim tree troggle" },
	Q = { "<cmd>wqa!<CR>", "Quit all, no matter what" },
	s = { ":Telescope live_grep<CR>", "Project search" },
	t = { ":ToggleTerm<CR>", "Toggle terminal" },
	S = { ":Telescope spell_suggest<CR>", "Spelling suggestions" },
	Y = { '"+Y', "Copy rest of the line to system clipboard", noremap = true },

	V = {
		name = "vim",
		c = { ":e " .. vim.fn.stdpath("config") .. "/init.lua<CR>", "Edit config" },
		p = { ":e " .. vim.fn.stdpath("config") .. "/lua/quri/packer.lua<CR>", "Edit packer file" },
		P = { ":PackerSync<CR>", "Packer Sync" },
	},

	g = {
		name = "git",
		-- Gitsigns
		b = { ":Gitsigns blame_line<CR>", "Blame" },
		d = { ":Gitsigns diffthis HEAD<CR>", "Diff" },
		j = { ":Gitsigns next_hunk<CR>", "Next hunk" },
		k = { ":Gitsigns prev_hunk<CR>", "Prev hunk" },
		r = { ":Gitsigns reset_hunk<CR>", "Reset hunk" },
		s = { ":Gitsigns state_hunk<CR>", "Stage hunk" },
		R = { ":Gitsigns reset_buffer<CR>", "Reset hunk" },
		p = { ":Gitsigns preview_hunk<CR>", "Preview hunk" },
		u = { ":Gitsigns undo_stage_hunk<CR>", "Unstage hunk" },
		-- Telescope
		c = { ":Telescope git_commits<CR>", "Checkout commit" },
		o = { ":Telescope git_status<CR>", "Open changed files" },
		C = { ":Telescope git_bcommits<CR>", "Checkout commit (for current file)" },
	},
}

wk.register(keys)
wk.register(leaderKeys, { prefix = "<leader>" })
