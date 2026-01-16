local indent = 4

-- Tab / Indentation
vim.opt.tabstop = indent
vim.opt.shiftwidth = indent
vim.opt.softtabstop = indent
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = true

-- Search
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split"

-- Appearance
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showmode = false
vim.opt.signcolumn = "yes:1"
vim.opt.colorcolumn = "100"
vim.opt.cmdheight = 1
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.conceallevel = 0
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Behavior
vim.opt.hidden = true
vim.opt.scrolloff = 15
vim.opt.errorbells = false
vim.opt.completeopt = "menuone,popup,fuzzy,preview"
vim.opt.backspace = "indent,eol,start"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.iskeyword:append("-")
vim.opt.mouse = "a"
vim.opt.modifiable = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.updatetime = 200

-- File
vim.opt.encoding = "UTF-8"
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undodir = vim.fn.expand("~/.local/state/nvim/undodir")
vim.opt.undofile = true
