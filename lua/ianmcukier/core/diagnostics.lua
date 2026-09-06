vim.diagnostic.config({
	virtual_text = true,
	underline = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "󰠠",
			[vim.diagnostic.severity.HINT] = "",
		},
	},
	float = {
		source = "if_many",
		header = "",
		focusable = false,
	},
})
