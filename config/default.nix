{ lib, ... }:
let
  avante-overlay = final: prev: {
    vimPlugins = prev.vimPlugins // {
      avante-nvim = prev.vimPlugins.avante-nvim.overrideAttrs (old: {
        version = "0.0.27-unstable-2025-10-16";
        src = final.fetchFromGitHub {
          owner = "yetone";
          repo = "avante.nvim";
          rev = "f0ad738e5aa15605a73d34b3b0a803b48e47d519";
          sha256 = "sha256-+tsKEMnVd8jd6WabMfOXrWLb+xWiH56LSNgFdz3H7DM=";
        };
      });
    };
  };
  opencode-overlay = final: prev: {
    opencode = prev.opencode.overrideAttrs {
      version = "0.15.7-acp";
      src = prev.fetchFromGitHub {
        owner = "reesilva";
        repo = "opencode";
        rev = "acp-v2";
        sha256 = "sha256-gbXafpZ3zWNZZ0osoXo/lUiaNaBwKNpEMwDnd1JA8Po=";
      };
      node_modules = prev.opencode.node_modules.overrideAttrs {
        inherit (final.opencode) version src;
        outputHash =
          {
            x86_64-linux = "sha256-iJbflfKwDwKrJQgy5jxrEhkyCie2hsEMmiLf2btE60E=";
            aarch64-darwin = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
          }
          .${prev.system};
      };
    };
  };
in
{
  # Import all your configuration modules here
  imports = [
    ./bufferlines
    ./colorschemes
    ./completion
    ./dap
    ./filetrees
    ./git
    ./highlights.nix
    ./keys.nix
    ./languages
    ./lsp
    ./sets
    ./snippets
    ./statusline
    ./telescope
    ./ui
    ./utils
  ];

  bufferlines.enable = lib.mkDefault true;
  colorschemes.enable = lib.mkDefault true;
  completion.enable = lib.mkDefault true;
  dap.enable = lib.mkDefault true;
  filetrees.enable = lib.mkDefault true;
  git.enable = lib.mkDefault true;
  highlights.enable = lib.mkDefault true;
  keys.enable = true;
  languages.enable = true;
  lsp-setup.enable = lib.mkDefault true;
  sets.enable = lib.mkDefault true;
  snippets.enable = lib.mkDefault true;
  statusline.enable = lib.mkDefault true;
  telescope.enable = lib.mkDefault true;
  ui.enable = lib.mkDefault true;
  utils.enable = lib.mkDefault true;

  nixpkgs.overlays = [
    avante-overlay
    opencode-overlay
  ];
}
