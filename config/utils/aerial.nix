{ lib, config, ... }:
{
  options.aerial.enable = lib.mkEnableOption "Enable Aerial module";
  config = lib.mkIf config.aerial.enable {
    plugins.aerial = {
      enable = true;
    };
  };
}
