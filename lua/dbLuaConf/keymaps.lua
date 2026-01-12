local opts = { noremap = true, silent = false }

-- unmap space as it's leader key in normal mode.
vim.keymap.set("n", "<space>", "<nop>", opts)
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", opts)

vim.keymap.set("n", "<M-w>", "<cmd>:xa<CR>", opts)
vim.keymap.set("c", "<M-w>", "xa<CR>", opts)
-- vim.keymap.set("n", "WQ", "ZZ", opts)
vim.keymap.set("n", "<leader>w", vim.cmd.w, { desc = "Save current file", unpack(opts) })

-- Yanking with system clipboard
vim.keymap.set({ "n", "v", "x" }, "<leader>y", '"+y', { desc = "Yank to clipboard", unpack(opts) })
vim.keymap.set({ "n", "v", "x" }, "<leader>Y", '"+yy', { desc = "Yank line to clipboard", unpack(opts) })
vim.keymap.set({ "n", "v", "x" }, "<leader>p", '"+p', { desc = "Paste from clipboard", unpack(opts) })
vim.keymap.set("i", "<C-p>", "<C-r>+", { desc = "Paste from clipboard from within insert mode", unpack(opts) })
vim.keymap.set(
	"x",
	"<leader>P",
	'"_dP',
	{ desc = "Paste over selection without erasing unnamed register", unpack(opts) }
)

-- default movement, but better
vim.keymap.set("n", "j", "gj", opts)
vim.keymap.set("n", "k", "gk", opts)
vim.keymap.set("n", "{", "{zz", opts)
vim.keymap.set("n", "}", "}zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-o>", "<C-o>zz", opts)
vim.keymap.set("n", "<C-i>", "<C-i>zz", opts)
vim.keymap.set("n", "n", "nzzzv", opts)
vim.keymap.set("n", "N", "Nzzzv", opts)
vim.keymap.set("n", "%", "%zzzv", opts)
vim.keymap.set("n", "*", "*zzzv", opts)
vim.keymap.set("n", "#", "#zzzv", opts)
-- zv		View cursor line: Open just enough folds to make the line in
-- 		    which the cursor is located not folded.

-- move between windows with Ctrl + hjkl
vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)

-- move between buffers with Shift + H,L
vim.keymap.set("n", "H", "<cmd>bp<CR>", opts)
vim.keymap.set("n", "L", "<cmd>bn<CR>", opts)

-- new line before the cursor
vim.keymap.set("i", "<M-O>", "O", opts)

-- Cancel with C-c
vim.keymap.set("n", "<C-c>", "<Esc>", opts)

-- Move line
vim.keymap.set("v", "<M-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = false, desc = "Move the Line Up" })
vim.keymap.set("v", "<M-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = false, desc = "Move the Line Down" })

-- Rename word under cursor
vim.keymap.set("n", "S", function()
	local cmd = ":%s/<C-r><C-w>//gI<Left><Left><Left>"
	local keys = vim.api.nvim_replace_termcodes(cmd, true, false, true)
	vim.api.nvim_feedkeys(keys, "n", false)
end, { noremap = true, desc = "Rename word under the cursor" })
-- Rename <target> in region
vim.keymap.set("v", "S", function()
	local cmd = ":s//gI<Left><Left><Left>"
	local keys = vim.api.nvim_replace_termcodes(cmd, true, false, true)
	vim.api.nvim_feedkeys(keys, "n", false)
end, { noremap = true, desc = "Replace <target> in region" })

-- keep the selection while in/outdenting
vim.keymap.set("n", ">", ">gv", opts)
vim.keymap.set("n", "<", "<gv", opts)
--[[
gv			Start Visual mode with the same area as the previous
			area and the same mode.
			In Visual mode the current and the previous Visual
			area are exchanged.
			After using "p" or "P" in Visual mode the text that
			was put will be selected.
--]]

-- Utils

-- calculate current cursor's line
vim.keymap.set(
	"i",
	"<localleader>c",
	'<C-O>VY<C-O>$=<C-R>=<C-R>"<CR><C-O>yiw<C-O>$',
	{ desc = "Calculate current line" }
)
