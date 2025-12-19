{ lib, config, ... }:
{
  imports = [
    ./avante.nix
    ./codecompanion.nix
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
        avante.enable = lib.mkDefault true;
        codecompanion.enable = lib.mkDefault true;
        codex-acp.enable = lib.mkDefault false;
        opencode.enable = lib.mkDefault false;
      };
    };
}
