{ lib, config, ... }: {
  options = { dropbar.enable = lib.mkEnableOption "Enable dropbar module"; };
  config =
    lib.mkIf config.dropbar.enable { plugins.dropbar = { enable = true; }; };
}
