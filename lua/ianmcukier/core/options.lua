vim.cmd("let g:netrw_liststyle = 3")
-- vim.cmd("language en_US")
vim.cmd("let g:tmux_navigator_disable_when_zoomed = 1")
-- vim.cmd("let g:pumheight = 10")

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = false

local opt = vim.opt

opt.termguicolors = true
opt.encoding = "utf-8"
opt.relativenumber = true
opt.number = true
opt.pumheight = 10

-- tabs & identation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

opt.wrap = true

-- search settings
opt.ignorecase = true
opt.smartcase = true

-- split windows
opt.splitright = true
opt.splitbelow = true

-- misc
opt.signcolumn = "yes"
opt.backspace = "indent,eol,start"
opt.guifont = "JetBrainsMono NFM:h6"

-- Preview substitutions live, as you type!
opt.inccommand = "split"

-- Set cighlight on search, but clear on pressing <Esc> in normal mode
opt.hlsearch = true

-- Save undo history
vim.opt.undofile = true

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  Skkee `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
