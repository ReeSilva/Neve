{ lib, ... }:
let
  avante-overlay = final: prev: {
    vimPlugins = prev.vimPlugins // {
      avante-nvim = prev.vimPlugins.avante-nvim.overrideAttrs (old: {
        src = final.fetchFromGitHub {
          owner = "yetone";
          repo = "avante.nvim";
          rev = "a9458f1835f13d055a4891136164388f01f8d3a8";
          sha256 = "sha256-76g91HAsjwZyJ6vRDnIAv0eHkK/OY3SDMlJCUelViKM=";
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
