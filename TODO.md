# Migration from devbox to mise-en-place - TODOs

## Tools Status

### ✅ Available in mise registry
- `helix` - Available via `aqua:helix-editor/helix ubi:helix-editor/helix`
- `ripgrep` - Available via `aqua:BurntSushi/ripgrep ubi:BurntSushi/ripgrep[exe=rg]`  
- `gh` - Available via `aqua:cli/cli ubi:cli/cli[exe=gh]`
- `go` - Available via `core:go`

### ❌ Not available in mise registry
- `bash` - System bash is sufficient, no version management needed
- `skopeo` - **NEEDS ALTERNATIVE INSTALLATION METHOD**

## TODO: Alternative installation methods for skopeo

### Option 1: System Package Manager
Install via system package manager and document in setup scripts:
- Ubuntu/Debian: `apt install skopeo`
- Fedora/RHEL: `dnf install skopeo` 
- Arch: `pacman -S skopeo`

### Option 2: Manual Binary Installation
Download pre-built binaries from GitHub releases and install to `~/.local/bin`

### Option 3: Container-based approach  
Use skopeo via container image from quay.io with alias/wrapper script

### Option 4: Build from source
Clone and build skopeo from source, though this adds complexity

### Option 5: Check for third-party mise plugins
Search for community-maintained mise plugins that might support skopeo

## Decision needed
Determine which approach works best for the dotfiles setup and document the installation method.