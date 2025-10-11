<h1 align="center">
<a href='#'><img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/palette/macchiato.png" width="600px"/></a>
  <br>
  <br>
  <div>
    <a href="https://github.com/reesilva/neve/issues">
        <img src="https://img.shields.io/github/issues/reesilva/neve?color=fab387&labelColor=303446&style=for-the-badge">
    </a>
    <a href="https://github.com/reesilva/neve/stargazers">
        <img src="https://img.shields.io/github/stars/reesilva/neve?color=ca9ee6&labelColor=303446&style=for-the-badge">
    </a>
    <a href="https://github.com/reesilva/neve">
        <img src="https://img.shields.io/github/repo-size/reesilva/neve?color=ea999c&labelColor=303446&style=for-the-badge">
    </a>
    <a href="https://github.com/reesilva/neve/blob/main/LICENCE">
        <img src="https://img.shields.io/static/v1.svg?style=for-the-badge&label=License&message=MIT&logoColor=ca9ee6&colorA=313244&colorB=cba6f7"/>
    </a>
    <br>
            <img href="https://builtwithnix.org" src="https://builtwithnix.org/badge.svg"/>
    </div>
   </h1>

<h1 align="center">❄️ Neve ❄️</h1>
<p align="center"><em>Personal fork of <a href="https://github.com/redyf/Neve">redyf/Neve</a> with custom configurations</em></p>
<h3 align="center">

<details>
    <summary>Showcase</summary>

![Neve](./assets/showcase1.png)
![Neve2](./assets/showcase2.png)
![Neve3](./assets/showcase3.png)
![Neve4](./assets/showcase4.png)

</details>

</h3>

## What's Neve??

Neve (snow in portuguese) is a meticulously crafted custom configuration for Nixvim, designed to revolutionize your development workflow and provide an unparalleled coding experience. This configuration is the culmination of expertise and passion, aiming to provide sane defaults.

## Features

- **Powerful Development Environment:** Neve is tailored to deliver a robust and efficient development environment. With carefully selected plugins, optimized settings, and thoughtful customization, it ensures that your coding journey is both smooth and productive.

- **Nixvim Integration:** Built on the foundation of Nixvim, Neve seamlessly integrates with the powerful Nix package manager. This integration not only simplifies the setup process but also guarantees a consistent and reproducible development environment across different machines.

- **Thoughtful Customization:** Neve doesn't just stop at default settings. It's designed to be easily customizable, allowing you to tailor your Nixvim experience to match your unique preferences and workflow.

- **Extensive Plugin Support:** Benefit from a curated selection of plugins that cover a wide range of programming languages and development tasks. Neve comes with pre-configured plugins to boost your productivity, and you can effortlessly expand its capabilities to suit your specific needs.

- **Custom Plugin Building:** Neve includes custom-built plugins that aren't available in nixpkgs, packaged directly from source using Nix. These plugins are reproducible, version-controlled, and integrate seamlessly with the Nixvim module system.

## Installation

Getting started with this personal fork of Neve is straightforward. Simply follow the installation guide below.

However if you'd like to give it a try before installing, <b>nix run github:reesilva/neve</b> is available!

<details>
    <summary><b>INSTALLATION GUIDE</b></summary>
    I'm assuming you already use nix flakes but in case you don't, please check this tutorial to enable them:

1. Go to flake.nix and add Neve.url = "github:reesilva/neve" to your inputs.

2. Run nix flake update, then Neve should be available for installation.

### Option 1: Using [Flakes](https://nixos.wiki/wiki/Flakes) to install Neve as a Nixvim module.

3. Install it by adding the following code to Nixvim configuration:

```nix
programs.nixvim = {
  enable = true;
  imports = [ inputs.Neve.nixvimModule ];
  # Then configure Nixvim as usual, you might have to lib.mkForce some of the settings
  colorschemes.catppuccin.enable = lib.mkForce false;
  colorschemes.nord.enable = true;
};
```

4. Rebuild your system and you should be done :

### Option 2: Using [Flakes](https://nixos.wiki/wiki/Flakes) to install Neve as a package

After enabling it, follow the steps below:

3. Install it by adding `inputs.Neve.packages.${pkgs.system}.default` to your environment.systemPackages or home.packages if you're using home-manager.

4. Rebuild your system and you should be done :

</details>

<details>
    <summary><b>How to enable/disable modules</b></summary>
For those who aren't familiar with the modular structure of nix, make sure to check this great tutorial made by Vimjoyer.
    
[Modularize NixOS and Home Manager | Great Practices](https://youtu.be/vYc6IzKvAJQ?si=yBSlOrQ4_Ri_KFFh)

Basically all you need to do is go to the default.nix file of each directory and enable/disable the mkDefault options.

Lets say you want to enable neo-tree, in order to do that you'd have to go to config/filetrees/default.nix and change its value
from

```nix
config = lib.mkIf config.filetrees.enable {
  neo-tree.enable = lib.mkDefault false;
};
```

to

```nix
config = lib.mkIf config.filetrees.enable {
  neo-tree.enable = lib.mkDefault true;
};
```

However, sometimes you'll have many plugins in the same directory and it can be quite annoying to change the value for all of them individually. So instead you can disable them all at once in config/default.nix like below:

To disable all UI plugins for example, you can easily do it by going to config/default.nix and toggling the value from true to false:

```nix
  ui.enable = lib.mkDefault false;
```

</details>

## How to customize the install

<p>If you would like to customize Neve to your liking, check this out!</p>

1- Fork the repo (you can also change the name of the fork if you want).

2- Clone the fork.

3- Make the changes you want, such as enabling/disabling plugins, changing colorschemes, neovim options, etc.

4- Add the fork to your flake.nix file, the original is `Neve.url = “github:redyf/Neve”`. If a user called foo forks the repo and renames it to bar, it would be `bar.url = “github:foo/bar”`.

5- Update your inputs and install the fork with `inputs.Neve.packages.${pkgs.system}.default`.

6- Rebuild the system and you should be done!

## Custom Built Plugins

Neve builds some plugins directly from source that aren't available in nixpkgs. These plugins are packaged using `pkgs.vimUtils.buildVimPlugin` and integrated as native Nixvim modules.

### Terragrunt Language Server (terragrunt-ls)

A language server for [Terragrunt](https://terragrunt.gruntwork.io/) that provides IDE features for `.hcl` files.

**Features:**
- 🚀 Automatic LSP attachment to HCL files
- 🔧 Configurable logging for debugging
- 📦 Built from the official [gruntwork-io/terragrunt-ls](https://github.com/gruntwork-io/terragrunt-ls) repository
- 🔄 Automatically kept up-to-date via GitHub Actions

**Usage:**

```nix
{
  terragrunt-ls = {
    enable = true;
    logPath = "/tmp/terragrunt-ls.log"; # Optional: enable logging
    autoAttach = true; # Auto-attach to HCL files
  };
}
```

**Documentation:**
- Module implementation: [`config/lsp/terragrunt-ls.nix`](config/lsp/terragrunt-ls.nix)
- Detailed docs: [`config/lsp/README-terragrunt-ls.md`](config/lsp/README-terragrunt-ls.md)
- Setup guide: [`TERRAGRUNT-LS-SETUP.md`](TERRAGRUNT-LS-SETUP.md)
- Example config: [`examples/terragrunt-ls-config.nix`](examples/terragrunt-ls-config.nix)

**Automatic Updates:**

The terragrunt-ls plugin is automatically kept up-to-date via a [GitHub Action](.github/workflows/update-plugins.yml) that:
- 🔄 Runs daily to check for upstream updates
- 🤖 Automatically calculates new Nix hashes
- ✅ Tests the build before creating a PR
- 📬 Creates pull requests with detailed changelog information

See the [Workflows README](.github/workflows/README.md) for more details on automated maintenance.

## Quick Start

Neve is highly customizable. Here are some important files for configuring your environment:

- **config/default.nix:** This file contains the main configuration file. You can add or delete plugins as you like.

- **config/sets/set.nix:** In this file, you can add or remove options and adjust their specific settings.

- **config/keys.nix:** This file contains custom key mappings. You can add your own keyboard shortcuts to enhance productivity.

- **config/lsp/lsp-nvim.nix:** Here you can configure your preferred Language Servers.

- **config/lsp/conform.nix:** Configure Formatters for the desired languages.

- **config/languages/nvim-lint.nix:** Set up linters for specific languages.

## Contribution

Contributions are welcome! Feel free to [open an issue](https://github.com/reesilva/neve/issues) to report problems or suggest improvements. For the original project, visit [redyf/Neve](https://github.com/redyf/Neve).

## License

This project is licensed under the [MIT License](LICENCE). See the LICENSE file for more details.

## Support

Encountered an issue or have a question? Visit our [Issue Tracker](https://github.com/reesilva/neve/issues). For the original project support, visit [redyf/Neve issues](https://github.com/redyf/Neve/issues) or message redyf on Discord.

Happy coding!
