# Neve Build Process & Workflow Documentation

This document explains how Neve is built, how the Nix flake works, and the development workflow for maintaining and extending the configuration.

## Table of Contents

- [Overview](#overview)
- [Flake Structure](#flake-structure)
- [Build Process](#build-process)
- [Module System](#module-system)
- [Custom Plugin Building](#custom-plugin-building)
- [Development Workflow](#development-workflow)
- [Testing](#testing)
- [Automated Maintenance](#automated-maintenance)
- [Troubleshooting](#troubleshooting)

## Overview

Neve is a Nix flake that builds a custom Neovim configuration using [Nixvim](https://github.com/nix-community/nixvim). The build process:

1. Imports modular configuration from `./config`
2. Uses Nixvim's `makeNixvimWithModule` to build Neovim
3. Produces a wrapped Neovim executable with all plugins and settings
4. Optionally runs tests to verify configuration integrity

## Flake Structure

### Inputs

```nix
inputs = {
  nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  nixpkgs-master.url = "github:nixos/nixpkgs/master";
  nixvim.url = "github:nix-community/nixvim";
  flake-utils.url = "github:numtide/flake-utils";
  mcphub-nvim = {
    url = "github:ravitemer/mcphub.nvim";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  mcp-hub = {
    url = "github:ravitemer/mcp-hub";
    inputs.nixpkgs.follows = "nixpkgs";
  };
};
```

**Input Descriptions:**

- **nixpkgs** - Unstable channel for latest packages
- **nixpkgs-master** - Master branch for cutting-edge packages
- **nixvim** - Nix modules for Neovim configuration
- **flake-utils** - Helper functions for multi-system builds
- **mcphub-nvim** - MCP (Model Context Protocol) integration for Neovim
- **mcp-hub** - MCP hub implementation

**Input Follows:**
The `inputs.nixpkgs.follows = "nixpkgs"` pattern ensures all dependencies use the same nixpkgs version, preventing version conflicts.

### Outputs

The flake produces outputs for each default system (x86_64-linux, aarch64-linux, x86_64-darwin, aarch64-darwin):

```nix
outputs = {
  nixvimModule = config;              # Reusable Nixvim module
  packages.${system}.default = nvim;  # Neovim executable
  checks.${system}.default = test;    # Configuration test
  formatter.${system} = nixfmt;       # Code formatter
};
```

## Build Process

### Step-by-Step Build Flow

#### 1. Configuration Import

```nix
config = import ./config;
```

Imports the main configuration module from `config/default.nix`, which recursively imports all sub-modules.

#### 2. System-Specific Setup

```nix
flake-utils.lib.eachDefaultSystem (system: { ... })
```

Evaluates the configuration for each supported system architecture.

#### 3. Package Instantiation

```nix
pkgs = import inputs.nixpkgs {
  inherit system;
  config = { allowUnfree = true; };
};
```

Creates a package set with:
- Specified system architecture
- Unfree packages enabled (for proprietary plugins/tools)

#### 4. Nixvim Library Creation

```nix
nixvimLib = nixvim.lib.${system};
nixvim' = nixvim.legacyPackages.${system};
```

Instantiates Nixvim's library and package functions for the target system.

#### 5. Neovim Build

```nix
nvim = nixvim'.makeNixvimWithModule {
  inherit pkgs;
  module = config;
  extraSpecialArgs = {
    inherit self mcphub-nvim mcp-hub pkgs-master;
  };
};
```

**What happens here:**

- **pkgs**: Provides access to all Nix packages
- **module**: The configuration tree from `./config`
- **extraSpecialArgs**: Additional arguments passed to all modules:
  - `self`: Reference to this flake (for accessing outputs)
  - `mcphub-nvim`: MCP Neovim plugin integration
  - `mcp-hub`: MCP hub functionality
  - `pkgs-master`: Access to master branch packages

**Build Steps:**

1. Evaluates all Nix modules and options
2. Resolves plugin dependencies
3. Builds custom plugins from source (if any)
4. Generates Lua configuration files
5. Creates init.lua from all extraConfigLua blocks
6. Wraps Neovim with all plugins and configuration
7. Sets up runtime paths and environment

#### 6. Output Generation

```nix
packages.default = nvim;
```

Creates the final Neovim executable with all configurations applied.

### Build Commands

```bash
# Build the configuration
nix build .#default

# Run without installing
nix run .#default

# Install to profile
nix profile install .#default

# Build for specific system
nix build .#packages.x86_64-linux.default
```

## Module System

### Configuration Tree

```
config/
├── default.nix           # Main entry point, imports all modules
├── bufferlines/          # Buffer line plugins
├── colorschemes/         # Color schemes
├── completion/           # Completion engines (cmp, copilot, etc.)
├── dap/                  # Debug Adapter Protocol
├── filetrees/            # File explorers (neo-tree, etc.)
├── git/                  # Git integration (lazygit, gitsigns)
├── highlights.nix        # Syntax highlighting
├── keys.nix              # Key mappings
├── languages/            # Language-specific configs
├── lsp/                  # Language Server Protocol
│   ├── default.nix
│   ├── lsp-nvim.nix
│   ├── terragrunt-ls.nix # Custom plugin module
│   └── ...
├── sets/                 # Neovim options
├── snippets/             # Code snippets
├── statusline/           # Status line plugins
├── telescope/            # Fuzzy finder
├── ui/                   # UI enhancements
└── utils/                # Utility plugins
```

### Module Pattern

Each module follows this structure:

```nix
{ lib, config, pkgs, ... }:
{
  options = {
    myModule.enable = lib.mkEnableOption "Enable my module";
    myModule.option = lib.mkOption {
      type = lib.types.str;
      default = "value";
      description = "An option";
    };
  };

  config = lib.mkIf config.myModule.enable {
    # Configuration when enabled
  };
}
```

### Module Evaluation Order

1. **Import Phase**: All modules are imported
2. **Option Declaration**: All `options` are declared
3. **Config Merge**: All `config` blocks are merged
4. **Evaluation**: Options are evaluated with their final values
5. **Generation**: Configuration files are generated

## Custom Plugin Building

### Why Build Custom Plugins?

Some plugins aren't available in nixpkgs or need specific versions. Neve builds these from source.

### Plugin Build Pattern

```nix
let
  my-plugin = pkgs.vimUtils.buildVimPlugin {
    name = "my-plugin";
    src = pkgs.fetchFromGitHub {
      owner = "user";
      repo = "my-plugin";
      rev = "commit-sha";
      hash = "sha256-...";
    };
  };
in
{
  extraPlugins = [ my-plugin ];
}
```

### Example: terragrunt-ls

```nix
terragrunt-ls-plugin = pkgs.vimUtils.buildVimPlugin {
  name = "terragrunt-ls";
  src = pkgs.fetchFromGitHub {
    owner = "gruntwork-io";
    repo = "terragrunt-ls";
    rev = "main";
    hash = "sha256-Ni9TccTLbixtczJvKDUJqgGwFCj9TRNX0zp6421BaYY=";
  };
};
```

**Build Steps:**

1. `fetchFromGitHub` downloads the source
2. Hash verification ensures integrity
3. `buildVimPlugin` creates a plugin package
4. Plugin is added to Neovim's runtimepath
5. Lua module becomes available via `require('plugin-name')`

### Hash Calculation

```bash
nix-build -E 'with import <nixpkgs> {}; fetchFromGitHub { 
  owner = "user"; 
  repo = "repo"; 
  rev = "commit-sha"; 
  hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; 
}' 2>&1 | grep "got:"
```

Copy the hash from the error message.

## Development Workflow

### Making Changes

#### 1. Edit Configuration

```bash
# Edit a module
vim config/lsp/lsp-nvim.nix

# Add a new plugin
vim config/lsp/my-new-plugin.nix
```

#### 2. Test Changes

```bash
# Quick test
nix run .

# Full build
nix build .#default
```

#### 3. Format Code

```bash
# Format all Nix files
nix fmt

# Or use alejandra directly
alejandra .
```

#### 4. Check Flake

```bash
# Verify configuration
nix flake check

# Show flake info
nix flake show
```

### Adding a New Plugin

#### Method 1: From nixpkgs

```nix
# If the plugin is in nixpkgs
extraPlugins = [ pkgs.vimPlugins.my-plugin ];

# Configure it
extraConfigLua = ''
  require('my-plugin').setup({})
'';
```

#### Method 2: Build from Source

1. Create a new module file
2. Use `buildVimPlugin` pattern
3. Add to `extraPlugins`
4. Configure via `extraConfigLua`

See `config/lsp/terragrunt-ls.nix` for a complete example.

### Module Organization

**Best Practices:**

1. **One concern per module** - Each module should handle one plugin or feature
2. **Use default.nix** - Each directory should have a default.nix that imports sub-modules
3. **Enable by default** - Use `lib.mkDefault true` for sensible defaults
4. **Document options** - Add descriptions to all options
5. **Group related plugins** - Keep related functionality together

### Updating Dependencies

```bash
# Update all inputs
nix flake update

# Update specific input
nix flake lock --update-input nixvim

# Check outdated inputs
nix flake metadata
```

## Testing

### Test Types

#### 1. Build Test

```bash
nix build .#default
```

Verifies the configuration evaluates and builds successfully.

#### 2. Flake Check

```bash
nix flake check
```

Runs `mkTestDerivationFromNvim` which:
- Builds the configuration
- Starts Neovim
- Executes basic sanity checks
- Verifies plugins load correctly

#### 3. Manual Testing

```bash
# Run without installing
nix run .

# Test with specific files
nix run . -- test.lua
nix run . -- test.hcl  # Test terragrunt-ls
```

### Test Configuration

The test is defined in the flake:

```nix
checks.default = nixvimLib.check.mkTestDerivationFromNvim {
  inherit nvim;
  name = "Neve";
};
```

### Debugging Build Issues

```bash
# Show detailed trace
nix build .#default --show-trace

# Keep build directory on failure
nix build .#default --keep-failed

# Verbose output
nix build .#default -L
```

## Automated Maintenance

### GitHub Actions Workflows

#### 1. Nix Flake Check (update.yml)

**Trigger:** Pull requests

**Actions:**
- Install Nix and tools
- Update flake inputs
- Lint with statix
- Format with alejandra
- Run flake-checker
- Auto-commit changes

#### 2. Update Custom Plugins (update-plugins.yml)

**Trigger:** Daily at 00:00 UTC, manual

**Actions:**
- Check upstream for updates
- Calculate new hashes
- Update module files
- Test build
- Create pull request

**Monitored Plugins:**
- terragrunt-ls

### Manual Workflow Trigger

```bash
# Via GitHub CLI
gh workflow run update-plugins.yml

# Via web UI
# Actions → Update Custom Plugins → Run workflow
```

### Adding Plugins to Auto-Update

1. Create plugin module with `fetchFromGitHub`
2. Copy the update job in `update-plugins.yml`
3. Modify repository owner/name
4. Update file paths
5. Test with manual trigger

## Troubleshooting

### Common Issues

#### Build Failures

**Error:** Module not found

```nix
error: path '/nix/store/...' does not exist
```

**Solution:** Add file to git:
```bash
git add config/path/to/file.nix
```

**Error:** Hash mismatch

```
error: hash mismatch in fixed-output derivation
  specified: sha256-...
  got:        sha256-...
```

**Solution:** Update the hash with the "got" value.

#### Plugin Issues

**Error:** Plugin doesn't load

**Check:**
1. Is the plugin in `extraPlugins`?
2. Is the module enabled?
3. Is there a setup call in `extraConfigLua`?
4. Check `:messages` in Neovim for errors

#### LSP Issues

**Error:** Language server not starting

**Check:**
1. Is the LSP server installed?
2. Is it in PATH?
3. Is the file type detected correctly? (`:set filetype?`)
4. Check `:LspInfo` for status

### Debug Commands

```bash
# Show all derivations
nix show-derivation .#default

# Evaluate expression
nix eval .#default.meta.mainProgram

# Show build log
nix log .#default

# Start debug repl
nix repl
> :lf .
> :p packages.x86_64-linux.default
```

### Getting Help

1. Check [Nixvim documentation](https://nix-community.github.io/nixvim/)
2. Read [Nix manual](https://nixos.org/manual/nix/stable/)
3. Search [Nixvim issues](https://github.com/nix-community/nixvim/issues)
4. Open issue on [Neve repository](https://github.com/reesilva/neve/issues)

## Performance Optimization

### Build Performance

**Use Binary Cache:**

```bash
# Use cachix for nixvim
cachix use nix-community
```

**Parallel Builds:**

```nix
# In nix.conf or via --option
max-jobs = 8
cores = 4
```

### Runtime Performance

**Lazy Loading:**

Enable lazy loading for heavy plugins:

```nix
plugins.plugin-name = {
  enable = true;
  lazyLoad = {
    settings = {
      event = "VeryLazy";
      # or
      cmd = "PluginCommand";
      # or
      ft = "filetype";
    };
  };
};
```

**Startup Time:**

Check startup time:

```bash
nix run . -- --startuptime startup.log
```

## Advanced Topics

### Cross-Compilation

Build for different systems:

```bash
# Build for macOS on Linux
nix build .#packages.aarch64-darwin.default

# Build for Linux ARM
nix build .#packages.aarch64-linux.default
```

### Using as a Library

Import Neve in your own flake:

```nix
{
  inputs.neve.url = "github:reesilva/neve";
  
  outputs = { nixpkgs, neve, ... }: {
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      modules = [
        {
          programs.nixvim = {
            enable = true;
            imports = [ neve.nixvimModule ];
          };
        }
      ];
    };
  };
}
```

### Custom Derivation

Access the Neovim derivation:

```nix
let
  myNeovim = inputs.neve.packages.${system}.default;
in
{
  environment.systemPackages = [ myNeovim ];
}
```

## References

- [Nix Flakes](https://nixos.wiki/wiki/Flakes)
- [Nixvim](https://github.com/nix-community/nixvim)
- [Neovim Docs](https://neovim.io/doc/)
- [Nix Pills](https://nixos.org/guides/nix-pills/)
- [Nixpkgs Manual](https://nixos.org/manual/nixpkgs/stable/)

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on:
- Code style
- Module patterns
- Testing requirements
- Pull request process
