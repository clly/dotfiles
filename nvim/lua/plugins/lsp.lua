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
      "rust_analyzer",
      "pyright",
      "tsserver",
      "bashls",
      "jsonls",
      "yamlls",
      "cssls",
      "html",
    },
  })

  -- Setup keymaps for LSP
  local function lsp_keymaps(bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }
    local keymap = vim.keymap.set

    keymap("n", "gD", vim.lsp.buf.declaration, opts)
    keymap("n", "gd", vim.lsp.buf.definition, opts)
    keymap("n", "K", vim.lsp.buf.hover, opts)
    keymap("n", "gi", vim.lsp.buf.implementation, opts)
    keymap("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    keymap("n", "gr", vim.lsp.buf.references, opts)
    keymap("n", "[d", vim.diagnostic.goto_prev, opts)
    keymap("n", "]d", vim.diagnostic.goto_next, opts)
    keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    keymap("n", "<leader>f", function()
      vim.lsp.buf.format({ async = true })
    end, opts)
  end

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
  local servers = require("lsp").servers

  for _, server in pairs(servers) do
    local opts = {
      on_attach = function(client, bufnr)
        lsp_keymaps(bufnr)
      end,
      capabilities = vim.lsp.protocol.make_client_capabilities(),
    }

    -- Load server-specific configuration
    local has_custom_opts, server_custom_opts = pcall(require, "lsp." .. server)
    if has_custom_opts then
      opts = vim.tbl_deep_extend("force", opts, server_custom_opts)
    end

    -- Skip rust_analyzer here as it will be handled by rustaceanvim
    if server ~= "rust_analyzer" then
      lspconfig[server].setup(opts)
    end
  end
end

return M