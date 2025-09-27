{ lib, config, ... }: {
  options = { lspkind.enable = lib.mkEnableOption "Enable lspkind module"; };
  config = lib.mkIf config.lspkind.enable {
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
      };
    };
  };
}
