local M = {
  "mrcjkb/rustaceanvim",
  version = "^4",
  ft = { "rust" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "mfussenegger/nvim-dap",
  },
}

-- Setup Rust-specific keymaps
-- <leader>rr: Run runnables (cargo run, tests, etc.)
-- <leader>rt: Run testables (cargo test targets)
-- <leader>rd: Run debuggables (debug targets)
-- <leader>rm: Expand macro at cursor
-- <leader>rc: Open Cargo.toml
-- <leader>rp: Go to parent module
local function setup_rust_keymaps(bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  local keymap = vim.keymap.set

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
end

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
        -- Set up common LSP keymaps
        local lsp_keymaps = require("lsp.keymaps")
        lsp_keymaps.setup_keymaps(bufnr)

        -- Set up Rust-specific keymaps
        setup_rust_keymaps(bufnr)
      end,
      capabilities = require("lsp.keymaps").get_capabilities(),
      settings = {
        ["rust-analyzer"] = {
          -- Use cargo clippy for enhanced error checking and linting
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
