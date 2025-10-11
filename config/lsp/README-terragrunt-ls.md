# Terragrunt Language Server (terragrunt-ls) Module

This module integrates the [terragrunt-ls](https://github.com/gruntwork-io/terragrunt-ls) language server into your Nixvim configuration.

## Features

- 🚀 **Automatic Plugin Installation**: Fetches and builds the terragrunt-ls plugin from GitHub
- 🔧 **Configurable Setup**: Options for logging and auto-attachment
- 📦 **Native Nixvim Integration**: Works seamlessly with your existing LSP setup
- 🎯 **HCL File Support**: Automatically attaches to `.hcl` files

## Usage

### Basic Configuration

To enable terragrunt-ls in your configuration, add the following to your Nix configuration:

```nix
{
  terragrunt-ls.enable = true;
}
```

### Advanced Configuration

#### Enable Logging

```nix
{
  terragrunt-ls = {
    enable = true;
    logPath = "/tmp/terragrunt-ls.log";
  };
}
```

#### Disable Auto-Attach

If you want to manually control when terragrunt-ls attaches to buffers:

```nix
{
  terragrunt-ls = {
    enable = true;
    autoAttach = false;
  };
}
```

### Complete Example

```nix
{
  terragrunt-ls = {
    enable = true;
    logPath = "/tmp/terragrunt-ls.log";
    autoAttach = true;
  };
}
```

## Module Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `terragrunt-ls.enable` | `bool` | `false` | Enable terragrunt-ls language server |
| `terragrunt-ls.logPath` | `nullOr str` | `null` | Path to log file. Set to enable logging |
| `terragrunt-ls.autoAttach` | `bool` | `true` | Automatically attach to HCL files |

## How It Works

This module:

1. **Fetches the Plugin**: Uses `pkgs.vimUtils.buildVimPlugin` to build terragrunt-ls from GitHub
2. **Adds to extraPlugins**: Includes the plugin in Neovim's runtime path
3. **Configures File Types**: Sets up `.hcl` file type detection
4. **Initializes the LSP**: Calls the `terragrunt-ls.setup()` function with your configuration
5. **Auto-Attaches**: Creates an autocommand to attach the LSP client to HCL files

## Under the Hood

The module creates a custom Neovim plugin package:

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

Then configures it with Lua:

```lua
local terragrunt_ls = require('terragrunt-ls')

terragrunt_ls.setup({
  cmd_env = {
    -- Optional logging configuration
  },
})

-- Auto-attach to HCL files
if terragrunt_ls.client then
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'hcl',
    callback = function()
      vim.lsp.buf_attach_client(0, terragrunt_ls.client)
    end,
  })
end
```

## Updating the Plugin

To update to a newer version of terragrunt-ls:

1. Find the commit SHA or tag you want to use
2. Update the `rev` in `config/lsp/terragrunt-ls.nix`
3. Update the `hash` by running:

```bash
nix-build -E 'with import <nixpkgs> {}; fetchFromGitHub { 
  owner = "gruntwork-io"; 
  repo = "terragrunt-ls"; 
  rev = "YOUR_NEW_REV"; 
  hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; 
}' 2>&1 | grep "got:"
```

4. Replace the hash in the module with the output from step 3

## Troubleshooting

### LSP Not Attaching

Check that:
- The file has the `.hcl` extension
- `autoAttach` is set to `true`
- The terragrunt-ls module is enabled

### Enable Logging

Set `logPath` to debug issues:

```nix
{
  terragrunt-ls = {
    enable = true;
    logPath = "/tmp/terragrunt-ls.log";
  };
}
```

Then check the log file for detailed information.

### Verify Plugin Installation

Run `:checkhealth` in Neovim to see if terragrunt-ls is loaded correctly.

## Related Files

- Module: `config/lsp/terragrunt-ls.nix`
- LSP Configuration: `config/lsp/default.nix`
- Main Configuration: `config/default.nix`

## References

- [terragrunt-ls GitHub Repository](https://github.com/gruntwork-io/terragrunt-ls)
- [Nixvim Documentation](https://nix-community.github.io/nixvim/)
- [Neovim LSP Documentation](https://neovim.io/doc/user/lsp.html)
