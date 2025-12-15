{ lib, config, ... }:
{
  options = {
    overlays.codecompanion.enable = lib.mkEnableOption "Enable codecompanion.nvim overlay";
  };

  config =
    let
      cfg = config.overlays.codecompanion;
    in
    lib.mkIf cfg.enable {
      nixpkgs.overlays = [
        (final: prev: {
          vimPlugins = prev.vimPlugins // {
            codecompanion-nvim = prev.vimPlugins.codecompanion-nvim.overrideAttrs {
              version = "2025-12-15";
              src = prev.fetchFromGitHub {
                owner = "olimorris";
                repo = "codecompanion.nvim";
                tag = "v18.1.0";
                sha256 = "sha256-TFNX9vbBjEzs4UT2Cz4VPGBJh0qST9kph2UawcsdYjE=";
              };
            };
          };
        })
      ];
    };
}
