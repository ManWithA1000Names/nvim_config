local ok, packer = pcall(require, "packer")
if not ok then
	return
end

local default_plugins = {
	-- packer manages it self
	"wbthomason/packer.nvim",
	-- colorschemes
	"folke/tokyonight.nvim",
	"lunarvim/horizon.nvim",
	-- key mapping
	"folke/which-key.nvim",
	-- start completion --
	-- engines
	"hrsh7th/nvim-cmp",
	"L3MON4D3/LuaSnip",
	-- sources
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-cmdline",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-nvim-lsp-signature-help",
	"saadparwaiz1/cmp_luasnip",
	{ "mtoohey31/cmp-fish", ft = "fish" },
	-- end completion --
	-- lsp
	"neovim/nvim-lspconfig",
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
	"jose-elias-alvarez/null-ls.nvim",
	{
		"j-hui/fidget.nvim",
		config = function()
			require("fidget").setup()
		end,
	},
	-- syntax highlighting
	"nvim-treesitter/nvim-treesitter",
	-- To infinity and beyond
	"nvim-lua/plenary.nvim",
	"BurntSushi/ripgrep",
	"nvim-telescope/telescope.nvim",
	-- debugging
	{ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } },
	-- file explorer
	{
		"nvim-tree/nvim-tree.lua",
		requires = { "nvim-tree/nvim-web-devicons" },
	},
	-- buffer line
	{
		"akinsho/bufferline.nvim",
		tag = "v2.*",
		reqruies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup({
				options = {
					diagnostics = "nvim_lsp",
					offsets = {
						{
							filetype = "NvimTree",
							text = "Explorer",
							highlight = "PanelHeading",
							padding = 1,
						},
						{
							filetype = "packer",
							text = "Packer",
							highlight = "PanelHeading",
							padding = 1,
						},
					},
				},
			})
		end,
	},
	-- terminal
	{
		"akinsho/toggleterm.nvim",
		tag = "*",
		config = function()
			require("toggleterm").setup()
		end,
	},
	-- autopairs
	"windwp/nvim-autopairs",
	"windwp/nvim-ts-autotag",
	-- commenting
	"numToStr/Comment.nvim",
	"JoosepAlviste/nvim-ts-context-commentstring",
  -- git
  {"lewis6991/gitsigns.nvim", config = function ()
    require("gitsigns").setup()
  end}
}

local lang_plugins = require("quri.compiled").packer

local plugins = vim.list_extend(default_plugins, lang_plugins)

return packer.startup(function(use)
	for _, plugin in ipairs(plugins) do
		use(plugin)
	end
end)
