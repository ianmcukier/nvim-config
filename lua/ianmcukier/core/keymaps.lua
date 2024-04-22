vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Save file
keymap.set("n", "<C-s>", "<cmd>write<cr>", { desc = "Save" })
keymap.set("i", "<C-s>", "<cmd>write<cr>", { desc = "Save" })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')
