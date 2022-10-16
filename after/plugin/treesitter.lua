local ok, configs = pcall(require, "nvim-treesitter.configs")
if not ok then
	return
end

configs.setup({
	ensure_installed = {
		"lua",
		"rust",
		"typescript",
		"javascript",
		"tsx",
		"css",
		"html",
		"go",
    "gomod",
		"bash",
		"fish",
		"julia",
		"json",
		"toml",
		"yaml",
		"python",
		"prisma",
    "c",
    "cpp",
	},
	sync_install = false,
	highlight = {
		enable = true,
		disable = { "" },
		additional_vim_regex_highlighting = true,
	},
	indent = { enable = true, disable = { "yaml" } },
	autotag = {
		enable = true,
	},
})
