return {
	-- codeium
	"Exafunction/codeium.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"hrsh7th/nvim-cmp",
	},
	-- before = "nvim-cmp",
	config = function()
		require("codeium").setup({})
	end,
}
