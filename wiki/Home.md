# Neve Wiki

Welcome to the Neve wiki! This documentation covers configuration, custom plugins, and advanced usage of this Nixvim-based Neovim configuration.

## 📚 Contents

### Getting Started
- [Installation](Installation)
- [Quick Start](Quick-Start)
- [Configuration Guide](Configuration-Guide)

### Features
- [Custom Built Plugins](Custom-Built-Plugins)
- [LSP Configuration](LSP-Configuration)
- [Plugin Management](Plugin-Management)

### Custom Plugins
- [Terragrunt Language Server](Terragrunt-LS)
- [Adding New Custom Plugins](Adding-Custom-Plugins)

### Development
- [Build Process](Build-Process)
- [Contributing](Contributing)
- [Testing](Testing)

### Maintenance
- [Automated Updates](Automated-Updates)
- [Updating Dependencies](Updating-Dependencies)

## 🚀 Quick Links

- **Main Repository**: [reesilva/neve](https://github.com/reesilva/neve)
- **Original Project**: [redyf/Neve](https://github.com/redyf/Neve)
- **Nixvim Documentation**: [nix-community/nixvim](https://nix-community.github.io/nixvim/)
- **Issue Tracker**: [Report Issues](https://github.com/reesilva/neve/issues)

## 🎯 What's Special About Neve?

Neve is a meticulously crafted Neovim configuration built with Nix that offers:

- **Reproducible Configuration**: Everything is defined in Nix, ensuring consistency across systems
- **Custom Plugin Building**: Some plugins are built directly from source, not available in nixpkgs
- **Modular Design**: Easy to enable/disable features and plugins
- **Automated Maintenance**: GitHub Actions keep custom plugins up-to-date automatically
- **Type-Safe Configuration**: Nix's type system prevents configuration errors

## 📦 Custom Built Plugins

Neve includes plugins that are built from source and not available in nixpkgs:

| Plugin | Description | Status |
|--------|-------------|--------|
| [terragrunt-ls](Terragrunt-LS) | Language Server for Terragrunt | ✅ Active |

See the [Custom Built Plugins](Custom-Built-Plugins) page for more details.

## 🛠️ Recent Updates

Check the [Release Notes](https://github.com/reesilva/neve/releases) for the latest updates.

## 💡 Need Help?

- 📖 Read the documentation pages in this wiki
- 🐛 [Open an issue](https://github.com/reesilva/neve/issues) for bugs
- 💬 Join discussions in the repository
- 📧 Contact the maintainer

## 📝 Contributing

We welcome contributions! Please see the [Contributing](Contributing) guide for:
- Code style guidelines
- How to add new plugins
- Testing requirements
- Pull request process

---

_Last updated: 2025-10-11_
