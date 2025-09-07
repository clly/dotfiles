# Rust Keybindings Cheat Sheet

## LSP Navigation & Information
| Key | Action | Description |
|-----|--------|-------------|
| `gD` | Declaration | Jump to symbol declaration |
| `gd` | Definition | Jump to symbol definition |
| `gi` | Implementation | Jump to symbol implementation |
| `gr` | References | Show all references to symbol |
| `K` | Hover | Show documentation/type info |
| `<C-k>` | Signature Help | Show function signature |

## Diagnostics & Errors
| Key | Action | Description |
|-----|--------|-------------|
| `[d` | Previous Diagnostic | Jump to previous error/warning |
| `]d` | Next Diagnostic | Jump to next error/warning |

## Code Actions & Formatting
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>ca` | Code Action | Show available code actions |
| `<leader>f` | Format | Format current buffer |

## Rust-Specific Features
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>rr` | Runnables | Show/run available runnables (main, tests, examples) |
| `<leader>rt` | Testables | Show/run available tests |
| `<leader>rd` | Debuggables | Show/debug available targets |
| `<leader>rm` | Expand Macro | Expand macro under cursor |
| `<leader>rc` | Open Cargo | Open Cargo.toml file |
| `<leader>rp` | Parent Module | Jump to parent module |

## Automatic Features
- **Inlay Hints**: Type information shown inline
- **Clippy Integration**: Diagnostics from `cargo clippy`
- **Auto-completion**: Context-aware code completion
- **Cargo Integration**: Automatic project detection
- **Proc Macro Support**: Full macro expansion support

## Notes
- `<leader>` is typically the space key
- All LSP features work automatically when rust-analyzer is running
- Inlay hints can be toggled if they become distracting
- Cargo commands run in the background with integrated output