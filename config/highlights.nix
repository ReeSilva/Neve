{ lib, config, ... }: {
  options = { highlights.enable = lib.mkEnableOption "Enable keys module"; };
  config = lib.mkIf config.highlights.enable {
    highlight = {
      AvanteSidebarNormal = {
        fg = "#CDD6F4";
        bg = "#1E1E2E";
      };
      AvanteSidebarWinSeparator = {
        fg = "#1E1E2E";
        bg = "#1E1E2E";
      };
      AvanteSidebarWinHorizontalSeparator = {
        fg = "#CDD6F4";
        bg = "#1E1E2E";
      };
    };
  };
}

