vim.keymap.set("n", "<C-s>", ":w<cr>")

-- nvim-tmux-navigator
vim.keymap.set("n", "<C-h>", ":TmuxNavigateLeft<CR>")
vim.keymap.set("n", "<C-l>", ":TmuxNavigateRight<CR>")
vim.keymap.set("n", "<C-j>", ":TmuxNavigateDown<CR>")
vim.keymap.set("n", "<C-k>", ":TmuxNavigateUp<CR>")

-- Moved blocks in visual mode while also indenting
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gb=gb")

-- Lets you paste the following line to the current without moving cursor
vim.keymap.set("n", "J", "mzJ`z")
-- Half-page jumps while centering cursor
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- Search next/prev while centering selection
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Pastes without overwriting paste
vim.keymap.set("x", "<leader>p", [["_dP]])
-- Deletes without overwriting paste
vim.keymap.set("n", "<leader>d", [["_d]])
vim.keymap.set("v", "<leader>d", [["_d]])

-- Copy's to system clipboard
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("n", "<leader>f", function ()
  vim.lsp.buf.format()
end)

-- Replaces the word the cursor is on
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- Sets the current file to executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
