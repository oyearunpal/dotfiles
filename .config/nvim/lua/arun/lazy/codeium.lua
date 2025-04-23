return {
    "Exafunction/codeium.nvim",
    event = 'BufEnter',
    dependencies = {
        "nvim-lua/plenary.nvim",
        "hrsh7th/nvim-cmp",
    },
    config = function()
        require("codeium").setup({
            -- api_key= "da0625aa-b31e-4dfc-a4c9-8ba25edb3928",
            -- config_path = "/home/irage/.cache/codeium",
            enable_chat= true,
            -- bin_path="/home/irage/.local/share/codeium",
            chat_max_rows = 100,
            chat_input_row = 1,
        })
    end
}
