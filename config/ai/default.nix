{ lib, config, ... }:
{
  imports = [
    ./avante.nix
    ./codecompanion.nix
    ./copilot.nix
  ];

  options = {
    niquisvim.ai.enable = lib.mkEnableOption "Enable AI tools for Niquisvim";
  };
  config =
    let
      cfg = config.niquisvim.ai;
    in
    lib.mkIf cfg.enable {
      avante.enable = lib.mkDefault true;
      copilot.enable = lib.mkDefault true;
      niquisvim.ai.codecompanion.enable = lib.mkDefault true;
    };
}
