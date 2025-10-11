# Terragrunt Language Server (terragrunt-ls)

The Terragrunt Language Server provides IDE features for Terragrunt `.hcl` files, including autocompletion, diagnostics, hover information, and more.

## 📖 Table of Contents

- [Overview](#overview)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Features](#features)
- [Troubleshooting](#troubleshooting)
- [Advanced Configuration](#advanced-configuration)

## Overview

**terragrunt-ls** is a custom-built plugin in Neve that integrates the [Terragrunt Language Server](https://github.com/gruntwork-io/terragrunt-ls) into Neovim.

### Why Use It?

- 🎯 **Auto-completion** for Terragrunt functions and blocks
- 🔍 **Go to definition** for included files and modules
- 📝 **Hover documentation** for Terragrunt syntax
- ⚠️ **Diagnostics** for syntax errors and warnings
- 🔧 **Code actions** for quick fixes

### Implementation Details

This plugin is:
- Built directly from the upstream GitHub repository
- Packaged using Nix's `buildVimPlugin`
- Integrated as a native Nixvim module
- **Automatically kept up-to-date** via GitHub Actions

## Installation

### Prerequisites

You need the `terragrunt-ls` binary installed on your system:

```bash
# Install via your package manager, or download from releases
# https://github.com/gruntwork-io/terragrunt-ls/releases

# Or build from source
git clone https://github.com/gruntwork-io/terragrunt-ls
cd terragrunt-ls
go build -o terragrunt-ls
```

### Using Neve

If you're using Neve, terragrunt-ls is **enabled by default**! Just make sure the binary is in your PATH.

```bash
# Verify it's available
which terragrunt-ls
```

### Standalone Installation

If you want to use this plugin outside of Neve:

```nix
{
  inputs.neve.url = "github:reesilva/neve";
  
  outputs = { neve, nixpkgs, ... }: {
    # Use the module
    programs.nixvim = {
      enable = true;
      imports = [ neve.nixvimModule ];
      
      terragrunt-ls.enable = true;
    };
  };
}
```

## Configuration

### Basic Configuration

The plugin is enabled by default with sensible settings:

```nix
{
  terragrunt-ls = {
    enable = true;
    cmd = [ "terragrunt-ls" ];
    autoAttach = true;
  };
}
```

### Available Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enable` | `bool` | `true` | Enable/disable the plugin |
| `cmd` | `list of strings` | `["terragrunt-ls"]` | Command to start the LSP server |
| `logPath` | `string or null` | `null` | Path to log file (enables logging) |
| `autoAttach` | `bool` | `true` | Auto-attach to HCL files |

### Example Configurations

#### With Logging Enabled

```nix
{
  terragrunt-ls = {
    enable = true;
    logPath = "/tmp/terragrunt-ls.log";
  };
}
```

#### Custom Binary Path

```nix
{
  terragrunt-ls = {
    enable = true;
    cmd = [ "/custom/path/to/terragrunt-ls" ];
  };
}
```

#### Disable Auto-Attach

```nix
{
  terragrunt-ls = {
    enable = true;
    autoAttach = false;  # Manual attachment
  };
}
```

## Usage

### Opening Terragrunt Files

Simply open any `.hcl` file and the LSP will automatically attach:

```bash
nvim terragrunt.hcl
```

### LSP Commands

Once attached, you can use standard LSP commands:

| Command | Keybinding | Description |
|---------|------------|-------------|
| Go to definition | `gd` | Jump to definition |
| Find references | `gr` | Show all references |
| Hover | `K` | Show hover information |
| Rename | `<leader>cr` | Rename symbol |
| Code action | `<leader>ca` | Show code actions |

### Checking Status

To verify the LSP is attached:

```vim
:LspInfo
```

You should see `terragrunt-ls` listed as an active client.

### Viewing Logs

If you enabled logging:

```bash
tail -f /tmp/terragrunt-ls.log
```

## Features

### Supported Language Features

- ✅ **Completion**: Auto-complete for Terragrunt syntax
- ✅ **Hover**: Documentation on hover
- ✅ **Go to Definition**: Navigate to included files
- ✅ **Diagnostics**: Syntax and semantic errors
- ✅ **Document Symbols**: Outline view of file structure
- ⏳ **Formatting**: Coming soon
- ⏳ **Code Actions**: Coming soon

### File Type Support

The LSP automatically activates for:
- `*.hcl` - HCL (HashiCorp Configuration Language) files
- Terragrunt configuration files
- Terraform module references in Terragrunt

## Troubleshooting

### LSP Not Starting

**Problem**: LSP doesn't attach to `.hcl` files

**Solutions**:

1. **Verify binary is installed**:
   ```bash
   which terragrunt-ls
   # Should output the path to the binary
   ```

2. **Check file type**:
   ```vim
   :set filetype?
   # Should show: filetype=hcl
   ```

3. **Check LSP status**:
   ```vim
   :LspInfo
   # Should show terragrunt-ls
   ```

4. **Enable logging**:
   ```nix
   terragrunt-ls.logPath = "/tmp/terragrunt-ls.log";
   ```
   Then check the log for errors.

### Binary Not Found

**Problem**: Error message about `terragrunt-ls` not found

**Solution**: Add the binary to your PATH or specify full path:

```nix
{
  terragrunt-ls.cmd = [ "/usr/local/bin/terragrunt-ls" ];
}
```

### Wrong File Type

**Problem**: HCL files are detected as a different file type

**Solution**: The plugin automatically sets `.hcl` to `hcl` filetype, but you can force it:

```vim
:set filetype=hcl
```

Or add to your config:

```nix
{
  filetype.extension.hcl = "hcl";
}
```

### LSP Crashes

**Problem**: LSP server crashes or doesn't respond

**Solutions**:

1. Check if the binary works standalone:
   ```bash
   terragrunt-ls --version
   ```

2. Enable logging and check for errors:
   ```nix
   terragrunt-ls.logPath = "/tmp/terragrunt-ls.log";
   ```

3. Try restarting the LSP:
   ```vim
   :LspRestart
   ```

### Diagnostics Not Showing

**Problem**: No warnings or errors are displayed

**Check**:

1. LSP is attached (`:LspInfo`)
2. Diagnostics are enabled in your config
3. The file actually has errors to report

## Advanced Configuration

### Custom LSP Settings

You can pass additional configuration to the LSP server:

```nix
{
  extraConfigLua = ''
    -- Additional terragrunt-ls configuration
    local terragrunt_ls = require('terragrunt-ls')
    
    -- Extend the default setup
    terragrunt_ls.setup({
      cmd = { "terragrunt-ls" },
      cmd_env = {
        TG_LS_LOG = "/tmp/terragrunt-ls.log",
      },
      -- Add custom settings here
    })
  '';
}
```

### Integration with Other Tools

#### With conform.nvim (Formatting)

```nix
{
  conform = {
    enable = true;
    formatters_by_ft = {
      hcl = [ "terraform_fmt" ];  # Use terraform fmt for HCL
    };
  };
}
```

#### With null-ls (Linting)

```nix
{
  extraConfigLua = ''
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        null_ls.builtins.diagnostics.tflint.with({
          filetypes = { "hcl", "terraform" },
        }),
      },
    })
  '';
}
```

## Architecture

### How It Works

```
┌─────────────────────────────────────┐
│  Neovim with Neve Configuration    │
├─────────────────────────────────────┤
│  1. Open .hcl file                  │
│  2. Filetype detected as "hcl"      │
│  3. Autocommand triggered           │
│  4. terragrunt-ls LSP starts        │
│  5. LSP client attaches to buffer   │
│  6. IDE features available          │
└─────────────────────────────────────┘
          ↓
┌─────────────────────────────────────┐
│  terragrunt-ls Language Server      │
├─────────────────────────────────────┤
│  - Parses HCL syntax                │
│  - Provides completions             │
│  - Analyzes semantics               │
│  - Returns diagnostics              │
└─────────────────────────────────────┘
```

### Module Structure

```
config/lsp/terragrunt-ls.nix
├── Options Definition
│   ├── enable: bool
│   ├── cmd: list of strings
│   ├── logPath: nullable string
│   └── autoAttach: bool
│
├── Plugin Building
│   └── fetchFromGitHub + buildVimPlugin
│
└── Configuration
    ├── File type detection (.hcl → hcl)
    ├── Lua setup code
    └── Autocommand for auto-attachment
```

## Automated Updates

This plugin is **automatically kept up-to-date** via GitHub Actions!

### How It Works

1. **Daily Check**: Action runs every day at 00:00 UTC
2. **Compare Versions**: Checks upstream for new commits
3. **Calculate Hash**: Generates new Nix hash if update available
4. **Test Build**: Verifies the update works
5. **Create PR**: Opens pull request with changelog

### What This Means

- 🎉 You always get the latest features and fixes
- ✅ Updates are tested before being proposed
- 📝 PRs include detailed information about changes
- 🔒 Hash verification ensures security

See [Automated Updates](Automated-Updates) for more details.

## Contributing

Found a bug or want to improve the integration? Contributions are welcome!

1. Fork the repository
2. Make your changes
3. Test with `nix build .#default`
4. Submit a pull request

See [Contributing](Contributing) for detailed guidelines.

## References

- **Upstream Repository**: [gruntwork-io/terragrunt-ls](https://github.com/gruntwork-io/terragrunt-ls)
- **Module Implementation**: [`config/lsp/terragrunt-ls.nix`](https://github.com/reesilva/neve/blob/main/config/lsp/terragrunt-ls.nix)
- **Setup Guide**: [`TERRAGRUNT-LS-SETUP.md`](https://github.com/reesilva/neve/blob/main/TERRAGRUNT-LS-SETUP.md)
- **Module Documentation**: [`config/lsp/README-terragrunt-ls.md`](https://github.com/reesilva/neve/blob/main/config/lsp/README-terragrunt-ls.md)

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2025-10-11 | Initial implementation with auto-updates |

---

_For more information, see the [Custom Built Plugins](Custom-Built-Plugins) page._
