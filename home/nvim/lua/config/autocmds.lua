-- Жорсткий контроль табуляції для ВСІХ filetype
-- Реєструється після вбудованих indent-скриптів Neovim, тому завжди перебиває їх

vim.api.nvim_create_autocmd("FileType", {
	pattern = "c",
	callback = function()
		vim.b.autoformat = false
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		vim.opt_local.expandtab = false
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
	end,
})

-- Виняток тільки для YAML (реально вимагає пробілів синтаксично)
vim.api.nvim_create_autocmd("FileType", {
	pattern = "yaml",
	callback = function()
		vim.opt_local.expandtab = true
		vim.opt_local.tabstop = 2
		vim.opt_local.shiftwidth = 2
	end,
})
