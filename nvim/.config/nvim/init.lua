-- Basic Neovim IDE Configuration
-- Author: Claude
-- Description: Extensible Neovim config with file explorer and editor panes

-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 50

-- Leader key
vim.g.mapleader = " "

-- Load configuration modules
require("config.plugins")
require("config.keymaps")

-- Load custom plugins
require("plugins.rust-keybindings-modal")
