# Neovim IDE Configuration

A modular Neovim configuration that transforms Vim into a basic IDE with file explorer and editor panes.

## Installation

1. Copy the `nvim` directory to your Neovim config location:
   ```bash
   cp -r nvim/.config/nvim ~/.config/
   ```

2. Start Neovim - plugins will auto-install on first launch:
   ```bash
   nvim
   ```

## Features

- **File Explorer**: nvim-tree provides a directory tree sidebar
- **Split Panes**: Easy navigation between file explorer and editor
- **Modern UI**: Tokyo Night theme with lualine status bar
- **Extensible**: Modular structure for easy additions

## Key Mappings

### File Explorer
- `<Space>e` - Toggle file explorer
- `<Space>o` - Focus file explorer
- `Enter` (in file explorer) - Open file and close explorer
- `a` (in file explorer) - Create new file/folder
- `d` (in file explorer) - Delete file/folder
- `r` (in file explorer) - Rename file/folder

### Window Navigation
- `Ctrl+h` - Move to left pane
- `Ctrl+j` - Move to bottom pane
- `Ctrl+k` - Move to top pane
- `Ctrl+l` - Move to right pane

### Window Management
- `<Space>sv` - Split window vertically
- `<Space>sh` - Split window horizontally
- `<Space>se` - Make splits equal size
- `<Space>sx` - Close current split

### Window Resizing
- `Ctrl+Up` - Resize window up
- `Ctrl+Down` - Resize window down
- `Ctrl+Left` - Resize window left
- `Ctrl+Right` - Resize window right

### Buffer Navigation
- `Shift+l` - Next buffer
- `Shift+h` - Previous buffer
- `<Space>x` - Close buffer

### File Operations
- `<Space>w` - Save file
- `<Space>q` - Quit
- `<Space>Q` - Quit all

### Editing
- `<Space>nh` - Clear search highlights
- `J/K` (in visual mode) - Move selection up/down
- `<` / `>`  (in visual mode) - Indent left/right and stay in visual mode

## Basic Usage

1. Open Neovim in your project directory:
   ```bash
   cd your-project
   nvim
   ```

2. Press `<Space>e` to toggle the file explorer

3. Navigate the file tree with arrow keys or `hjkl`

4. Press `Enter` on a file to open it in the editor pane

5. Use `Ctrl+h` and `Ctrl+l` to move between file explorer and editor

6. Use `<Space>w` to save files and `<Space>q` to quit

## Directory Structure

```
nvim/
├── .config/
│   └── nvim/
│       ├── init.lua              # Main configuration entry point
│       └── lua/
│           └── config/
│               ├── plugins.lua   # Plugin management and setup
│               └── keymaps.lua   # Key mapping definitions
```

## Extending the Configuration

The configuration is designed to be easily extensible:

### Adding New Plugins

Edit `lua/config/plugins.lua` and add new plugin specifications to the plugins table:

```lua
{
  "author/plugin-name",
  config = function()
    -- Plugin configuration
  end,
}
```

### Adding New Keymaps

Edit `lua/config/keymaps.lua` and add new key mappings:

```lua
keymap("n", "<leader>new", ":SomeCommand<CR>", { desc = "Description" })
```

### Adding New Configuration Modules

1. Create new files in `lua/config/`
2. Require them in `init.lua`:
   ```lua
   require("config.your-new-module")
   ```

## Next Steps for Expansion

Consider adding these features as you become comfortable with the base setup:

- **LSP (Language Server Protocol)** for code intelligence
- **Telescope** for fuzzy finding
- **Treesitter** for better syntax highlighting
- **Git integration** with fugitive or gitsigns
- **Autocompletion** with nvim-cmp
- **Debugging** with nvim-dap
- **Terminal integration** with toggleterm
