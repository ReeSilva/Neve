{ lib, config, ... }:
{
  options.niquisvim.colorschemes.tokyonight.enable = lib.mkEnableOption "Enable Tokyonight colorscheme";
  config =
    let
      cfg = config.niquisvim.colorschemes.tokyonight;
    in
    lib.mkIf cfg.enable {
      colorschemes.tokyonight = {
        enable = true;
        settings = {
            style = "night";
          };
      };
    };
}
