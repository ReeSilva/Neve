# Neve - Developer Handover Document

## 📋 Project Overview

**Neve** (Portuguese for "snow") is a sophisticated Neovim configuration built with Nixvim - a personal fork of [redyf/Neve](https://github.com/redyf/Neve) with custom configurations. This project leverages the Nix ecosystem to provide a reproducible, modular development environment with extensive plugin support and AI-powered features.

**Key Statistics:**
- **Language:** 100% Nix configuration
- **Lines of Code:** 4,451 across 82 files
- **License:** MIT
- **Maintained by:** reesilva

## 🏗️ Architecture Overview

### Core Technologies
- **Nixvim:** Neovim configuration framework using Nix
- **Nix Flakes:** Reproducible development environments
- **GitHub Actions:** CI/CD automation
- **Multiple AI Providers:** Anthropic Claude, Google Gemini, GitHub Copilot

### Modular Structure
```
config/
├── bufferlines/          # Buffer management
├── colorschemes/         # Themes (Catppuccin, Rose Pine, Base16)
├── completion/           # AI-powered completion systems
├── dap/                  # Debug Adapter Protocol
├── filetrees/            # File explorers
├── git/                  # Git integration tools
├── languages/            # Language support & linting
├── lsp/                  # Language Server Protocol
├── sets/                 # Neovim options
├── snippets/             # Code snippets
├── statusline/           # Status bars
├── telescope/            # Fuzzy finder
├── ui/                   # UI enhancements
└── utils/                # Utility plugins
```

## 🚀 Quick Start Guide

### Installation Options

1. **Try before installing:**
   ```bash
   nix run github:reesilva/neve
   ```

2. **Install as Nixvim module:**
   ```nix
   programs.nixvim = {
     enable = true;
     imports = [ inputs.Neve.nixvimModule ];
   };
   ```

3. **Install as package:**
   ```nix
   environment.systemPackages = [ inputs.Neve.packages.${pkgs.system}.default ];
   ```

### Essential Setup Steps

1. **Fork the repository** for customization
2. **Set up API keys** for AI features:
   - `ANTHROPIC_API_KEY` for Claude integration
   - `GEMINI_API_KEY` for Gemini support
3. **Install dependencies:**
   - JetBrainsMono Nerd Font
   - tmux (for session management)
4. **Configure module switches** in `config/default.nix`

## 🔧 Configuration Management

### Module Control System

All features can be toggled via `config/default.nix`:

```nix
{
  bufferlines.enable = lib.mkDefault true;
  colorschemes.enable = lib.mkDefault true;
  completion.enable = lib.mkDefault true;
  dap.enable = lib.mkDefault true;
  # ... customize as needed
}
```

### Key Configuration Files

| File | Purpose |
|------|---------|
| `config/default.nix` | Main module orchestration |
| `config/keys.nix` | Custom keybindings |
| `config/sets/set.nix` | Neovim options & settings |
| `config/lsp/lsp-nvim.nix` | Language server configurations |
| `config/completion/blink.nix` | AI-powered completion setup |

## 🛠️ Development Environment

### Supported Languages & Tools

**Language Servers:**
- **Systems:** C/C++ (clangd), Rust (rust_analyzer), Go (gopls)
- **Web:** TypeScript/JavaScript (ts_ls), ESLint
- **Infrastructure:** Terraform (terraformls), YAML (yamlls)
- **Nix Ecosystem:** nil_ls, nixd
- **Scripting:** Lua (lua_ls), Python (pyright)

**Formatters & Linters:**
- JavaScript/TypeScript: Prettier, ESLint
- Python: Black, Flake8
- Go: goimports, golangci-lint
- Nix: nixfmt, alejandra
- Terraform: terraform_fmt

### AI Integration Features

**Multiple AI Providers:**
- **Avante:** Claude 3.5 Sonnet / Gemini 1.5 Pro for code assistance
- **GitHub Copilot:** Code completion and suggestions
- **Codeium:** Alternative AI completion engine

**AI Capabilities:**
- Code completion and suggestions
- Inline code explanations
- Refactoring assistance
- Documentation generation

## 🎨 User Interface & Themes

### Default Theme: Catppuccin
- **Flavors:** Macchiato (macOS), Mocha (Linux)
- **Features:** Transparent backgrounds, extensive plugin integration
- **Alternative themes:** Rose Pine, Base16 available

### UI Components
- **Welcome Screen:** Alpha dashboard with quick actions
- **Notifications:** Enhanced messaging system (Noice, Notify)
- **File Navigation:** Neo-tree, Oil file manager
- **Fuzzy Finding:** Telescope with extensive pickers
- **Status Line:** Lualine with git integration

## 📋 Development Workflow

### Build & Validation
```bash
# Validate configuration
nix flake check

# Run locally
nix run .

# Format code
nix fmt
```

### CI/CD Pipeline
**Automated on Pull Requests:**
- Nix flake validation with flake-checker
- Code linting with statix
- Formatting with alejandra
- Auto-commit formatting changes

### Git Integration
- **Lazygit:** Terminal UI for git operations
- **Gitsigns:** In-buffer git status indicators
- **Diffview:** Side-by-side diff visualization
- **Neogit:** Magit-inspired git interface

## 🔑 Keybinding Philosophy

### Core Principles
- **Leader Key:** Space (` `)
- **Disabled Arrow Keys:** Enforces hjkl navigation
- **Context-Aware:** Different bindings per mode/context
- **Mnemonic:** Logical key associations

### Essential Bindings
- `<leader>ff` - Find files (Telescope)
- `<leader>fg` - Live grep search
- `<leader>gs` - Git status (Lazygit)
- `<leader>ca` - Code actions
- `gd` - Go to definition
- `K` - Hover documentation

## ⚠️ Critical Areas for New Developers

### Configuration Complexity
1. **Blink Completion Setup:** Multiple source integrations require careful configuration
2. **LSP Configuration:** Language-specific settings may need workflow adjustments
3. **AI Provider Setup:** Requires external API key configuration

### Platform Considerations
- **macOS vs Linux:** Different AI providers and theme flavors
- **Font Dependencies:** JetBrainsMono Nerd Font required for icons
- **External Tools:** tmux, ripgrep, various formatters needed

### Maintenance Areas
- **Commented Code:** Review commented sections in lsp-nvim.nix
- **Version Management:** Keep nixvim and plugin versions updated
- **API Integrations:** Monitor AI service availability and rate limits

## 🔄 Customization Guide

### Adding New Plugins

1. Create plugin configuration in appropriate module directory
2. Add to module's `default.nix` imports
3. Add enable option to main `config/default.nix`
4. Test with `nix flake check` and `nix run`

### Modifying Keybindings

Edit `config/keys.nix`:
```nix
keymaps = [
  {
    mode = "n";
    key = "<leader>custom";
    action = "<cmd>CustomCommand<cr>";
    options.desc = "Custom description";
  }
];
```

### Theme Customization

1. Modify theme settings in `config/colorschemes/`
2. Add custom highlight groups in `config/highlights.nix`
3. Adjust UI component colors in respective config files

## 📚 Resources & Documentation

### Essential Reading
- [Nixvim Documentation](https://nix-community.github.io/nixvim/)
- [Neovim Documentation](https://neovim.io/doc/)
- [Original Neve Project](https://github.com/redyf/Neve)

### Development Resources
- **Issue Tracking:** [GitHub Issues](https://github.com/reesilva/neve/issues)
- **Nix Learning:** [Nix Pills](https://nixos.org/guides/nix-pills/)
- **Neovim Plugins:** [Awesome Neovim](https://github.com/rockerBOO/awesome-neovim)

### Support Channels
- **Project Issues:** Use GitHub issue tracker
- **Nix Community:** [NixOS Discourse](https://discourse.nixos.org/)
- **Neovim Community:** [Neovim Discussions](https://github.com/neovim/neovim/discussions)

## 🚨 Common Issues & Solutions

### Setup Problems
1. **Flake Check Failures:** Usually due to syntax errors or missing dependencies
2. **LSP Not Working:** Check if language servers are properly configured in PATH
3. **AI Features Disabled:** Verify API keys are properly set in environment

### Performance Issues
1. **Slow Startup:** Review enabled plugins in `config/default.nix`
2. **High Memory Usage:** Consider disabling heavy plugins like TreeSitter or completion
3. **Lag in Large Files:** Adjust LSP and completion settings for better performance

### Plugin Conflicts
1. **Completion Sources:** Only one completion engine should be active
2. **Theme Issues:** Ensure only one colorscheme is enabled
3. **Keybinding Conflicts:** Check for duplicate key mappings across modules

## 📈 Future Development Areas

### Planned Enhancements
- Enhanced debugging support with nvim-dap configurations
- Additional language server integrations
- Performance optimizations for large codebases
- Extended AI provider support

### Community Contributions
- Plugin recommendations and configurations
- Language-specific improvements
- Documentation enhancements
- Bug reports and fixes

---

**Last Updated:** 2025-09-27  
**Maintainer:** reesilva  
**Version:** Based on nixvim flake inputs  

*This handover document serves as a comprehensive guide for developers taking over or contributing to the Neve project. Keep this document updated as the project evolves.*