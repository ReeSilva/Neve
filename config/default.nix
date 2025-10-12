{ lib, ... }:
let
  avante-overlay = final: prev: {
    vimPlugins = prev.vimPlugins // {
      avante-nvim = prev.vimPlugins.avante-nvim.overrideAttrs (old: {
        src = final.fetchFromGitHub {
          owner = "yetone";
          repo = "avante.nvim";
          rev = "d0f0580d64c391de7b87160a9e66191677e02f54";
          sha256 = "sha256-Jv/0fybim/MyM/cYE+EqV6Om+3J7UCFCkPY1FOwSCqs=";
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
