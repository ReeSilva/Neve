{
  lib,
  pkgs,
  pkgs-master,
  inputs,
  ...
}:
{
  # Import all your configuration modules here
  imports = [
    ./ai
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
  highlights.enable = lib.mkDefault false;
  keys.enable = true;
  languages.enable = true;
  lsp-setup.enable = lib.mkDefault true;
  sets.enable = lib.mkDefault true;
  snippets.enable = lib.mkDefault true;
  statusline.enable = lib.mkDefault true;
  telescope.enable = lib.mkDefault true;
  ui.enable = lib.mkDefault true;
  utils.enable = lib.mkDefault true;

  niquisvim.ai.enable = lib.mkDefault true;
  nixpkgs = {
    config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "github-copilot-cli" ];
    overlays = [
      inputs.opencode.overlays.default
      (final: prev: {
        opencode = prev.opencode.override {
          inherit (pkgs-master) bun;
        };
      })
      (final: prev: {
        vimPlugins = prev.vimPlugins // {
          codecompanion-nvim = prev.vimPlugins.codecompanion-nvim.overrideAttrs {
            pname = "codecompanion.nvim";
            name = "vimplugin-codecompanion.nvim-19.9.0-unstable-2026-04-05";
            version = "v19.9.0-unstable-2026-04-05";
            src = prev.fetchFromGitHub {
              owner = "olimorris";
              repo = "codecompanion.nvim";
              tag = "v19.9.0";
              hash = "sha256-czV3xRahscMDRLpRRKiqKkbL2wsKkaTUA59U3erZUWU=";
            };
          };
        };
      })
    ];
  };

  opts.shell = lib.getExe pkgs.fish;
  plugins = {
    lz-n.enable = true;
  };
  extraPlugins = with pkgs.vimPlugins; [
    lzn-auto-require
  ];
  extraConfigLuaPost = ''
    require('lzn-auto-require').enable()
  '';

  luaLoader.enable = true;
}
