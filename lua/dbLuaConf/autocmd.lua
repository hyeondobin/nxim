-- blink when yanking
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
-- change directory automatically --
-- https://www.reddit.com/r/neovim/comments/zy5s0l/you_dont_need_vimrooter_usually_or_how_to_set_up/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
-- root directory를 찾을 수 있게 해주는 file names
local root_names = { ".git", "flake.nix", "Makefile" }

-- 스피드를 올리기 위해 사용할 캐시
local root_cache = {}

local set_root = function()
	-- Get root directory path to start search from
	local path = vim.api.nvim_buf_get_name(0) -- 0은 현재 버퍼
	if path == "" then
		return
	end
	path = vim.fs.dirname(path)

	-- Try cache and resort to searching upward for root directory
	local root = root_cache[path]
	if root == nil then
		local root_file = vim.fs.find(root_names, { path = path, upward = true })[1]
		root = vim.fs.dirname(root_file)
		root_cache[path] = root
	end

	-- Set current directory
	vim.fn.chdir(root)
end

local root_augroup = vim.api.nvim_create_augroup("dbAutoRoot", {})
vim.api.nvim_create_autocmd("BufEnter", { group = root_augroup, callback = set_root })
