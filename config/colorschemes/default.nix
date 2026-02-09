{
  lib,
  config,
  ...
}:
{
  imports = [
    ./ayu.nix
    ./base16.nix
    ./catppuccin.nix
    ./rose-pine.nix
    ./tokyonight.nix
  ];

  options = {
    colorschemes.enable = lib.mkEnableOption "Enable colorschemes module";
  };
  config = lib.mkIf config.colorschemes.enable {
    niquisvim.colorschemes.ayu.enable = lib.mkDefault false;
    base16.enable = lib.mkDefault false;
    catppuccin.enable = lib.mkDefault false;
    rose-pine.enable = lib.mkDefault false;
    niquisvim.colorschemes.tokyonight.enable = lib.mkDefault true;
  };
}
