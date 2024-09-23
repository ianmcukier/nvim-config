return {
	"L3MON4D3/LuaSnip",
	dependencies = {
		"rafamadriz/friendly-snippets", -- useful snippets
	},
	-- install jsregexp (optional!).
	build = (function()
		require("luasnip.loaders.from_vscode").lazy_load()

		-- Build Step is needed for regex support in snippets.
		-- This step is not supported in many windows environments.
		-- Remove the below condition to re-enable on windows.
		if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
			return
		end
		return "make install_jsregexp"
	end)(),
	config = function()
		require("luasnip").filetype_extend("dart", { "flutter" })
	end,
}
