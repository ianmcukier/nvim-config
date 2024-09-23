vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Save file
keymap.set("n", "<C-s>", "<cmd>write<cr>", { desc = "Save" })
keymap.set("i", "<C-s>", "<cmd>write<cr>", { desc = "Save" })

-- Yank and paste from clipboard
keymap.set("n", "<leader>y", '"*y', { desc = "Yank clipboard" })
keymap.set("v", "<leader>y", '"*y', { desc = "Yank clipboard" })
keymap.set("n", "<leader>p", '"*p', { desc = "Paste clipboard" })
keymap.set("v", "<leader>p", '"*p', { desc = "Paste clipboard" })

-- Add empty lines before and after cursor line
keymap.set("n", "gO", "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>", { desc = "Blank line above" })
keymap.set("n", "go", "<Cmd>call append(line('.'),     repeat([''], v:count1))<CR>", { desc = "Blank line below" })

-- TIP: Disable arrow keys in normal mode
keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- keymap.set("n", "<leader>db", '<cmd>tabnew<CR><cmd>DBUI<CR>')
--

keymap.set("n", "]q", "<cmd>:cnext<CR>")
keymap.set("n", "[q", "<cmd>:cprevious<CR>")
keymap.set("n", "<C-w>h", "<cmd>:split<CR>")
