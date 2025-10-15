{ lib, ... }:
let
  avante-overlay = final: prev: {
    vimPlugins = prev.vimPlugins // {
      avante-nvim = prev.vimPlugins.avante-nvim.overrideAttrs (old: {
        version = "0.0.27-unstable-2025-10-16";
        src = final.fetchFromGitHub {
          owner = "yetone";
          repo = "avante.nvim";
          rev = "216ba4a8b2b751e2e86da6f7d8fe59b1a67c1197";
          sha256 = "sha256-soldEWpHBVgHhfXR20aI2P0t5EOLJuqr0eL8Szk+qcg=";
        };
      });
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

  nixpkgs.overlays = [ avante-overlay ];
}
