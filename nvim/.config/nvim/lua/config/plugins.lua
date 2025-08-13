-- Plugin Management
-- Using lazy.nvim as plugin manager

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin specifications
local plugins = {
  -- File Explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        view = {
          width = 30,
          side = "left",
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = false,
        },
        git = {
          enable = true,
        },
        actions = {
          open_file = {
            quit_on_open = true,
          },
        },
      })
    end,
  },

  -- Icons
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({
        default = true,
      })
    end,
  },

  -- Colorscheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme tokyonight]])
    end,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight",
        },
      })
    end,
  },
}

-- Setup lazy.nvim
require("lazy").setup(plugins, {
  -- Configuration options
  install = {
    colorscheme = { "tokyonight" },
  },
  checker = {
    enabled = true,
  },
})
