# Custom Built Plugins

Neve includes some plugins that are built directly from source rather than using pre-packaged versions from nixpkgs. This allows us to use the latest features and plugins that aren't yet available in the official repository.

## 📖 Table of Contents

- [Overview](#overview)
- [Available Plugins](#available-plugins)
- [How It Works](#how-it-works)
- [Benefits](#benefits)
- [Automated Maintenance](#automated-maintenance)
- [Adding New Plugins](#adding-new-plugins)

## Overview

Custom-built plugins in Neve are:

- 📦 **Built from source** using `pkgs.vimUtils.buildVimPlugin`
- 🔒 **Hash-verified** for security and reproducibility
- 🔄 **Auto-updated** via GitHub Actions
- 🎯 **Integrated natively** as Nixvim modules
- ✅ **Tested automatically** before updates

### Why Build Custom Plugins?

1. **Not in nixpkgs**: Some plugins aren't available in the official repository
2. **Latest features**: Get cutting-edge features before official packaging
3. **Specific versions**: Pin to exact commits for stability
4. **Custom patches**: Apply patches or modifications if needed
5. **Upstream synchronization**: Stay synchronized with upstream development

## Available Plugins

### Terragrunt Language Server (terragrunt-ls)

**Status**: ✅ Active | **Auto-Update**: ✅ Enabled

Language server for Terragrunt HCL files providing IDE features.

- **Upstream**: [gruntwork-io/terragrunt-ls](https://github.com/gruntwork-io/terragrunt-ls)
- **Documentation**: [Terragrunt-LS Wiki Page](Terragrunt-LS)
- **Module**: `config/lsp/terragrunt-ls.nix`

**Features**:
- Auto-completion for Terragrunt syntax
- Go to definition for included files
- Hover documentation
- Diagnostics and error checking
- Auto-attaches to `.hcl` files

**Usage**:
```nix
{
  terragrunt-ls.enable = true;
}
```

See the [Terragrunt-LS](Terragrunt-LS) page for full documentation.

## How It Works

### Build Process

#### 1. Source Fetching

Plugins are fetched from GitHub using `fetchFromGitHub`:

```nix
src = pkgs.fetchFromGitHub {
  owner = "username";
  repo = "plugin-name";
  rev = "commit-sha-or-tag";
  hash = "sha256-...";
};
```

**Key Points**:
- `rev`: Specific commit, tag, or branch
- `hash`: SHA256 hash for verification
- Ensures reproducibility and security

#### 2. Plugin Building

The source is built into a Neovim plugin:

```nix
my-plugin = pkgs.vimUtils.buildVimPlugin {
  name = "my-plugin";
  src = pkgs.fetchFromGitHub { ... };
};
```

**What happens**:
- Source is downloaded and verified
- Plugin structure is validated
- Runtime paths are set up
- Plugin becomes available via `require('plugin-name')`

#### 3. Module Integration

The plugin is integrated as a Nixvim module:

```nix
{
  options = {
    my-plugin.enable = lib.mkEnableOption "...";
    my-plugin.option = lib.mkOption { ... };
  };
  
  config = lib.mkIf config.my-plugin.enable {
    extraPlugins = [ my-plugin ];
    extraConfigLua = ''
      require('my-plugin').setup({ ... })
    '';
  };
}
```

**Benefits**:
- Type-safe configuration
- Enable/disable easily
- Follows Nix module patterns
- Integration with other modules

### Example: Complete Plugin Definition

```nix
{
  lib,
  config,
  pkgs,
  ...
}:
let
  # Build the plugin
  my-awesome-plugin = pkgs.vimUtils.buildVimPlugin {
    name = "my-awesome-plugin";
    src = pkgs.fetchFromGitHub {
      owner = "awesome-dev";
      repo = "my-awesome-plugin";
      rev = "v1.0.0";
      hash = "sha256-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX=";
    };
  };
in
{
  # Define options
  options = {
    my-awesome-plugin.enable = lib.mkEnableOption "Enable my awesome plugin";
    
    my-awesome-plugin.setting = lib.mkOption {
      type = lib.types.str;
      default = "default-value";
      description = "A configuration setting";
    };
  };

  # Configure when enabled
  config = lib.mkIf config.my-awesome-plugin.enable {
    extraPlugins = [ my-awesome-plugin ];
    
    extraConfigLua = ''
      require('my-awesome-plugin').setup({
        setting = "${config.my-awesome-plugin.setting}",
      })
    '';
  };
}
```

## Benefits

### 1. Always Up-to-Date

Automated updates ensure you get:
- 🆕 Latest features
- 🐛 Bug fixes
- 🔒 Security patches
- ⚡ Performance improvements

### 2. Reproducible Builds

Nix ensures:
- Same build on any machine
- Hash verification prevents tampering
- Exact version control
- No "works on my machine" issues

### 3. Type Safety

Nixvim modules provide:
- Compile-time type checking
- Option validation
- Default values
- Documentation generation

### 4. Easy Management

Simple enable/disable:
```nix
{
  my-plugin.enable = false;  # Disable
  my-plugin.enable = true;   # Enable
}
```

### 5. Integration

Works seamlessly with:
- Other Nixvim plugins
- LSP configurations
- Keybindings
- Autocommands

## Automated Maintenance

### GitHub Actions Workflow

All custom plugins are automatically maintained via GitHub Actions.

**Schedule**: Daily at 00:00 UTC

**Process**:
1. ✅ Check upstream for new commits
2. ✅ Calculate new Nix hash if updated
3. ✅ Test build to ensure it works
4. ✅ Create pull request with details
5. ✅ Label as `dependencies`, `automated`, `plugins`

**What You Get**:
- Automatic PRs with changelog
- Build verification before merging
- Detailed commit information
- No manual hash calculation needed

### Example Pull Request

When an update is found, you'll receive a PR like:

```markdown
🤖 Update my-plugin to abc1234

## Automated Plugin Update

### Changes
- Plugin: my-plugin
- New Commit: abc1234
- Commit Message: Add new feature X
- Commit Date: 2025-10-11T12:00:00Z
- New Hash: sha256-...

### Verification
✅ Flake build tested successfully
✅ Hash verified
✅ Code formatted with alejandra
```

See [Automated Updates](Automated-Updates) for more details.

## Adding New Plugins

Want to add a new custom plugin? Here's how:

### Step 1: Create the Module

Create a new file in `config/lsp/` (or appropriate directory):

```nix
# config/lsp/my-new-plugin.nix
{
  lib,
  config,
  pkgs,
  ...
}:
let
  my-new-plugin = pkgs.vimUtils.buildVimPlugin {
    name = "my-new-plugin";
    src = pkgs.fetchFromGitHub {
      owner = "github-user";
      repo = "my-new-plugin";
      rev = "main";  # or specific commit/tag
      hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    };
  };
in
{
  options = {
    my-new-plugin.enable = lib.mkEnableOption "Enable my new plugin";
  };

  config = lib.mkIf config.my-new-plugin.enable {
    extraPlugins = [ my-new-plugin ];
    
    extraConfigLua = ''
      require('my-new-plugin').setup({})
    '';
  };
}
```

### Step 2: Calculate the Hash

```bash
nix-build -E 'with import <nixpkgs> {}; fetchFromGitHub { 
  owner = "github-user"; 
  repo = "my-new-plugin"; 
  rev = "main"; 
  hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; 
}' 2>&1 | grep "got:"
```

Copy the hash from the error output and update your module.

### Step 3: Import the Module

Add to `config/lsp/default.nix` (or appropriate default.nix):

```nix
{
  imports = [
    ./my-new-plugin.nix
    # ... other imports
  ];
  
  config = lib.mkIf config.lsp-setup.enable {
    my-new-plugin.enable = lib.mkDefault false;
  };
}
```

### Step 4: Test the Build

```bash
nix build .#default
```

### Step 5: Add Auto-Update (Optional)

Add a new job to `.github/workflows/update-plugins.yml`:

```yaml
update-my-new-plugin:
  runs-on: ubuntu-latest
  permissions:
    contents: write
    pull-requests: write
  steps:
    # Copy and modify steps from existing plugin jobs
    # Update repository owner, name, and file paths
```

### Step 6: Document

Add documentation:
- Wiki page describing the plugin
- Entry in this page's "Available Plugins" section
- Usage examples
- Configuration options

See the [Adding Custom Plugins](Adding-Custom-Plugins) guide for detailed instructions.

## Best Practices

### Version Pinning

**Recommended**: Pin to specific commits or tags

```nix
rev = "v1.2.3";  # Good: Specific tag
rev = "abc123..."; # Good: Specific commit

rev = "main";      # Risky: Moving target
```

**Why?**: Reproducibility and stability

### Hash Updates

**Always verify** new hashes:

```bash
# Get the correct hash
nix-build -E '...' 2>&1 | grep "got:"

# Test the build
nix build .#default
```

### Module Options

**Provide sensible defaults**:

```nix
options = {
  my-plugin.enable = lib.mkEnableOption "...";
  
  my-plugin.setting = lib.mkOption {
    type = lib.types.str;
    default = "sensible-default";  # Good
    description = "Clear description";
  };
};
```

### Documentation

**Document everything**:
- Purpose of the plugin
- Configuration options
- Usage examples
- Known issues
- Links to upstream

## Troubleshooting

### Build Fails

**Problem**: Plugin doesn't build

**Check**:
1. Hash is correct
2. Repository is public and accessible
3. Rev exists in the repository
4. Plugin has valid structure

**Solution**:
```bash
# Verify hash
nix-build -E 'with import <nixpkgs> {}; fetchFromGitHub { ... }'

# Test build
nix build .#default --show-trace
```

### Plugin Not Loading

**Problem**: Plugin enabled but not working

**Check**:
1. Is it in `extraPlugins`?
2. Is the Lua setup code correct?
3. Are there any Neovim errors? (`:messages`)
4. Is the plugin compatible with your Neovim version?

**Solution**:
```vim
" Check if plugin is loaded
:lua print(vim.inspect(package.loaded['plugin-name']))

" Check for errors
:messages
```

### Hash Mismatch

**Problem**: Build fails with hash mismatch

**Solution**: Update with the correct hash from error message:

```
error: hash mismatch in fixed-output derivation
  specified: sha256-OLD_HASH
  got:        sha256-NEW_HASH  # Use this one
```

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────┐
│                    Neve Configuration                    │
└─────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────┐
│              Custom Plugin Module                        │
│  ┌───────────────────────────────────────────────────┐  │
│  │  options:                                         │  │
│  │  - my-plugin.enable                               │  │
│  │  - my-plugin.option1                              │  │
│  └───────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────┐
│              pkgs.vimUtils.buildVimPlugin                │
│  ┌───────────────────────────────────────────────────┐  │
│  │  fetchFromGitHub                                  │  │
│  │  - owner, repo, rev, hash                         │  │
│  └───────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────┐
│                 Built Neovim Package                     │
│  - Plugin in runtimepath                                 │
│  - Lua module available                                  │
│  - Configuration applied                                 │
└─────────────────────────────────────────────────────────┘
```

## Resources

- [Nixpkgs Manual - Vim](https://nixos.org/manual/nixpkgs/stable/#vim)
- [Nixvim Documentation](https://nix-community.github.io/nixvim/)
- [Build Process](Build-Process)
- [Adding Custom Plugins](Adding-Custom-Plugins)
- [Automated Updates](Automated-Updates)

## Contributing

Want to add more custom plugins? We welcome contributions!

See [Contributing](Contributing) for guidelines on:
- Plugin selection criteria
- Module structure requirements
- Documentation standards
- Testing procedures

---

_For specific plugin documentation, see their individual wiki pages._
