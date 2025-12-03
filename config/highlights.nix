{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    highlights.enable = lib.mkEnableOption "Enable highlights module";
  };
  config = lib.mkIf config.highlights.enable {
    highlight = {
      AvanteSidebarWinSeparator = {
        fg = if pkgs.stdenv.isDarwin then "#DD7878" else "#EEBEBE";
      };
      AvanteSidebarWinHorizontalSeparator = {
        bg = if pkgs.stdenv.isDarwin then "#7C7F93" else "#232634";
      };
    };
  };
}
