return {
	"tpope/vim-fugitive",
	lazy = true,
	cmd = { "Git", "G" }, -- Lazy load on these commands
	config = function()
		-- Your configuration for vim-fugitive
		-- For example, setting up keybindings:
		vim.api.nvim_set_keymap("n", "<leader>gs", ":Git status<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("n", "<leader>gc", ":Git commit<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("n", "<leader>gp", ":Git push<CR>", { noremap = true, silent = true })
	end,
}
