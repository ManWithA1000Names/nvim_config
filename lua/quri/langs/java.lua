local lang = require("quri.langs.setup")

local status, jdtls = pcall(require, "jdtls")
if not status then
	return false
end

local home = os.getenv("HOME")
local WORKSPACE_PATH = home .. "/workspace/"
local CONFIG = "linux"
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if root_dir == "" then
	return false
end

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = WORKSPACE_PATH .. project_name

local bundles = {}
local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/")
vim.list_extend(bundles, vim.split(vim.fn.glob(mason_path .. "packages/java-test/extension/server/*.jar"), "\n"))
vim.list_extend(
	bundles,
	vim.split(
		vim.fn.glob(mason_path .. "packages/java-debug-adapter/extension/server/com/microsoft.java.debug.plugin-*.jar"),
		"\n"
	)
)

local function capabilities()
	local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
	if not ok then
		local cap = vim.lsp.protocol.make_client_capabilities()
		cap.textDocument.completion.completionItem.snippetSupport = true
		cap.textDocument.completion.completionItem.resolveSupport = {
			properties = {
				"documentation",
				"detail",
				"additionalTextEdits",
			},
		}
		return cap
	end
	return cmp_lsp.default_capabilities()
end

local config = {
	cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-javaagent:" .. home .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar",
		"-Xms1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",

		-- 💀
		"-jar",
		vim.fn.glob(home .. "/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
		-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
		-- Must point to the                                                     Change this to
		-- eclipse.jdt.ls installation                                           the actual version

		-- 💀
		"-configuration",
		home .. "/.local/share/nvim/mason/packages/jdtls/config_" .. CONFIG,
		-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
		-- Must point to the                      Change to one of `linux`, `win` or `mac`
		-- eclipse.jdt.ls installation            Depending on your system.

		-- 💀
		-- See `data directory configuration` section in the README
		"-data",
		workspace_dir,
	},
	capabilities = capabilities(),
	root_dir = root_dir,
	settings = {
		java = {
			-- jdt = {
			--   ls = {
			--     vmargs = "-XX:+UseParallelGC -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dsun.zip.disableMemoryMapping=true -Xmx1G -Xms100m"
			--   }
			-- },
			eclipse = {
				downloadSources = true,
			},
			configuration = {
				updateBuildConfiguration = "interactive",
				runtimes = {
					{
						name = "JavaSE-11",
						path = "/usr/lib/jvm/java-11-openjdk",
					},
					--[[ { ]]
					--[[ 	name = "JavaSE-18", ]]
					--[[ 	path = "~/.sdkman/candidates/java/18.0.1.1-open", ]]
					--[[ }, ]]
					{
						name = "JavaSE-19",
						path = "/usr/lib/jvm/java-19-openjdk",
					},
				},
			},
			maven = {
				downloadSources = true,
			},
			implementationsCodeLens = {
				enabled = true,
			},
			referencesCodeLens = {
				enabled = true,
			},
			references = {
				includeDecompiledSources = true,
			},
			inlayHints = {
				parameterNames = {
					enabled = "all", -- literals, all, none
				},
			},
			format = {
				enabled = false,
				-- settings = {
				--   profile = "asdf"
				-- }
			},
		},
		signatureHelp = { enabled = true },
		completion = {
			favoriteStaticMembers = {
				"org.hamcrest.MatcherAssert.assertThat",
				"org.hamcrest.Matchers.*",
				"org.hamcrest.CoreMatchers.*",
				"org.junit.jupiter.api.Assertions.*",
				"java.util.Objects.requireNonNull",
				"java.util.Objects.requireNonNullElse",
				"org.mockito.Mockito.*",
			},
		},
		contentProvider = { preferred = "fernflower" },
		extendedClientCapabilities = extendedClientCapabilities,
		sources = {
			organizeImports = {
				starThreshold = 9999,
				staticStarThreshold = 9999,
			},
		},
		codeGeneration = {
			toString = {
				template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
			},
			useBlocks = true,
		},
	},

	flags = {
		allow_incremental_sync = true,
	},
	init_options = {
		bundles = bundles,
	},
}

local java = lang("java")
	:use("mfussenegger/nvim-jdtls")
	:formatter("google_java_format")
	:server("jdtls", function()
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "java" },
			callback = function()
				jdtls.start_or_attach(config)
				-- require("jdtls.dap").setup_dap_main_class_configs()
				-- jdtls.setup_dap({ hotcodereplace = "auto" })
				-- ^^^^^^^^^^^^^^^ I don't know about this one!
			end,
		})
	end)
	:lsp_format(false)
	:keymaps({
		i = { jdtls.organizeImports, "OrganizeImports" },
		v = { jdtls.extract_variable, "Extract Variable" },
		c = { jdtls.extract_constant, "Extract Constant" },
		t = { jdtls.test_nearest_method, "Test Method" },
		T = { jdtls.test_class, "Test Class" },
		u = { "<cmd>JdtUpdateConfig<CR>", "Update Config" },
	})

return java
