local M = {}

-- Function to handle custom gf behavior using Treesitter
function M.CustomGF()
    local word = vim.fn.expand('<cfile>')

    -- Check if the word under the cursor is a file path
    if vim.fn.filereadable(word) == 1 or vim.fn.isdirectory(word) == 1 then
        -- Use the default behavior for gf (go to file)
        vim.cmd('normal! gf')
        return
    end

    -- Use Treesitter to identify function nodes
    local ts_utils = require'nvim-treesitter.ts_utils'
    local current_node = ts_utils.get_node_at_cursor()

    if not current_node then
        return
    end

    -- Find the function node
    while current_node do
        if current_node:type() == 'function' or current_node:type() == 'function_definition' or
           current_node:type() == 'method_definition' or current_node:type() == 'func' then
            break
        end
        current_node = current_node:parent()
    end

    if not current_node then
        return
    end

    local start_row, _, end_row, _ = current_node:range()

    -- Get current cursor position
    local current_line = vim.fn.line('.') - 1

    if current_line == start_row then
        -- If already at the start, jump to the end of the function
        vim.api.nvim_win_set_cursor(0, {end_row + 1, 0})
    else
        -- Jump to the start of the function
        vim.api.nvim_win_set_cursor(0, {start_row + 1, 0})
    end
end

return M

