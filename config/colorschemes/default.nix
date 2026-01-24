{
  lib,
  config,
  pkgs,
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
    base16.enable = lib.mkDefault (if pkgs.stdenv.isDarwin then true else false);
    catppuccin.enable = lib.mkDefault (if pkgs.stdenv.isLinux then true else false);
    rose-pine.enable = lib.mkDefault false;
    niquisvim.colorschemes.tokyonight.enable = false;
  };
}
