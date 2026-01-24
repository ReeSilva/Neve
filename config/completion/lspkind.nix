{ lib, config, ... }: {
  options = { lspkind.enable = lib.mkEnableOption "Enable lspkind module"; };
  config = lib.mkIf config.lspkind.enable {
    nixpkgs.overlays = [
      (final: prev: {
        vimPlugins = prev.vimPlugins // {
          lspkind-nvim = prev.vimPlugins.lspkind-nvim.overrideAttrs {
            version = "0-unstable-2026-01-24";
            src = prev.fetchFromGitHub {
              owner = "onsails";
              repo = "lspkind.nvim";
              rev = "dbac5149fb5fb1b642266ff268b1e0f4ebac9293";
              sha256 = "sha256-/unY/MaGHC76x5SF0rg6dLc0HOB35Y4vHimquaAWk1M=";
            };
          };
        };
      })
    ];
    plugins.lspkind = {
      enable = true;
      cmp.enable = false;
      settings = {
        symbol_map = {
          Copilot = "";
          Avante = "";
        };
        maxwidth = 50;
        ellipsis_char = "...";
        symbolMap = {
          Copilot = "";
        };
      };
    };
  };
}
