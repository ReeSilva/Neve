{ lib, config, ... }: {
  options = { ufo.enable = lib.mkEnableOption "Enable lsp-nvim module"; };
  config =
    lib.mkIf config.ufo.enable { plugins.nvim-ufo = { enable = true; }; };
}
