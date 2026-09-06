local opt = vim.opt

opt.cursorline = true
opt.termguicolors = true
opt.relativenumber = true
opt.number = true
opt.pumheight = 10

opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.wrap = true

opt.ignorecase = true
opt.smartcase = true

opt.splitright = true
opt.splitbelow = true

opt.signcolumn = "yes"
opt.guifont = "JetBrainsMono NFM:h6"
opt.inccommand = "split"
opt.incsearch = true
opt.hlsearch = true
opt.undofile = true

opt.winborder = "rounded"
opt.pumborder = "rounded"

opt.diffopt = {
	"internal",
	"filler",
	"closeoff",
	"context:3",
	"algorithm:patience",
	"indent-heuristic",
	"linematch:60",
}

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight yanked text",
	group = vim.api.nvim_create_augroup("ianmcukier-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})
