# Terragrunt Language Server Setup Guide

This guide explains how to use the custom Nixvim module for `terragrunt-ls` that has been created for your Neve configuration.

## 🎯 What Was Created

A complete Nixvim module that:
- ✅ Fetches and builds `terragrunt-ls` from GitHub
- ✅ Integrates with your existing LSP setup
- ✅ Provides configurable options for logging and auto-attachment
- ✅ Automatically attaches to HCL files
- ✅ Works like any other built-in Nixvim plugin

## 📁 Files Created

1. **`config/lsp/terragrunt-ls.nix`** - Main module implementation
2. **`config/lsp/README-terragrunt-ls.md`** - Detailed module documentation
3. **`examples/terragrunt-ls-config.nix`** - Example usage configuration
4. **`config/lsp/default.nix`** - Updated to import the new module

## 🚀 Quick Start

### Option 1: Enable in Your Main Configuration

Add to any of your configuration files (e.g., a new `config/lsp/my-lsp-config.nix`):

```nix
{
  terragrunt-ls.enable = true;
}
```

### Option 2: Enable with Logging

```nix
{
  terragrunt-ls = {
    enable = true;
    logPath = "/tmp/terragrunt-ls.log";
  };
}
```

### Option 3: Use the Example Configuration

Copy from `examples/terragrunt-ls-config.nix` or create a new module:

```nix
# config/lsp/my-terragrunt-config.nix
{
  lsp-setup.enable = true;
  
  terragrunt-ls = {
    enable = true;
    autoAttach = true;
  };
}
```

Then import it in `config/lsp/default.nix`.

## 🔧 Module Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `terragrunt-ls.enable` | `bool` | `false` | Enable terragrunt-ls |
| `terragrunt-ls.logPath` | `nullOr str` | `null` | Log file path |
| `terragrunt-ls.autoAttach` | `bool` | `true` | Auto-attach to HCL files |

## 📦 How It Works

The module uses Nix's `buildVimPlugin` to create a proper Neovim plugin from the GitHub repository:

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

Then it's added to `extraPlugins` and configured with Lua, just like any other Nixvim plugin.

## 🎨 Key Features

### 1. Native Nix Integration
- Built entirely with Nix
- No manual plugin management
- Reproducible builds
- Proper dependency tracking

### 2. Nixvim Module System
- Uses standard Nixvim options pattern
- Integrates with your existing LSP setup
- Follows your project's conventions
- Type-safe configuration

### 3. Automatic File Type Handling
- Detects `.hcl` files
- Auto-attaches LSP client
- No manual configuration needed

### 4. Flexible Configuration
- Optional logging
- Configurable auto-attachment
- Easy to extend

## 🔄 Building and Testing

### Build the Configuration

```bash
nix build .#default
```

### Run Your Configuration

```bash
nix run .
```

### Check for Errors

```bash
nix flake check
```

## 🐛 Troubleshooting

### Check if Plugin is Loaded

In Neovim, run:
```vim
:lua print(vim.inspect(require('terragrunt-ls')))
```

### Enable Logging

```nix
{
  terragrunt-ls = {
    enable = true;
    logPath = "/tmp/terragrunt-ls.log";
  };
}
```

Then check `/tmp/terragrunt-ls.log` for details.

### Verify File Type Detection

Open an `.hcl` file and run:
```vim
:set filetype?
```

Should show `filetype=hcl`.

### Check LSP Client Status

```vim
:LspInfo
```

Should show terragrunt-ls attached to HCL buffers.

## 🔄 Updating the Plugin

### Automatic Updates (Recommended)

The terragrunt-ls plugin is automatically kept up-to-date via a GitHub Action that:
- Runs daily to check for new commits
- Automatically calculates the correct Nix hash
- Tests the build to ensure it works
- Creates a pull request with detailed information

You don't need to do anything! Just review and merge the automated PRs when they appear.

See [`.github/workflows/update-plugins.yml`](.github/workflows/update-plugins.yml) for the workflow details.

### Manual Update (If Needed)

To manually update to a newer version:

1. Find the commit/tag you want
2. Edit `config/lsp/terragrunt-ls.nix`
3. Update the `rev` field
4. Get the new hash:

```bash
nix-build -E 'with import <nixpkgs> {}; fetchFromGitHub { 
  owner = "gruntwork-io"; 
  repo = "terragrunt-ls"; 
  rev = "NEW_REV_HERE"; 
  hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; 
}' 2>&1 | grep "got:"
```

5. Update the `hash` field with the output
6. Test with `nix build .#default`

## 📚 Additional Resources

- **Module Documentation**: `config/lsp/README-terragrunt-ls.md`
- **Example Config**: `examples/terragrunt-ls-config.nix`
- **Upstream Repo**: https://github.com/gruntwork-io/terragrunt-ls
- **Nixvim Docs**: https://nix-community.github.io/nixvim/

## 🎓 Learning Points

This implementation demonstrates several Nix/Nixvim patterns:

1. **Building Vim Plugins from Source**
   ```nix
   pkgs.vimUtils.buildVimPlugin { ... }
   ```

2. **Using `extraPlugins`**
   - For plugins not in nixpkgs
   - Custom or upstream plugins
   - Full control over plugin source

3. **Module Options Pattern**
   ```nix
   options = {
     myModule.enable = lib.mkEnableOption "...";
     myModule.option = lib.mkOption { ... };
   };
   ```

4. **Conditional Configuration**
   ```nix
   config = lib.mkIf config.myModule.enable { ... };
   ```

5. **Lua Configuration Integration**
   ```nix
   extraConfigLua = ''
     require('plugin').setup({ ... })
   '';
   ```

## 🤝 Contributing

To extend this module:

1. Edit `config/lsp/terragrunt-ls.nix`
2. Add new options in the `options` section
3. Use them in the `config` section
4. Update documentation
5. Test with `nix build`

## ✅ Summary

You now have a fully functional, reproducible Nixvim module for terragrunt-ls that:
- Builds from source
- Integrates cleanly with your existing setup
- Follows Nix and Nixvim best practices
- Can be easily extended and maintained
- Works like any other Nixvim plugin

Just enable it in your configuration and start editing Terragrunt files! 🚀
