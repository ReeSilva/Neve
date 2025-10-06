{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    highlights.enable = lib.mkEnableOption "Enable keys module";
  };
  config = lib.mkIf config.highlights.enable {
    highlight = {
      AvanteSidebarWinSeparator = {
        fg = if pkgs.stdenv.isDarwin then "#DD7878" else "#EEBEBE";
      };
    };
  };
}
