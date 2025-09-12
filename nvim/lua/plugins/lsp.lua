local M = {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    {
      "williamboman/mason.nvim",
      build = ":MasonUpdate",
    },
    "williamboman/mason-lspconfig.nvim",
  },
}

function M.config()
  -- LSP configuration with Mason integration
  -- Note: rust_analyzer is excluded here as it's handled by rustaceanvim plugin
  -- for enhanced Rust development experience
  local mason = require("mason")
  local mason_lspconfig = require("mason-lspconfig")
  local lspconfig = require("lspconfig")

  mason.setup({
    ui = {
      border = "rounded",
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  })

  mason_lspconfig.setup({
    ensure_installed = {
      "lua_ls",
      -- rust_analyzer excluded as it's handled by rustaceanvim plugin
      "pyright",
      "tsserver",
      "bashls",
      "jsonls",
      "yamlls",
      "cssls",
      "html",
    },
  })

  -- Import shared LSP keymaps and utilities
  local lsp_keymaps = require("lsp.keymaps")

  -- Configure diagnostics
  vim.diagnostic.config({
    virtual_text = {
      prefix = "●",
    },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  })

  -- LSP handlers
  local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })

  -- Setup servers
  local lsp = require("lsp")
  local servers = lsp.servers

  for _, server in pairs(servers) do
    local opts = {
      on_attach = function(client, bufnr)
        lsp_keymaps.setup_keymaps(bufnr)
      end,
      capabilities = lsp_keymaps.get_capabilities(),
    }

    -- Load server-specific configuration
    local has_custom_opts, server_custom_opts = pcall(require, "lsp." .. server)
    if has_custom_opts and type(server_custom_opts) == "table" then
      opts = vim.tbl_deep_extend("force", opts, server_custom_opts)
    end

    -- Skip rust_analyzer here as it will be handled by rustaceanvim
    if server ~= "rust_analyzer" then
      lspconfig[server].setup(opts)
    end
  end
end

return M
