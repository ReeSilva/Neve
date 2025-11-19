{ lib, config, ... }:
{
  imports = [
    ./avante.nix
    ./codex-acp.nix
    ./opencode.nix
  ];

  options = {
    overlays.enable = lib.mkEnableOption "Enable overlays";
  };
  config =
    let
      cfg = config.overlays;
    in
    lib.mkIf cfg.enable {
      overlays = {
        avante.enable = lib.mkDefault false;
        codex-acp.enable = lib.mkDefault false;
        opencode.enable = lib.mkDefault false;
      };
    };
}
