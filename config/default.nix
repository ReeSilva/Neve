{ lib, ... }:
let
  avante-overlay = final: prev: {
    vimPlugins = prev.vimPlugins // {
      avante-nvim = prev.vimPlugins.avante-nvim.overrideAttrs (old: {
        version = "0.0.27-unstable-2025-10-16";
        src = final.fetchFromGitHub {
          owner = "yetone";
          repo = "avante.nvim";
          rev = "0971d8f421d8bf936d6036db1d17635064b8dc9f";
          sha256 = "sha256-uLiqFFT5OO0ZpieXtnolmwaVVqHAyB7RxQvONH9Lob4=";
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
