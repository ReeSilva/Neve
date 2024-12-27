{ lib, config, ... }: {
  options = { codeium.enable = lib.mkEnableOption "Enable codeium module"; };
  config = lib.mkIf config.codeium.enable {

    plugins.codeium-nvim = {
      enable = true;
      settings = { enable_cmp_source = true; };
    };
  };
}
