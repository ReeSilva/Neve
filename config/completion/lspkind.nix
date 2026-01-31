{ lib, config, ... }: {
  options = { lspkind.enable = lib.mkEnableOption "Enable lspkind module"; };
  config = lib.mkIf config.lspkind.enable {
    nixpkgs.overlays = [
      (final: prev: {
        vimPlugins = prev.vimPlugins // {
          lspkind-nvim = prev.vimPlugins.lspkind-nvim.overrideAttrs {
            version = "0-unstable-2026-01-29";
            src = prev.fetchFromGitHub {
              owner = "onsails";
              repo = "lspkind.nvim";
              rev = "c7274c48137396526b59d86232eabcdc7fed8a32";
              sha256 = "sha256-aIopYLm/x1CgCKpcsu9pxpqL0SXXhHDPTM8DKUwGeRw=";
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
