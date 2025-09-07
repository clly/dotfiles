local M = {
  "mrcjkb/rustaceanvim",
  version = "^4",
  ft = { "rust" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "mfussenegger/nvim-dap",
  },
}

function M.config()
  vim.g.rustaceanvim = {
    -- Plugin configuration
    tools = {
      -- Enable inlay hints
      inlay_hints = {
        auto = true,
        only_current_line = false,
        show_parameter_hints = true,
        parameter_hints_prefix = "<- ",
        other_hints_prefix = "=> ",
        max_len_align = false,
        max_len_align_padding = 1,
        right_align = false,
        right_align_padding = 7,
        highlight = "Comment",
      },
      -- Hover configuration
      hover_actions = {
        border = "rounded",
        max_width = nil,
        max_height = nil,
        auto_focus = false,
      },
      -- Runnables configuration
      runnables = {
        use_telescope = false,
      },
    },
    -- LSP configuration
    server = {
      on_attach = function(client, bufnr)
        -- Set up keymaps
        local opts = { noremap = true, silent = true, buffer = bufnr }
        local keymap = vim.keymap.set

        -- Standard LSP keymaps
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

        -- Rust-specific keymaps
        keymap("n", "<leader>rr", function()
          vim.cmd.RustLsp("runnables")
        end, opts)
        keymap("n", "<leader>rt", function()
          vim.cmd.RustLsp("testables")
        end, opts)
        keymap("n", "<leader>rd", function()
          vim.cmd.RustLsp("debuggables")
        end, opts)
        keymap("n", "<leader>rm", function()
          vim.cmd.RustLsp("expandMacro")
        end, opts)
        keymap("n", "<leader>rc", function()
          vim.cmd.RustLsp("openCargo")
        end, opts)
        keymap("n", "<leader>rp", function()
          vim.cmd.RustLsp("parentModule")
        end, opts)
      end,
      capabilities = vim.lsp.protocol.make_client_capabilities(),
      settings = {
        ["rust-analyzer"] = {
          checkOnSave = {
            command = "cargo clippy",
          },
          cargo = {
            allFeatures = true,
            loadOutDirsFromCheck = true,
            runBuildScripts = true,
          },
          procMacro = {
            enable = true,
            ignored = {
              ["async-trait"] = { "async_trait" },
              ["napi-derive"] = { "napi" },
              ["async-recursion"] = { "async_recursion" },
            },
          },
          inlayHints = {
            bindingModeHints = {
              enable = false,
            },
            chainingHints = {
              enable = true,
            },
            closingBraceHints = {
              enable = true,
              minLines = 25,
            },
            closureReturnTypeHints = {
              enable = "never",
            },
            lifetimeElisionHints = {
              enable = "never",
              useParameterNames = false,
            },
            maxLength = 25,
            parameterHints = {
              enable = true,
            },
            reborrowHints = {
              enable = "never",
            },
            renderColons = true,
            typeHints = {
              enable = true,
              hideClosureInitialization = false,
              hideNamedConstructor = false,
            },
          },
        },
      },
    },
    -- DAP configuration
    dap = {
      adapter = {
        type = "executable",
        command = "lldb-vscode",
        name = "rt_lldb",
      },
    },
  }
end

return M