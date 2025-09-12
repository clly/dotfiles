-- Rust Keybindings Modal
local M = {}

-- Read the keybindings file and format for display
local function get_keybindings_content()
    local file_path = vim.fn.stdpath("config") .. "/../RUST_KEYBINDINGS.md"
    local file = io.open(file_path, "r")
    
    if not file then
        return {"Error: Could not read RUST_KEYBINDINGS.md"}
    end
    
    local lines = {}
    for line in file:lines() do
        table.insert(lines, line)
    end
    file:close()
    
    return lines
end

-- Create and show the modal window
local function show_keybindings_modal()
    local content = get_keybindings_content()
    
    -- Calculate window dimensions
    local width = 80
    local height = math.min(#content + 2, vim.o.lines - 4)
    
    local win_opts = {
        relative = 'editor',
        width = width,
        height = height,
        col = math.floor((vim.o.columns - width) / 2),
        row = math.floor((vim.o.lines - height) / 2),
        style = 'minimal',
        border = 'rounded',
        title = ' Rust Keybindings ',
        title_pos = 'center'
    }
    
    -- Create buffer
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
    
    -- Set buffer options
    vim.api.nvim_buf_set_option(buf, 'modifiable', false)
    vim.api.nvim_buf_set_option(buf, 'readonly', true)
    vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
    
    -- Create window
    local win = vim.api.nvim_open_win(buf, true, win_opts)
    
    -- Set window options
    vim.api.nvim_win_set_option(win, 'wrap', true)
    vim.api.nvim_win_set_option(win, 'cursorline', false)
    
    -- Key mapping to close modal
    local close_modal = function()
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end
        if vim.api.nvim_buf_is_valid(buf) then
            vim.api.nvim_buf_delete(buf, {force = true})
        end
    end
    
    -- Set keymaps for the modal
    local opts = {buffer = buf, noremap = true, silent = true}
    vim.keymap.set('n', 'q', close_modal, opts)
    vim.keymap.set('n', '<Esc>', close_modal, opts)
    vim.keymap.set('n', '??', close_modal, opts)
end

-- Setup function to create the keybinding
function M.setup()
    -- Create the ?? keybinding
    vim.keymap.set('n', '??', show_keybindings_modal, {
        noremap = true,
        silent = true,
        desc = 'Show Rust Keybindings Modal'
    })
    
    -- Also create a command for alternative access
    vim.api.nvim_create_user_command('RustKeybindings', show_keybindings_modal, {
        desc = 'Show Rust Keybindings Modal'
    })
end

-- Auto-setup when required
M.setup()

return M