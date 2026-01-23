{ lib, config, ... }:
{
  options.niquisvim.utils.direnv.enable = lib.mkEnableOption "Enable Direnv module";
  config =
    let
      cfg = config.niquisvim.utils.direnv;
    in
    lib.mkIf cfg.enable {
      plugins.direnv = {
        enable = true;
      };
    };
}
