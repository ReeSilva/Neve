{ lib, config, ... }:
{
  options.niquisvim.colorschemes.ayu.enable = lib.mkEnableOption "Enable Ayu colorscheme";
  config =
    let
      cfg = config.niquisvim.colorschemes.ayu;
    in
    lib.mkIf cfg.enable {
      colorschemes.ayu = {
        enable = true;
      };
    };
}
