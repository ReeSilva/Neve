{ lib, ... }:
let
  avante-overlay = final: prev: {
    vimPlugins = prev.vimPlugins // {
      avante-nvim = prev.vimPlugins.avante-nvim.overrideAttrs (old: {
        src = final.fetchFromGitHub {
          owner = "yetone";
          repo = "avante.nvim";
          rev = "f092bb3ec0acf87b838e082209b6a7eddcbf5940";
          sha256 = "sha256-zKDp9It/VgUD8BN5ktTmfbQX0s3SBo20T8no8nwsyfY=";
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
